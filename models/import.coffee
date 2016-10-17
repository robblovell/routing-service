Mongoose = require('mongoose')
Schema = require('mongoose').Schema
ObjectId = Mongoose.Schema.Types.ObjectId
PathSchema = new Schema(
    {

    },
    { strict: false, _id: false }
)
ImportSchema = new Schema(
    {
        source: [String]
        type: [String] # edge/node
        name: [String] # Satellite, Warehouse, Seller, Region, Product
    },
    { strict: true }
)
module.exports = { model: Mongoose.model("Import", ImportSchema), schema: ImportSchema }
