Mongoose = require('mongoose')
Schema = require('mongoose').Schema

EdgeSchema = new Schema(
    {
        id: String
        sourceKind: String
#        sourceId: String
        destinationKind: String
#        destinationId: String
        properties: Schema.Types.Mixed
    },
    { strict: false, _id: false }
)

module.exports = { model: Mongoose.model("Edge", EdgeSchema), schema: EdgeSchema }
