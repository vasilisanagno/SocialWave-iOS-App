import mongoose from "mongoose"

const UserSchema = new mongoose.Schema({
    fullname: {
        type: String
    },
    username: {
        type: String,
        required: true,
        unique: true,
        trim: true
    },
    email: {
        type: String,
        required: true,
        unique: true,
        trim: true
    },
    password: {
        type: String,
        required: true
    },
    description: {
        type: String
    },
    profileImage: {
        type: Buffer
    },
    receiving: [{
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User'
    }],
    sending: [{
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User'
    }],
    friends: [{
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User'
    }],
    posts: [{
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Post'
    }]
})

const User = mongoose.model('User', UserSchema, 'Users')

export { User }