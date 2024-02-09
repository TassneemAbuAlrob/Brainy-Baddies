const mongoose = require('mongoose')

const AgeSchema = new mongoose.Schema({
    name: {
        type: String,
        required: true
    },

    from:{
        type: Number,
        required: true
    },

    to: {
        type: Number,
        required: true
    }
})

const AgeModel = mongoose.model('Age', AgeSchema)

module.exports = AgeModel