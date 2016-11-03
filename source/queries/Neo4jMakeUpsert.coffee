uuid = require('uuid')

Neo4jMakeUpsert = {

# creates a template assuming the values of fields come from
# line.property where properties is
# a combyne template with the frorm { header#: value }
# nodeType is the type of node in neo4j
# nodeFields is the list of fields in the node.
    makeCSVUpsert: (nodeType, nodeFields) ->
        properties = "n.id=line.{{header0}}"
        for field,i in nodeFields
            properties += ",n." + field + "=line.{{header" + i + "}}"

        create = "n.created=timestamp(), " + properties
        update = "n.updated=timestamp(), " + properties

        return "MERGE (n:" + nodeType + " { id: line.{{header0}} })" +
                " ON CREATE SET " + create +
                " ON MATCH SET " + update

    makeCSVEdgeUpsert: (connections, edgeType, edgeFields) ->
        sourceNodeType = connections.origin
        destinationNodeType  = connections.destination
        sourceNodeIdName = connections.originid ? "id"
        destinationNodeIdName = connections.destinationid ? "id"

        sourceMatchNodeType = connections.originmatchtype ? sourceNodeType
        destinationMatchNodeType = connections.destinationmatchtype ? destinationNodeType
        sourceMatchIdName = connections.originmatchidname ? sourceNodeIdName
        destinationIdName = connections.destinationmatchidname ? destinationNodeIdName

        properties = "e.sourceId=line.{{header0}},e.destinationId=line.{{header1}},"
        properties += "e.sourceKind='"+sourceNodeType+"',e.destinationKind='"+destinationNodeType+"',"
        properties += "e.id=(line.{{header0}}+'_'+line.{{header1}})"
        for field,i in edgeFields
            properties += ",e." + field + "=line.{{header" + i + "}}"

        create = "e.created=timestamp(), " + properties
        update = "e.updated=timestamp(), " + properties

        return "MATCH " +
                "(a:" + sourceMatchNodeType + " { "+sourceMatchIdName+":line.{{header0}} })"+
                ","+
#                "-[:" +edgeType+" { sourceId:line.{{header0}}, destinationId:line.{{header1}} }]->"+
                "(b:" + destinationMatchNodeType + " { "+destinationIdName+":line.{{header1}} }) " +
                "MERGE " +
                "(a)-"+
                "[e:" + edgeType +
                " { sourceId:line.{{header0}}, destinationId:line.{{header1}} }"+
                "]"+
                "->(b)" +
                " ON CREATE SET " + create +
                " ON MATCH SET " + update
}
module.exports = Neo4jMakeUpsert
# assumes:
# nodeData.type
# if nodeData.id doesn't exist, a uuid is assigned.
#    makeUpsert: (nodeData) ->
#        nodeData.id = uuid.v4() unless (nodeData.id?)
#
#        properties = (("n." + key + " = {" + key + "}, ") for key,value of nodeData).reduce((t, s) -> t + s)
#        properties = properties.slice(0, -2) # remove the trailing comma.
#
#        create = "n.created=timestamp(), " + properties
#        update = "n.updated=timestamp(), " + properties
#
#        return "MERGE (n:#{data.type} { id: {id} })" +
#                " ON CREATE SET " + create +
#                " ON MATCH SET " + update
#}

