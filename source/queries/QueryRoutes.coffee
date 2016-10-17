iQuery = require('./iQuery')
class Query extends iQuery
    constructor: (@config={}) ->

    query: (context, repo, callback) ->
        query = "MATCH (s:Product {id: '#{context.sku}'})
        -[b:BELONGS_TO]->(warehouse)
        -[:RESUPPLIES | SWEPT_TO *0..2]->()
        -[:FLOWS_THROUGH *0..1]->(leafnode)
        -[r:LAST_MILE]->(c:Region)
        where toInt(b.inventory) > 1 and (r.zip='#{context.to}' or r.zip='000')
        With warehouse, leafnode
        MATCH path=(warehouse)
        -[:RESUPPLIES | SWEPT_TO *0..2]->()
        -[:FLOWS_THROUGH *0..1]->(leafnode)
        With path, reduce(ccost=0, r IN relationships(path)| ccost+toInt(r.custCost)) AS
        totalCustCost,reduce(scost=0, r IN relationships(path)| scost+ toInt(r.sellerCost)) AS totalSellerCost,
        reduce(bcost=0, r IN relationships(path)| bcost+ toInt(r.bdCost)) AS totalBDCost
        ORDER BY totalCustCost,totalSellerCost,totalBDCost ASC
        return extract(n in nodes(path) | n.id) AS
        Warehouses,last(nodes(path)).postalCode AS
        LastMileFromZip,extract(rel in relationships(path) | type(rel)) as
        Relations, totalCustCost,totalSellerCost,totalBDCost"
        repo.run(query, {}, (error, result) =>
            callback(error, result)
            return
        )
module.exports = Query