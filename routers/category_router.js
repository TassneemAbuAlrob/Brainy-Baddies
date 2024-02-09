const express = require('express')
const CategoryModel = require('../models/category')

const router = express.Router()

router.get('/categories', async (req, res) => {
    try{
        let categories = await CategoryModel.find()
        return res.status(200).json(categories)
    }catch(err){
        return res.status(500).send(err.message)
    }
})
router.get('/categories/count', async (req, res) => {
    try{
        let count = await CategoryModel.countDocuments()
        return res.status(200).json(count)
    }catch(err){
        return res.status(500).send(err.message)
    }
})

router.post('/categories', async (req, res) => {
    try{
        let category = await CategoryModel.create(req.body)
        return res.status(200).json(category)
    }catch(e){
        return res.status(500).send(e.message)
    }
})

module.exports = router