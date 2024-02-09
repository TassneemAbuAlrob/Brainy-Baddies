const express = require('express');
const router = express.Router()
const Manager = require('../models/manager')

router.post('/managers/login', async (req, res) => {
    try{
        let {
            email,
            password
        } = req.body

        let manager = await Manager.findOne({
            email: email
        })

        if(!manager) {
            return res.status(404).send('no manager found')
        }

        if(manager.password === password){
            return res.status(200).send('logged in')
        }

        return res.status(400).send('unauthorized')
    }catch(err){
        return res.status(500).send(err.message)
    }
})

module.exports = router