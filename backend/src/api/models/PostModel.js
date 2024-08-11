import mongoose from "mongoose"

const PostSchema = new mongoose.Schema({
    text: {
        type: String,
        trim: true
    },
    username: {
        type: String,
        required: true,
        trim: true
    },
    userId: {
        type: mongoose.Schema.Types.ObjectId,
        required: true,
        ref: 'User'
    },
    images: [{
        type: Buffer,
        required: true
    }],
    likes: [{
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User'
    }]
}, {
    timestamps: true
})

const Post = mongoose.model('Post', PostSchema, 'Posts')

export { Post }