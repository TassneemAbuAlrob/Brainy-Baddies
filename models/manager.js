const mongoose = require('mongoose')

const ManagerSchema = new mongoose.Schema({
    email:{
        type: String,
        required: true
    },

    password:{
        type: String,
        required: true
    }
})

const ManagerModel = mongoose.model('Manager', ManagerSchema)

module.exports = ManagerModel