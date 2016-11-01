should = require('should')
assert = require('assert')
mock = require('mock-require')
Neo4jMakeUpsert = require('../source/queries/Neo4jMakeUpsert')
describe 'Neo4j Make Upsert Statement', () ->

    it 'it constructs CSV node upsert statement.', () ->
        nodeFields = ["ProductId","FreightClass","NMFCCode","ExcludeCourier",
            "isAccessory","isSweepsEligible","isSuperdcEligible","SipsEligible"]

        upsertStatement = Neo4jMakeUpsert.makeCSVUpsert("Product", nodeFields)
        upsertStatement.should.be.equal("MERGE (n:Product { id: line.{{header0}} }) \
ON CREATE SET n.created=timestamp(), n.id=line.{{header0}},n.ProductId=line.{{header0}},\
n.FreightClass=line.{{header1}},n.NMFCCode=line.{{header2}},n.ExcludeCourier=line.{{header3}},\
n.isAccessory=line.{{header4}},n.isSweepsEligible=line.{{header5}},n.isSuperdcEligible=line.{{header6}},\
n.SipsEligible=line.{{header7}} ON MATCH SET n.updated=timestamp(), n.id=line.{{header0}},\
n.ProductId=line.{{header0}},n.FreightClass=line.{{header1}},n.NMFCCode=line.{{header2}},\
n.ExcludeCourier=line.{{header3}},n.isAccessory=line.{{header4}},n.isSweepsEligible=line.{{header5}},\
n.isSuperdcEligible=line.{{header6}},n.SipsEligible=line.{{header7}}")
        return

    it 'it constructs CSV node upsert statement and injects fields.', () ->
        nodeFields = ["ProductId","FreightClass","NMFCCode","ExcludeCourier",
            "isAccessory","isSweepsEligible","isSuperdcEligible","SipsEligible"]
        injectFields = {isSip: '1', isSweep: 0}

        upsertStatement = Neo4jMakeUpsert.makeCSVUpsert("Product", nodeFields, injectFields)
        upsertStatement.should.be.equal("MERGE (n:Product { id: line.{{header0}} }) \
ON CREATE SET n.created=timestamp(), n.id=line.{{header0}},n.ProductId=line.{{header0}},\
n.FreightClass=line.{{header1}},n.NMFCCode=line.{{header2}},n.ExcludeCourier=line.{{header3}},\
n.isAccessory=line.{{header4}},n.isSweepsEligible=line.{{header5}},n.isSuperdcEligible=line.{{header6}},\
n.SipsEligible=line.{{header7}},isSip='1',isSweep='0' ON MATCH SET n.updated=timestamp(), n.id=line.{{header0}},\
n.ProductId=line.{{header0}},n.FreightClass=line.{{header1}},n.NMFCCode=line.{{header2}},\
n.ExcludeCourier=line.{{header3}},n.isAccessory=line.{{header4}},n.isSweepsEligible=line.{{header5}},\
n.isSuperdcEligible=line.{{header6}},n.SipsEligible=line.{{header7}},isSip='1',isSweep='0'")
        return

    it 'it constructs CSV edge upsert statement with assumed id names.', () ->
        nodeFields = ["Node1Id","Node2Id","Field1","Field2"]

        connections = {
            origin: "node1"
            destination: "node2"
        }
        upsertStatement = Neo4jMakeUpsert.makeCSVEdgeUpsert(connections, "EDGE", nodeFields)
        upsertStatement.should.be.equal("MATCH (a:node1 { id:line.{{header0}} }),(b:node2 { id:line.{{header1}} }) MERGE (a)-[e:EDGE { sourceId:line.{{header0}}, destinationId:line.{{header1}} }]->(b) ON CREATE SET e.created=timestamp(), e.sourceId=line.{{header0}},e.destinationId=line.{{header1}},e.sourceKind='node1',e.destinationKind='node2',e.id=(line.{{header0}}+'_'+line.{{header1}}),e.Node1Id=line.{{header0}},e.Node2Id=line.{{header1}},e.Field1=line.{{header2}},e.Field2=line.{{header3}} ON MATCH SET e.updated=timestamp(), e.sourceId=line.{{header0}},e.destinationId=line.{{header1}},e.sourceKind='node1',e.destinationKind='node2',e.id=(line.{{header0}}+'_'+line.{{header1}}),e.Node1Id=line.{{header0}},e.Node2Id=line.{{header1}},e.Field1=line.{{header2}},e.Field2=line.{{header3}}")

        return

    it 'it constructs CSV edge upsert statement with explicit id names.', () ->
        nodeFields = ["Node1Id","Node2Id","Field1","Field2"]

        connections = {
            origin: "node1"
            destination: "node1"
            originid: "nodeid"
            destinationid: "node_id"
        }
        upsertStatement = Neo4jMakeUpsert.makeCSVEdgeUpsert(connections, "EDGE", nodeFields)
        upsertStatement.should.be.equal("MATCH (a:node1 { nodeid:line.{{header0}} }),(b:node1 { node_id:line.{{header1}} }) MERGE (a)-[e:EDGE { sourceId:line.{{header0}}, destinationId:line.{{header1}} }]->(b) ON CREATE SET e.created=timestamp(), e.sourceId=line.{{header0}},e.destinationId=line.{{header1}},e.sourceKind='node1',e.destinationKind='node1',e.id=(line.{{header0}}+'_'+line.{{header1}}),e.Node1Id=line.{{header0}},e.Node2Id=line.{{header1}},e.Field1=line.{{header2}},e.Field2=line.{{header3}} ON MATCH SET e.updated=timestamp(), e.sourceId=line.{{header0}},e.destinationId=line.{{header1}},e.sourceKind='node1',e.destinationKind='node1',e.id=(line.{{header0}}+'_'+line.{{header1}}),e.Node1Id=line.{{header0}},e.Node2Id=line.{{header1}},e.Field1=line.{{header2}},e.Field2=line.{{header3}}")

        return