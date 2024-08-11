import { Notification } from '../models/NotificationModel.js'
import moment from 'moment'

//fetches all the notifications about the current user
export async function getNotifForTheCurrentUser(username) {
    const notifications = await Notification.aggregate([
        { $match: { usernameReceiver: username } },
        { $sort: { createdAt: -1 } },
        {
            $lookup: {
                from: "Users",
                localField: "notifSenderId",
                foreignField: "_id",
                as: "senderInfo"
            }
        },
        // Unwind the result since lookup returns an array
        { $unwind: "$senderInfo" },
        {
            $lookup: {
                from: "Posts",
                localField: "notifReferringPost",
                foreignField: "_id",
                as: "postDetails"
            }
        },
        // Unwind the result, including preserve empty results with preserveNullAndEmptyArrays
        { $unwind: { path: "$postDetails", preserveNullAndEmptyArrays: true } },
        {
            $project: {
                "id": "$_id",
                "notificationType": 1,
                "notificationSeen": 1,
                "createdAt": 1,
                "senderProfile": "$senderInfo.profileImage",
                "senderUsername": "$senderInfo.username",
                "postImage": { $arrayElemAt: ["$postDetails.images", 0] }
            }
        }
    ])

    const now = moment()
    const yesterday = moment().subtract(1, 'days').startOf('day')
    const formattedNotifications = notifications.map(notification => {
        return {
            ...notification,
            createdAt: 
            (moment(notification.createdAt).isSame(now, 'day')) ?
            moment(notification.createdAt).from(now).charAt(0).toUpperCase() + moment(notification.createdAt).from(now).slice(1) // Returns "a few seconds ago", "20 minutes ago", etc.
            : (moment(notification.createdAt).isSame(yesterday, 'day')) ?
                "Yesterday"
            :
                moment(notification.createdAt).from(now).charAt(0).toUpperCase() + moment(notification.createdAt).from(now).slice(1) // Returns "2 days ago", "3 weeks ago", etc.
        }
    })

    await Notification.updateMany({
        usernameReceiver: username, notificationSeen: false
    },
    {
        notificationSeen: true
    })
    return formattedNotifications
}

//fetches the unseen notifications and returns the number of these
export async function getNumberOfUnseenNotif(username) {
    const unseenNotifications = await Notification.find({usernameReceiver: username, notificationSeen: false})
    return unseenNotifications.length
}

//deletes all notifications for the current user
export async function deleteNotifsOfTheCurrentUser(username) {
    await Notification.deleteMany({usernameReceiver: username})
}