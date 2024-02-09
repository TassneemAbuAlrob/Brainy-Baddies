const express = require('express')
const Chat = require('../models/chat')

const router = express.Router()

router.get('/chats', async (req, res) => {
    try{
        let chats = await Chat.find().populate({
            path:'sender',
            ref: 'User'
        })
        return res.status(200).json(chats)
    }catch(err){
        return res.status(500).json(err.message)
    }
}) 

router.post('/chats/:id/messages', async (req, res) => {
    try{
        const {id} = req.params
        const message = req.body

        let chat = await Chat.findOne({ _id: id })
        chat.messages.push(message)
        await chat.save()

        return res.status(200).json(true)
    }catch(err){
        return res.status(500).json(err.message)
    }
})

module.exports = router