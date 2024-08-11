import mongoose from "mongoose"

const chatSchema = new mongoose.Schema({
    username: {
        type: String,
        required: true
    },
    chatMember: {
        type: mongoose.Schema.Types.ObjectId,
        required: true,
        ref: 'User'
    },
    lastMessageSeen: {
        type: Boolean
    },
    lastMessage: {
        type: String
    },
    lastMessageCreatedAt: {
        type: Date
    },
    messages: [{
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Message'
    }],
    createdAt: {
        type: Date,
        default: Date.now
    }
})

const Chat = mongoose.model('Chat', chatSchema, 'Chats')

export { Chat }