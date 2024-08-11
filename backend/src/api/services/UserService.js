import { User } from '../models/UserModel.js'
import { Post } from '../models/PostModel.js'
import { Notification } from '../models/NotificationModel.js'
import moment from 'moment'

//finds users using regular expression for search
export async function searchUsersUsingRegex(regexPattern) {
    const users = await User.find({ username: { $regex: regexPattern } }, 
        '_id fullname username description profileImage receiving sending friends posts'
    ).lean()
    for(let i=0; i < users.length; i++) {
        users[i].id = users[i]._id.toString()
        delete users[i]._id
    }  
    return users
}

//updates the user profile details
export async function updateUser(data, profileImage, username) {
    const user = await User.findOneAndUpdate({username: username}, {
        description: data.description != "" ? data.description : null,
        fullname: data.fullname != "" ? data.fullname : null,
        profileImage: profileImage != 0 ? profileImage : null
    }, 
    {
        new: true,
        projection: '_id fullname username description profileImage receiving sending friends posts',
        lean: true
    })
    user.id = user._id.toString()
    delete user._id
    return user
}

//finds the friends by username and the details of them
export async function findFriendsOfTheCurrentUser(username) {
    const friends = await User.findOne({username: username})
        .populate({
            path: 'friends',
            select: '_id fullname username profileImage description posts receiving sending friends'
        }).lean()
    for(let i=0; i < friends.friends.length; i++) {
        friends.friends[i].id = friends.friends[i]._id.toString()
        delete friends.friends[i]._id
    }
    return friends.friends
}

//finds the receiving requests by username and the details of them
export async function findRequestsOfTheCurrentUser(username) {
    const requests = await User.findOne({username: username})
        .populate({
            path: 'receiving',
            select: '_id fullname username profileImage description posts receiving sending friends'
        }).lean()
    for(let i=0; i < requests.receiving.length; i++) {
        requests.receiving[i].id = requests.receiving[i]._id.toString()
        delete requests.receiving[i]._id
    }
    return requests.receiving
}

//accepts the receiving request of the a user in the current user 
export async function acceptRequestOfTheCurrentUser(userId, requesterId) {
    //updates the user who is accepting the request
    const updatedUser = await User.findByIdAndUpdate(userId, {
        $pull: { receiving: requesterId, sending: requesterId },
        $addToSet: { friends: requesterId }
    }, { new: true })

    //updates the user who sent the request
    await User.findByIdAndUpdate(requesterId, {
        $pull: { sending: userId, receiving: userId },
        $addToSet: { friends: userId }
    })
    return { receiving: updatedUser.receiving, friends: updatedUser.friends }
}

//rejects the receiving request of the a user in the current user
export async function rejectRequestOfTheCurrentUser(userId, requesterId) {
    //updates the user who is accepting the request
    const updatedUser = await User.findByIdAndUpdate(userId, {
        $pull: { receiving: requesterId }
    }, { new: true })

    //updates the user who sent the request
    await User.findByIdAndUpdate(requesterId, {
        $pull: { sending: userId }
    })
    return { receiving: updatedUser.receiving, friends: updatedUser.friends }
}

//sends a request in a possible friend
export async function sendRequestInAUser(senderId, receiverId) {
    //updates the user who is sending the request
    const updatedUser = await User.findByIdAndUpdate(senderId, {
        $addToSet: { sending: receiverId }
    }, { new: true })

    //updates the user who received the request
    const receiver = await User.findByIdAndUpdate(receiverId, {
        $addToSet: { receiving: senderId }
    }, {new: true})
    //creates the notification
    await Notification.create(
        {
            usernameReceiver: receiver.username,
            notifSenderId: senderId,
            notificationSeen: false,
            notificationType: 'request',
            notifReferringPost: null
        }
    )
    return updatedUser.sending
}

//unsends the request of a possible friend
export async function unsendRequestInAUser(senderId, receiverId) {
    //updates the user who is unsends the request
    const updatedUser = await User.findByIdAndUpdate(senderId, {
        $pull: { sending: receiverId }
    }, { new: true })

    //updates the user who unreceived the request
    await User.findByIdAndUpdate(receiverId, {
        $pull: { receiving: senderId }
    })
    return updatedUser.sending
}

