Mongoose = require('mongoose')
Schema = require('mongoose').Schema
ObjectId = Mongoose.Schema.Types.ObjectId
ImportSchema = new Schema(
    {
        count: Number
        name: String # importer name, filename if not given
        template: String # optional template (derived from name)
        mount: String # optional (in the template)
        date: String
    }
    { strict: false }
)

module.exports = { model: Mongoose.model("Import", ImportSchema), schema: ImportSchema }
