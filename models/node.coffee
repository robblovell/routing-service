Mongoose = require('mongoose')
Schema = require('mongoose').Schema

NodeSchema = new Schema(
    {
        id: String
        properties: Schema.Types.Mixed
    },
    { strict: false, _id: false}
)

module.exports = { model: Mongoose.model("Node", NodeSchema), schema: NodeSchema }
