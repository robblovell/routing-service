async = require('async')
iGraphRepository = require('./iGraphRepository')
combyne = require('combyne')
neo4j = require('neo4j-driver').v1
uuid = require('uuid')

class Neo4jRepository extends iGraphRepository
    constructor: (@config) ->
        @buffer = null
        if !@config.url?
            @config.url = 'bolt://neo4j:macro7@localhost'
        if (@config.url.indexOf(':') > -1 and @config.url.indexOf('@') > -1)
            @config.user = @config.url.split("//")[1].split(":")[0]
            @config.pass = @config.url.split("//")[1].split("@")[0].split(":")[1]
            @config.url = @config.url.replace(@config.user+":"+@config.pass+"@","")

        @neo4j = neo4j.driver(@config.url, neo4j.auth.basic(@config.user, @config.pass))
        return

    find: (example, callback) ->
        # todo:: other types of queries, paging etc.
        cypher = "Match (n:#{example.type}) RETURN n"
        @run(cypher, {}, callback)

    run: (cypher, data, callback=null) ->
        if (@buffer? || !callback?)
            @buffer.run(cypher, data)
        else
            session = @neo4j.session()
            session.run(cypher, data)
            .then((result) =>
                session.close()
                if (result and result.records.length > 0)
                    if (result.records[0] and result.records[0].toObject? and
                    result.records[0].toObject().n and result.records[0].toObject().n.properties)
                        results = []
                        for record in result.records
                            results.push(record.toObject().n.properties)
                        callback(null, results)
                    else
                        results = []
                        for record in result.records
                            results.push(record.toObject())
                        callback(null, results)
                else
                    callback(null, "[]")
                return
            )
            .catch((error) =>
                console.log("Error:"+error)
                session.close()
                callback(error, null)
                return
            )
        return

    get: (example, callback) ->
        if (example.id == "" or example.id == null)
            callback(null,"{}")
            return
        cypher = "MATCH (n:#{example.type}) WHERE n.id = {id} RETURN n"
        console.log("Cypher: "+cypher)
        @run(cypher, example, callback)

    makeQuery = (query, type) ->
        paging = ""
        if query.skip? && query.limit?
            paging += " SKIP "+query.skip
        if query.limit?
            paging += " LIMIT "+query.limit

        queryStr = ""
        if query.query?
            queryStr = " WHERE "
            example = JSON.parse(query.query)
            if typeof example is 'string'
                queryStr = " WHERE "+example # .replace(/(\S+\s*=)/g,"n.$&") # put a n. in front of all keys.
            else
                for k,v of example
                    if typeof v is 'string'
                        queryStr+= type+"."+k+"='"+v+"' and "
                    else
                        queryStr+= type+"."+k+"="+v+" and "
                queryStr = queryStr.slice(0,-5)
        return [queryStr, paging]

    index: (nodesType, query, callback) ->

        [queryStr,paging] = makeQuery(query,'n')

        cypher = "MATCH (n:#{nodesType}) #{queryStr} RETURN n #{paging}"

        console.log("Cypher: "+cypher)
        @run(cypher, {}, callback)

    add: (cypher, callback) ->
        throw new Error 'not implemented'

    indexEdge: (edgesType, query, callback) ->

        [queryStr,paging] = makeQuery(query,'e')

        cypher = "MATCH ()-[e:#{edgesType}]->() #{queryStr} RETURN e #{paging}"

        console.log("Cypher: "+cypher)
        @run(cypher, {}, callback)

    getEdge: (example, callback) ->
        if (example.id == "" or example.id == null)
            callback(null,"{}")
            return
        cypher = "MATCH ()-[n:#{example.type}]->() WHERE n.id = {id} RETURN n LIMIT 1"
        console.log("Cypher: "+cypher)
        @run(cypher, example, callback)

    setEdge: (params, edge, callback) =>
        makeUpsert = (params, edge) =>
            data = {}
            for key,value of edge
                data[key] = value
            edge.id = uuid.v4() unless (edge.id?)
            # for logging:
