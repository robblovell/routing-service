Mongoose = require('mongoose')
Schema = require('mongoose').Schema

EdgeSchema = new Schema(
    {
        sourcekind: String
        sourceid: String
        destinationkind: String
        destinationid: String
        properties: Schema.Types.Mixed
    },
    { strict: false, _id: false }
)

module.exports = { model: Mongoose.model("Edge", EdgeSchema), schema: EdgeSchema }
