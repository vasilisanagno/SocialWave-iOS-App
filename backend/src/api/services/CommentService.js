import { Comment } from '../models/CommentModel.js'
import { Post } from '../models/PostModel.js'
import { Notification } from '../models/NotificationModel.js'
import mongoose from 'mongoose'
import moment from 'moment'

//retrieves the comments for a post from the database
export async function getComments(postId) {
    const userComments = await Comment.aggregate([
        { $match: { post: new mongoose.Types.ObjectId(postId) } }, 
        { $sort: { createdAt: -1 } }, 
        {
            $lookup: {
                from: "Users",
                localField: "user",
                foreignField: "_id",
                as: "userDetails"
            }
        },
        { $unwind: "$userDetails" }, 
        {
            $project: {
                id: "$_id",
                content: 1,
                user: 1,
                post: 1,
                _id: 0,
                likes: 1,
                createdAt: 1,
                username: "$userDetails.username",
                profileImage: "$userDetails.profileImage"
            }
        }
    ])
    
    const now = moment()
    const yesterday = moment().subtract(1, 'days').startOf('day')
    for(let i=0; i < userComments.length; i++) {
        if (moment(userComments[i].createdAt).isSame(now, 'day')) {
            const fromNowString = moment(userComments[i].createdAt).from(now)
            userComments[i].createdAt = fromNowString.charAt(0).toUpperCase() + fromNowString.slice(1) // Returns "a few seconds ago", "20 minutes ago", etc.
        } else if (moment(userComments[i].createdAt).isSame(yesterday, 'day')) {
            userComments[i].createdAt = "Yesterday"
        } else {
            const fromNowString = moment(userComments[i].createdAt).from(now)
            userComments[i].createdAt = fromNowString.charAt(0).toUpperCase() + fromNowString.slice(1) // Returns "2 days ago", "3 weeks ago", etc.
        }
    }
    return userComments
}

//adds a new comment to the database for a specific post
export async function addCommentToPost(postId, userId, content) {
    await Comment.create(
        {
            content: content,
            user: userId,
            post: postId,
            likes: []
        }
    )
    const post = await Post.findById(postId)
    if(post.userId.toString()!==userId) {
        //creates the notification
        await Notification.create(
            {
                usernameReceiver: post.username,
                notifSenderId: userId,
                notificationSeen: false,
                notificationType: 'comment',
                notifReferringPost: postId
            }
        )
    }
    const userComments = await getComments(postId)
   
    return userComments
}

//deletes a comment from the database for a specific post
export async function deleteCommentFromPost(postId, userId, content) {
    await Comment.deleteOne(
        {
            content: content,
            user: userId,
            post: postId
        }
    )
    const userComments = await getComments(postId)
    
    return userComments
}

//adds a new like to the comment in a specific post
export async function addLikeToCommentForPost(postId, userId, content, currentUser) {
    const userComments = await Comment.findOneAndUpdate({
        post: postId,
        user: userId,
        content: content
    },
    { $addToSet: { likes: currentUser } },
    { new: true },
    { $project: { _id: 0, content: 0, user: 0, post: 0, createdAt: 0, likes: 1} })
    
    return userComments.likes
}

//deletes a like from a comment in a specific post
export async function deleteLikeFromCommentForPost(postId, userId, content, currentUser) {
    const userComments = await Comment.findOneAndUpdate({
        post: postId,
        user: userId,
        content: content
    },
    { $pull: { likes: currentUser } },
    { new: true },
    { $project: { _id: 0, content: 0, user: 0, post: 0, createdAt: 0, likes: 1} })
    
    return userComments.likes
}