//deletes the friendship between the two users(current and the friend that select the current user to delete)
export async function deleteFriendship(currentUserId, friendUserId) {
    const updatedUser = await User.findByIdAndUpdate(currentUserId, {
        $pull: { friends: friendUserId }
    }, { new: true })

    await User.findByIdAndUpdate(friendUserId, {
        $pull: { friends: currentUserId }
    })

    return updatedUser.friends
}

//gets the sending/receiving requests and the friends of a user
export async function getSRF(username) {
    
    const user = await User.findOne({username: username})
    return {sending: user.sending, receiving: user.receiving, friends: user.friends}
}

//inserts the post and updates the post array of the user
export async function insertPostImages(data, images, username) {
    const post = await Post.create({
        text: data.caption,
        username: username,
        userId: data.userId,
        images: images
    })

    const userPostsDetails = await User.findOneAndUpdate({username: username},
        { 
            $push: { 
                posts: { 
                    $each: [post._id], 
                    $position: 0 
                } 
            } 
        },
        { new: true }
    )
    .populate({
        path: 'posts',
        select: '_id text username userId images likes createdAt'
    }).lean()
    
    const now = moment()
    const yesterday = moment().subtract(1, 'days').startOf('day')
    for(let i=0; i < userPostsDetails.posts.length; i++) {
        userPostsDetails.posts[i].id = userPostsDetails.posts[i]._id.toString()
        delete userPostsDetails.posts[i]._id

        if (moment(userPostsDetails.posts[i].createdAt).isSame(now, 'day')) {
            const fromNowString = moment(userPostsDetails.posts[i].createdAt).from(now)
            userPostsDetails.posts[i].createdAt = fromNowString.charAt(0).toUpperCase() + fromNowString.slice(1) // Returns "a few seconds ago", "20 minutes ago", etc.
        } else if (moment(userPostsDetails.posts[i].createdAt).isSame(yesterday, 'day')) {
            userPostsDetails.posts[i].createdAt = "Yesterday"
        } else {
            const fromNowString = moment(userPostsDetails.posts[i].createdAt).from(now)
            userPostsDetails.posts[i].createdAt = fromNowString.charAt(0).toUpperCase() + fromNowString.slice(1) // Returns "2 days ago", "3 weeks ago", etc.
        }
    }

    const user = await User.findOne({
        username: username
    }).lean()

    user.id = user._id.toString()
    delete user._id

    return {user: user, posts: userPostsDetails.posts}
}

//finds the suggested friends of the current user and returns 6 of them
export async function findSuggestedFriendsOfCurrentUser(username) {
    // First, get the current user's ID and friend list
    const currentUser = await User.findOne({ username: username }, '_id friends').lean()

    // Use aggregation to find friends of friends, excluding the current user's direct friends and themselves
    const suggestedFriends = await User.aggregate([
        {
            $match: {
                _id: { $in: currentUser.friends } // First level friends
            }
        },
        {
            $lookup: {
                from: 'Users',
                localField: 'friends',
                foreignField: '_id',
                as: 'friendsOfFriends'
            }
        },
        {
            $unwind: '$friendsOfFriends'
        },
        {
            $replaceRoot: { newRoot: "$friendsOfFriends" }
        },
        {
            $match: {
                _id: { $nin: currentUser.friends.concat([currentUser._id]) } // Exclude direct friends and self
            }
        },
        {
            $group: {
                _id: '$_id',
                fullname: { $first: '$fullname' },
                username: { $first: '$username' },
                profileImage: { $first: '$profileImage' },
                description: { $first: '$description' },
                posts: { $first: '$posts' },
                mutualConnections: { $sum: 1 } // Count occurrences to rank by common connections
            }
        },
        {
            $sort: { mutualConnections: -1 } // Sort by the number of mutual connections
        },
        {
            $limit: 6 // Limit the result to the top 6 suggested friends
        },
        {
            $project: { // Select only the necessary fields for the output
                id: '$_id',
                _id: 0,
                username: 1,
                fullname: 1,
                profileImage: 1
            }
        }
    ])

    return suggestedFriends
}