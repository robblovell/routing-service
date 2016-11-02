Sweep Eligible: 10017944
Neither: 10080934

----------------------------------------------
OPTIONAL MATCH query0 = (p:Product {id: '10017944'})
-[b:BELONGS_TO]->(warehouse)
-[:SWEPT_TO]->(superdc)
-[:RESUPPLIES *0..1]->(bdwp)
-[:FLOWS_THROUGH *0..1]->(leafnode)
-[lm:LAST_MILE]->(r:Region)
WHERE toInt(b.Inventory) >= 1 AND (r.PostalCode= '85281' OR r.PostalCode='00000') AND p.isSweepsEligible = '1'
    WITH COLLECT(query0) as items0
    UNWIND (CASE items0 WHEN [] then [null] else items0 end) as result0
    WITH COLLECT(result0) as rows0

OPTIONAL MATCH query1 = (p:Product {id: '10017944'})
-[b:BELONGS_TO]->(warehouse)
-[:SIPS_TO]->(superdc)
-[:RESUPPLIES *0..1]->(bdwp)
-[:FLOWS_THROUGH *0..1]->(leafnode)
-[lm:LAST_MILE]->(r:Region)
WHERE toInt(b.Inventory) >= 1 AND (r.PostalCode= '85281' OR r.PostalCode='00000') AND p.isSipsEligible = '1'
    WITH COLLECT(query1) as items1, rows0 as rows0
    UNWIND (CASE items1 WHEN [] then [null] else items1 end) as result1
    WITH rows0 + COLLECT(result1) as rows1

OPTIONAL MATCH query2 = (p:Product {id: '10080934'})
-[b:BELONGS_TO]->(warehouse)
-[:RESUPPLIES *0..1]->(bdwp)
-[:FLOWS_THROUGH *0..1]->(leafnode)
-[lm:LAST_MILE]->(r:Region)
WHERE toInt(b.Inventory) >= 1 AND (r.PostalCode= '85281' OR r.PostalCode='00000')
   WITH COLLECT(query2) AS items2, rows1 as rows1
    UNWIND (CASE items2 WHEN [] then [null] else items2 end) as result2
    WITH rows1 + COLLECT(result2) as rows2

UNWIND rows2 AS path
WITH path,
reduce(ccost=0,    r IN relationships(path)[1..-1]| ccost+toInt(r.CustomerCost)) AS totalCustCost,
reduce(scost=0,    r IN relationships(path)[1..-1]| scost+ toInt(r.SellerCost)) AS totalSellerCost,
reduce(bcost=0,    r IN relationships(path)[1..-1]| bcost+ toInt(r.BuildDirectCost)) AS totalBDCost,
reduce(leadtime=0, r IN relationships(path)[1..-1]| leadtime+ toInt(r.LaneLeadTime)) AS totalLeadTime,
reduce(packtime=0, r in relationships(path)[1..-1]| packtime + toInt(r.PickandPackLeadTime)) AS PickandPackLeadTime
ORDER BY totalCustCost,PickandPackLeadTime+totalLeadTime,totalSellerCost,totalBDCost ASC

RETURN
extract(n in nodes(path)[1..-1] | n.id) as Warehouses,
extract(n in nodes(path)[1..-1] | n.Name) as WarehouseNames,
extract(n in nodes(path)[1..-1] | labels(n)) as WarehouseType,
last(nodes(path)[1..-1]).PostalCode as LastMileFromZip,
last(nodes(path)[1..-1]).id as LastMileWH,
extract(r in relationships(path)[1..-1] | type(r)) as Relations,
extract(r in relationships(path)[1..-1] | r.CustomerCost) as CustomerCost,
extract(r in relationships(path)[1..-1] | r.SellerCost) as Sellercost,
extract(r in relationships(path)[1..-1] | r.BuildDirectCost) as BDcost,
extract(r in relationships(path)[1..-1] | r.LaneLeadTime) as LeadTime
----------------------------------------------

