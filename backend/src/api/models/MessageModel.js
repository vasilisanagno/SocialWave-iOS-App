import mongoose from "mongoose"

const messageSchema = new mongoose.Schema({
    sender: {
        type: mongoose.Schema.Types.ObjectId,
        required: true,
        ref: 'User'
    },
    text: {
        type: String
    },
    createdAt: {
        type: Date,
        default: Date.now
    }
})

const Message = mongoose.model('Message', messageSchema, 'Messages')

export { Message }