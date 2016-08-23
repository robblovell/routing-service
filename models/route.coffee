Mongoose = require('mongoose')
Schema = require('mongoose').Schema
ObjectId = Mongoose.Schema.Types.ObjectId
PathSchema = new Schema(
    {

    },
    { strict: false, _id: false }
)
RouteSchema = new Schema(
    {
        to: String,
        skus: [String]
        routes: [PathSchema]
    },
    { strict: true }
)
module.exports = { model: Mongoose.model("Route", RouteSchema), schema: RouteSchema }
