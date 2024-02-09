const express = require('express')
const AgeModel = require('../models/age')

const router = express.Router()

router.get('/ages', async (req, res) => {
    try{
        let ages = await AgeModel.find()
        return res.status(200).json(ages)
    }catch(err){
        return res.status(500).send(err.message)
    }
})

router.get('/ages/count', async (req, res) => {
    try{
        let count = await AgeModel.countDocuments()
        return res.status(200).json(count)
    }catch(err){
        return res.status(500).send(err.message)
    }
})

router.post('/ages', async (req, res) => {
    try{
        let age = await AgeModel.create(req.body)
        return res.status(200).json(age)
    }catch(e){
        return res.status(500).send(e.message)
    }
})

module.exports = router