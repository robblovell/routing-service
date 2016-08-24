Mongoose = require('mongoose')
Schema = require('mongoose').Schema

NodeSchema = new Schema(
    {
        id: String
    },
    { strict: false, _id: false}
)

module.exports = { model: Mongoose.model("Node", NodeSchema), schema: NodeSchema }