#            propstring = (("r."+key+"='"+value+"', ") for key,value of edge).reduce((t,s) -> t + s)
#            propstring = propstring.slice(0,-2)
#
#            if data.id? then ifid = " {id:"+data.id+"}" else ""
#
#            upsertString = "MATCH "+
#                "(a:"+params.sourcekind+" {id:'"+params.sourceid+"'}), "+
#                "(b:"+params.destinationkind+" {id:'"+params.destinationid+"'}) "+
#                "MERGE (a)-[r:"+params.kind+ifid+"]->(b) "+
#                "ON CREATE SET r.created=timestamp(), "+propstring+" "+
#                "ON MATCH SET r.updated=timestamp(), "+propstring
#            upsertString = combyne(upsertString).render(params)
#            console.log(upsertString)  # if math.floor(math.random(0,500)) == 1

            if data.id? then ifidprop = " {id:{id}}" else ""

            properties = (("r."+key+"={"+key+"}, ") for key,value of edge).reduce((t,s) -> t + s)
            properties = properties.slice(0,-2) # remove the trailing comma.

            upsertStatement = "MATCH "+
                "(a:"+params.sourcekind+" {id:{sourceid}}), "+
                "(b:"+params.destinationkind+" {id:{destinationid}}) "+
                "MERGE (a)-[r:"+params.kind+ifidprop+"]->(b) "+
                "ON CREATE SET r.created=timestamp(), "+properties+" "+
                "ON MATCH SET r.updated=timestamp(), "+properties

            for key,value of params
                data[key] = value
            console.log(upsertStatement)
            return [data, edge, upsertStatement]

        [data, edge, upsert] = makeUpsert(params, edge)
        if (@buffer? || !callback?)
            @buffer.run(upsert, data)
        else
            session = @neo4j.session()
            session.run(upsert, data)
            .then((result) =>
                session.close()
                callback(null, result)
            )
            .catch((error) =>
                session.close()
                callback(error, null)
            )
        return


    set: (id, obj, callback) =>
        makeUpsert = (data) ->
            data.id = uuid.v4() unless (data.id?)
            properties = (("n."+key+" = {"+key+"}, ") for key,value of data).reduce((t,s) -> t + s)
            properties = properties.slice(0,-2) # remove the trailing comma.
            create = "n.created=timestamp(), "+properties
            update = "n.updated=timestamp(), "+properties
            #         1234567890123456789012345678901234567890

            upsertStatement = "MERGE (n:#{data.type} { id: {id} }) ON CREATE SET "+
                create+
                " ON MATCH SET "+
                update

            return [data, upsertStatement]

        obj.id = id if (id?)
        [data, upsert] = makeUpsert(obj)

        if (@buffer? || !callback?)
            @buffer.run(upsert, data)
        else
            session = @neo4j.session()
            session.run(upsert, data)
            .then((result) =>
                session.close()
                callback(null, result)
            )
            .catch((error) =>
                session.close()
                callback(error, null)
            )
        return

    deleteEdge: (edgeid, edgekind, callback) ->
        makeDelete = (edgeid, edgekind) =>
            data = {edgeid:edgeid}
            deleteString = "MATCH "+
                "()-[r:"+edgekind+" {id:"+edgeid+"}]->() "+
                "DELETE r"

            console.log(deleteString)
            deleteStatement = "MATCH "+
                "()-[r:"+edgekind+" {id:{edgeid}}"+"]->() "+
                "DELETE r"

            console.log(deleteStatement)
            return [data, deleteStatement]

        [data, deleteStatement] = makeDelete(edgeid, edgekind)
        if (@buffer? || !callback?)
            @buffer.run(deleteStatement, data)
        else
            session = @neo4j.session()
            session.run(deleteStatement, data)
            .then((result) =>
                session.close()
                callback(null, result)
            )
            .catch((error) =>
                session.close()
                callback(error, null)
            )
        return

    delete: (nodeid, nodekind, callback) ->
        makeDelete = (nodeid, nodekind) =>
            data = {nodeid:nodeid}
            deleteString = "MATCH "+
                "(n:"+nodekind+" {id:"+nodeid+"}) "+
                "DELETE n"

            console.log(deleteString)
            deleteStatement = "MATCH "+
                "(n:"+nodekind+" {id:{nodeid}}"+") "+
                "DELETE n"

            console.log(deleteStatement)
            return [data, deleteStatement]

        [data, deleteStatement] = makeDelete(nodeid, nodekind)
        if (@buffer? || !callback?)
            @buffer.run(deleteStatement, data)
        else
            session = @neo4j.session()
            session.run(deleteStatement, data)
            .then((result) =>
                session.close()
                callback(null, result)
            )
            .catch((error) =>
                session.close()
                callback(error, null)
            )
        return

    pipeline: () ->
        @session = @neo4j.session()
        @buffer = @session.beginTransaction()
        return

    exec: (callback) =>
        @buffer.commit()
        .subscribe({
            onCompleted: () =>
                @session.close()
                @buffer = null
                callback(null, "success")

                return
            onError: (error) =>
                @session.close()
                @buffer = null
                callback(error, null)
                return
        })


module.exports = Neo4jRepository
