const mongoose = require('mongoose')

const QuizSchema = new mongoose.Schema({
    name: {
        type: String,
        required: true
    },

    category:{
        type: String,
        required: true
    },

    questions:[{
        title: {
            type: String,
            required: true
        },

        correct_answer_index:{
            type: Number,
            required: true
        },

        answers:[{
            title:{
                type: String,
                required: true
            }
        }],
    }]
})

const QuizModel = mongoose.model('Quiz', QuizSchema)

module.exports = QuizModel