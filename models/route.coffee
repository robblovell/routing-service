Mongoose = require('mongoose')
Schema = require('mongoose').Schema
ObjectId = Mongoose.Schema.Types.ObjectId

RouteSchema = new Schema(
    {
        to: String,
        skus: [String]
        routes: [String]
    },
    { strict: false }
)
module.exports = { model: Mongoose.model("Route", RouteSchema), schema: RouteSchema }
