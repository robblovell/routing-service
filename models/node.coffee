Mongoose = require('mongoose')
Schema = require('mongoose').Schema

NodeSchema = new Schema(
    {
        id: String
        type: String
    },
    { strict: false}
)

module.exports = { model: Mongoose.model("Node", NodeSchema), schema: NodeSchema }
