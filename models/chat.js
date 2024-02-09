const mongoose = require('mongoose');

const ChatSchema = new mongoose.Schema({

    sender:{
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
        required: true
    },

    messages:[{
        sender: String,
        message: String,
        send_date: String,
        
    }]
})

const ChatModel = mongoose.model('Chat', ChatSchema)

module.exports = ChatModel