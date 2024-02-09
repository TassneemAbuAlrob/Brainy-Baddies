const mongoose = require('mongoose')

const PostSchema = new mongoose.Schema({
    text_content: {
        type: String,
        required: true
    },

    video: {
        type: String,
        default: null
    },

    type:{
        type: String,
        default: 'any'
    },

    image_content: {
        type: String,
        default: null
    },

    user:{
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
        required: true
    },

    date: {
        type: String,
        required: true
    },

    comments: [{
        content: {
            type: String,
            required: true
        },
        date: {
            type: String,
            required: true
        },
        user: {
            type: mongoose.Schema.Types.ObjectId,
            required: true
        }
    }],

    likes: [{
        date: {
            type: String,
            required: true
        },

        user:{
            type: mongoose.Schema.Types.ObjectId,
            ref: 'User',
            required: true
        }
    }]
})


const PostModel = mongoose.model('Post', PostSchema)

module.exports = PostModel