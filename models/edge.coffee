Mongoose = require('mongoose')
Schema = require('mongoose').Schema

EdgeSchema = new Schema(
    {
        id: String
        type: String
    },
    { strict: false}
)

module.exports = { model: Mongoose.model("Edge", EdgeSchema), schema: EdgeSchema }
