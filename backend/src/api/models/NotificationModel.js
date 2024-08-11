import mongoose from "mongoose"

const notificationSchema = new mongoose.Schema({
    usernameReceiver: {
        type: String,
        required: true
    },
    notifSenderId: {
        type: mongoose.Schema.Types.ObjectId,
        required: true,
        ref: 'User'
    },
    notificationType: {
        type: String
    },
    notifReferringPost: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Post'
    },
    notificationSeen: {
        type: Boolean
    },
    createdAt: {
        type: Date,
        default: Date.now
    }
})

const Notification = mongoose.model('Notification', notificationSchema, 'Notifications')

export { Notification }