const express = require('express')
const QuizModel = require('../models/quizz')

const router = express.Router()

router.get('/quizzes', async (req, res) => {
    try{
        let quizzes = await QuizModel.find()
        return res.status(200).json(quizzes)
    }catch(err){
        return res.status(500).json(err.message)
    }
})

router.get('/quizzes/count', async function(req, res){
    try{
        let count = await QuizModel.countDocuments()
        return res.status(200).json(count)
    }catch(err){
        return res.status(500).json(err.message)
    }
})

router.get('/quizzes/:id', async (req, res) => {
    try{
        const {id} = req.params
        let quiz = await QuizModel.findById(id)
        return res.status(200).json(quiz)
    }catch(err){
        return res.status(500).json(err.message)
    }
})


router.post('/quizzes', async (req, res) => {
    try{
        console.log(req.body);
        let quiz = await QuizModel.create(req.body)
        return res.status(200).json(quiz)
    }catch(err){
        console.log(err.message);
        return res.status(500).json(err.message)
    }
})

router.put('/quizzes/:id', async (req, res) => {
    try{
        const {id} = req.params
        let quiz = await QuizModel.updateOne({_id:id},req.body)
        return res.status(200).json(quiz)
    }catch(err){
        return res.status(500).json(err.message)
    }
})

router.delete('/quizzes/:id', async (req, res) => {
    try{
        let quiz = await QuizModel.deleteOne({ _id: req.params.id})
        return res.status(200).json(quiz)
    }catch(err){
        return res.status(500).json(err.message)
    }
})


module.exports = router