import { User } from '../models/UserModel.js'
import { Post } from '../models/PostModel.js'
import { Notification } from '../models/NotificationModel.js'
import moment from 'moment'

//retrieves the posts of a user from the database
export async function retrieveUserAndPosts(username) {
    const posts = await User.findOne({username: username})
        .populate({
            path: 'posts',
            select: '_id text username userId images likes createdAt',
            options: { sort: { 'createdAt': -1 } }
        }).lean()

    const now = moment()
    const yesterday = moment().subtract(1, 'days').startOf('day')
    for(let i=0; i < posts.posts.length; i++) {
        posts.posts[i].id = posts.posts[i]._id.toString()
        delete posts.posts[i]._id

        if (moment(posts.posts[i].createdAt).isSame(now, 'day')) {
            const fromNowString = moment(posts.posts[i].createdAt).from(now)
            posts.posts[i].createdAt = fromNowString.charAt(0).toUpperCase() + fromNowString.slice(1) // Returns "a few seconds ago", "20 minutes ago", etc.
        } else if (moment(posts.posts[i].createdAt).isSame(yesterday, 'day')) {
            posts.posts[i].createdAt = "Yesterday"
        } else {
            const fromNowString = moment(posts.posts[i].createdAt).from(now)
            posts.posts[i].createdAt = fromNowString.charAt(0).toUpperCase() + fromNowString.slice(1) // Returns "2 days ago", "3 weeks ago", etc.
        }
    }

    const user = await User.findOne({username: username}).lean()
    
    user.id = user._id.toString()
    delete user._id
    return {user: user, posts: posts.posts}
}

//retrieves the users that liked a post from the database
export async function getLikes(post) {
    const user_likes = await Post.findOne({_id: post})
        .populate({
            path: 'likes',
            select: '_id fullname username description profileImage receiving sending friends posts',
            options: { sort: { 'createdAt': -1 } }
        }).lean()
    for(let i=0; i < user_likes.likes.length; i++) {
        user_likes.likes[i].id = user_likes.likes[i]._id.toString()
        delete user_likes.likes[i]._id
    }
    return user_likes.likes
}

//updates the post caption
export async function updateCaption(postId, newCaption) {
    
    //Find the post by ID and update its caption
    const updatedPost = await Post.findOneAndUpdate(
        {_id: postId},
        { text: newCaption },
        { 
            new: true,
            projection: '_id text username userId images likes createdAt',
            lean: true 
        }
    )

    updatedPost.id = updatedPost._id.toString()
    const now = moment()
    const yesterday = moment().subtract(1, 'days').startOf('day')

    if (moment(updatedPost.createdAt).isSame(now, 'day')) {
        const fromNowString = moment(updatedPost.createdAt).from(now)
        updatedPost.createdAt = fromNowString.charAt(0).toUpperCase() + fromNowString.slice(1) // Returns "a few seconds ago", "20 minutes ago", etc.
    } else if (moment(updatedPost.createdAt).isSame(yesterday, 'day')) {
        updatedPost.createdAt = "Yesterday"
    } else {
        const fromNowString = moment(updatedPost.createdAt).from(now)
        updatedPost.createdAt = fromNowString.charAt(0).toUpperCase() + fromNowString.slice(1) // Returns "2 days ago", "3 weeks ago", etc.
    }
    delete updatedPost._id
    return updatedPost 
}

//deletes the post by postId
export async function deletePostById(username, postId) {
    await User.findOneAndUpdate(
        { username: username, posts: postId },
        { $pull: { posts: postId } }
    )
    await Notification.deleteMany({notifReferringPost: postId})
    await Post.deleteOne({_id: postId})
}

//gets the post of the current user's friends
export async function getFriendsPosts(username) {
    const currentUser = await User.findOne({ username: username })

    const friendsPosts = await Post.aggregate([
        { $match: { userId: { $in: currentUser.friends } } },
        { $sort: { createdAt: -1 } },
        {
            $lookup: {
                from: "Users",
                localField: "userId",
                foreignField: "_id",
                as: "userDetails"
            }
        },
        { $unwind: "$userDetails" },
        {
            $project: {
                id: "$_id",
                text: 1,
                userId: 1,
                username: 1,
                profileImage: "$userDetails.profileImage",
                images: 1,
                likes: 1,
                createdAt: 1,
                _id: 0
            }
        }
    ])

    const now = moment()
    const yesterday = moment().subtract(1, 'days').startOf('day')
    for(let i=0; i < friendsPosts.length; i++) {
        
        if (moment(friendsPosts[i].createdAt).isSame(now, 'day')) {
            const fromNowString = moment(friendsPosts[i].createdAt).from(now)
            friendsPosts[i].createdAt = fromNowString.charAt(0).toUpperCase() + fromNowString.slice(1) // Returns "a few seconds ago", "20 minutes ago", etc.
        } else if (moment(friendsPosts[i].createdAt).isSame(yesterday, 'day')) {
            friendsPosts[i].createdAt = "Yesterday"
        } else {
            const fromNowString = moment(friendsPosts[i].createdAt).from(now)
            friendsPosts[i].createdAt = fromNowString.charAt(0).toUpperCase() + fromNowString.slice(1) // Returns "2 days ago", "3 weeks ago", etc.
        }
    }
    return friendsPosts
}

//adds a like in the post
export async function addLikeToPost(userId, postId) {
    const updatedPost = await Post.findOneAndUpdate(
        { _id: postId },
        { $addToSet: { likes: userId } },
        { new: true },
        { $project: { _id: 0, text: 0, username: 0, userId: 0, images: 0, likes: 1} }
    ).lean()

    if(updatedPost.userId.toString()!==userId) {
        //creates the notification
        await Notification.create(
            {
                usernameReceiver: updatedPost.username,
                notifSenderId: userId,
                notificationSeen: false,
                notificationType: 'like',
                notifReferringPost: updatedPost._id
            }
        )
    }
    return updatedPost.likes
}

//deletes a like in the post
export async function deleteLikeFromPost(userId, postId) {
    const updatedPost = await Post.findOneAndUpdate(
        { _id: postId },
        { $pull: { likes: userId } }, 
        { new: true },
        { $project: { _id: 0, text: 0, username: 0, userId: 0, images: 0, likes: 1} }
    ).lean()
    return updatedPost.likes
}