MATCH query0 = (p:Product {id: '10017944'})
-[b:BELONGS_TO]->(warehouse)
-[tf:TRANSFERS]->(superdc)
-[:RESUPPLIES *0..1]->(bdwp)
-[:TRANSFERS *0..1]->(leafnode)
-[lm:LAST_MILE]->(r:Region)

WHERE toInt(b.Inventory) >= 1 AND (r.PostalCode= '85281' OR r.PostalCode='00000')
AND (
(tf.type='SIPS_TO' AND p.isSipsEligible='1') OR
(tf.type='SWEEPS_TO' AND p.isSweepsEligible='1') OR
(tf.type='FLOWS_THROUGH')
)
    WITH COLLECT(query0) as rows0

MATCH query1 = (p:Product {id: '10080934'})
-[b:BELONGS_TO]->(warehouse)
-[:RESUPPLIES *0..1]->(bdwp)
-[:TRANSFERS *0..1]->(leafnode)
-[lm:LAST_MILE]->(r:Region)
WHERE toInt(b.Inventory) >= 1 AND (r.PostalCode= '85281' OR r.PostalCode='00000')
   WITH rows0 + COLLECT(query1) AS rows1

UNWIND rows1 as path

WITH path,
reduce(ccost=0,    r IN relationships(path)[1..-1]| ccost+toInt(r.CustomerCost)) AS totalCustCost,
reduce(scost=0,    r IN relationships(path)[1..-1]| scost+ toInt(r.SellerCost)) AS totalSellerCost,
reduce(bcost=0,    r IN relationships(path)[1..-1]| bcost+ toInt(r.BuildDirectCost)) AS totalBDCost,
reduce(leadtime=0, r IN relationships(path)[1..-1]| leadtime+ toInt(r.LaneLeadTime)) AS totalLeadTime,
reduce(packtime=0, r in relationships(path)[1..-1]| packtime + toInt(r.PickandPackLeadTime)) AS PickandPackLeadTime
ORDER BY totalCustCost,PickandPackLeadTime+totalLeadTime,totalSellerCost,totalBDCost ASC

RETURN
extract(n in nodes(path)[1..-1] | n.id) as Warehouses,
extract(n in nodes(path)[1..-1] | n.Name) as WarehouseNames,
extract(n in nodes(path)[1..-1] | labels(n)) as WarehouseType,
last(nodes(path)[1..-1]).PostalCode as LastMileFromZip,
last(nodes(path)[1..-1]).id as LastMileWH,
extract(r in relationships(path)[1..-1] | type(r)) as Relations,
extract(r in relationships(path)[1..-1] | r.CustomerCost) as CustomerCost,
extract(r in relationships(path)[1..-1] | r.SellerCost) as Sellercost,
extract(r in relationships(path)[1..-1] | r.BuildDirectCost) as BDcost,
extract(r in relationships(path)[1..-1] | r.LaneLeadTime) as LeadTime

MATCH p=(sweepNode)-[:SWEEPS_TO]->()-[:RESUPPLIES]->()-[:LEAF]->(consumer:Consumer) 
WHERE sweepNode.kind = 'Sweeper' and sweepNode.inventory > 0.5
   WITH COLLECT(p) AS rows1

MATCH q=(fullNode)-[:LEAF]->(consumer:Consumer)
WHERE  fullNode.inventory > 0 
   WITH rows1 + COLLECT(q) AS rows2

MATCH o=(fullNode)-[:RESUPPLIES]->()-[:LEAF]->(consumer:Consumer) 
WHERE  fullNode.inventory > 0 
   WITH rows2 + COLLECT(o) AS rows3

UNWIND rows3 as rows
RETURN rows AS shortestPath, reduce(cost=0, r IN relationships(rows)| cost+lm.cost) AS totalCost
ORDER BY totalCost ASC
LIMIT 10