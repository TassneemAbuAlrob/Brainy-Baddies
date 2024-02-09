const mongoose = require('mongoose');

const CommentSchema = new mongoose.Schema({
    commenter:{
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User'
    },

    // parent:{
    //     type: mongoose.Schema.Types.ObjectId,
    //     required: true
    // },

    date:{
        type: String,
        required: true
    },

    content:{
        type: String,
        required: true
    }
})

const CommentModel = mongoose.model('Comment', CommentSchema)

module.exports = CommentModel