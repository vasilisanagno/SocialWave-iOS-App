import jwt from "jsonwebtoken"
import { searchUsersUsingRegex, updateUser, 
    findFriendsOfTheCurrentUser, insertPostImages,
    findRequestsOfTheCurrentUser,
    acceptRequestOfTheCurrentUser,
    rejectRequestOfTheCurrentUser,
    sendRequestInAUser, unsendRequestInAUser, getSRF,
    findSuggestedFriendsOfCurrentUser, deleteFriendship
} from "../services/UserService.js"

//handles the searching of the users
export const searchUsers = async (req,res) => {
    const { text } = req.query
    let token = req.headers.authorization

    if(!token) {
        res.status(401).json({ error: "Unauthorized access" })
        return
    }

    token = token.split(' ')[1]
    try {
        jwt.verify(token, process.env.ACCESS_TOKEN_SECRET)
    } catch(error) {
        res.status(401).json({ error: "Unauthorized access" })
        return
    }

    try {
        if(text != "") {
            const regexPattern = new RegExp("^[^a-zA-Z0-9]*" + text, 'i') // 'i' for case-insensitive
            // Performing the search using the regex pattern
            const users = await searchUsersUsingRegex(regexPattern)
            res.json(users)
        }
        else {
            res.json([])
        }
    } catch(error) {
        console.log(error)
    }
}

//handles the editing of profile
export const editProfile = async (req,res) => {
    const data = req.body
    const profileImage = req.file.buffer
    let token = req.headers.authorization
    let decoded
    
    if(!token) {
        res.status(401).json({ error: "Unauthorized access" })
        return
    }

    token = token.split(' ')[1]
    try {
        decoded = jwt.verify(token, process.env.ACCESS_TOKEN_SECRET)
    } catch(error) {
        res.status(401).json({ error: "Unauthorized access" })
        return
    }

    try {
        const user = await updateUser(data, profileImage, decoded.username)
        res.json(user)
    } catch(error) {
        console.log(error)
    }
}

//handles the finding of friends in the profile of user
export const findFriends = async (req,res) => {
    const { username } = req.query
    let token = req.headers.authorization
    
    if(!token) {
        res.status(401).json({ error: "Unauthorized access" })
        return
    }

    token = token.split(' ')[1]
    try {
        jwt.verify(token, process.env.ACCESS_TOKEN_SECRET)
    } catch(error) {
        res.status(401).json({ error: "Unauthorized access" })
        return
    }

    try {
        const friends = await findFriendsOfTheCurrentUser(username)
        res.json(friends)
    } catch(error) {
        console.log(error)
    }
}

//handles the finding of requests in the profile of the current user
export const findRequests = async (req,res) => {
    let token = req.headers.authorization
    let decoded
    
    if(!token) {
        res.status(401).json({ error: "Unauthorized access" })
        return
    }

    token = token.split(' ')[1]
    try {
        decoded = jwt.verify(token, process.env.ACCESS_TOKEN_SECRET)
    } catch(error) {
        res.status(401).json({ error: "Unauthorized access" })
        return
    }

    try {
        const requests = await findRequestsOfTheCurrentUser(decoded.username)
        res.json(requests)
    } catch(error) {
        console.log(error)
    }
}

//handles the accept of request in the profile of the current user
export const acceptRequest = async (req,res) => {
    const { userId, requesterId } = req.query
    let token = req.headers.authorization
    
    if(!token) {
        res.status(401).json({ error: "Unauthorized access" })
        return
    }

    token = token.split(' ')[1]
    try {
        jwt.verify(token, process.env.ACCESS_TOKEN_SECRET)
    } catch(error) {
        res.status(401).json({ error: "Unauthorized access" })
        return
    }

    try {
        const user = await acceptRequestOfTheCurrentUser(userId, requesterId)
        res.json(user)
    } catch(error) {
        console.log(error)
    }
}

//handles the reject of request in the profile of the current user
export const rejectRequest = async (req,res) => {
    const { userId, requesterId } = req.query
    let token = req.headers.authorization
    
    if(!token) {
        res.status(401).json({ error: "Unauthorized access" })
        return
    }

    token = token.split(' ')[1]
    try {
        jwt.verify(token, process.env.ACCESS_TOKEN_SECRET)
    } catch(error) {
        res.status(401).json({ error: "Unauthorized access" })
        return
    }

    try {
        const user = await rejectRequestOfTheCurrentUser(userId, requesterId)
        res.json(user)
    } catch(error) {
        console.log(error)
    }
}

//handles the sending of request in a user
export const sendRequest = async (req,res) => {
    const { senderId, receiverId } = req.query
    let token = req.headers.authorization
    
    if(!token) {
        res.status(401).json({ error: "Unauthorized access" })
        return
    }

    token = token.split(' ')[1]
    try {
        jwt.verify(token, process.env.ACCESS_TOKEN_SECRET)
    } catch(error) {
        res.status(401).json({ error: "Unauthorized access" })
        return
    }

    try {
        const user = await sendRequestInAUser(senderId, receiverId)
        res.json(user)
    } catch(error) {
        console.log(error)
    }
}

//handles the unsending of request in a user
export const unsendRequest = async (req,res) => {
    const { senderId, receiverId } = req.query
    let token = req.headers.authorization
    
    if(!token) {
        res.status(401).json({ error: "Unauthorized access" })
        return
    }

    token = token.split(' ')[1]
    try {
        jwt.verify(token, process.env.ACCESS_TOKEN_SECRET)
    } catch(error) {
        res.status(401).json({ error: "Unauthorized access" })
        return
    }

    try {
        const user = await unsendRequestInAUser(senderId, receiverId)
        res.json(user)
    } catch(error) {
        console.log(error)
    }
}

//handles the deletion of a friendship between two users
export const deleteFriend = async (req,res) => {
    const { currentUserId, friendUserId } = req.query
    let token = req.headers.authorization
    
    if(!token) {
        res.status(401).json({ error: "Unauthorized access" })
        return
    }

    token = token.split(' ')[1]
    try {
        jwt.verify(token, process.env.ACCESS_TOKEN_SECRET)
    } catch(error) {
        res.status(401).json({ error: "Unauthorized access" })
        return
    }

    try {
        const user = await deleteFriendship(currentUserId, friendUserId)
        res.json(user)
    } catch(error) {
        console.log(error)
    }
}

//handles the fetching of the sending/receiving requests and friends of the current user
export const fetchCurrentUserSRF = async (req,res) => {
    let token = req.headers.authorization
    let decoded
    
    if(!token) {
        res.status(401).json({ error: "Unauthorized access" })
        return
    }

    token = token.split(' ')[1]
    try {
        decoded = jwt.verify(token, process.env.ACCESS_TOKEN_SECRET)
    } catch(error) {
        res.status(401).json({ error: "Unauthorized access" })
        return
    }

    try {
        const user = await getSRF(decoded.username)
        res.json(user)
    } catch(error) {
        console.log(error)
    }
}

//handles the uploading of the post in the current user
export const uploadPost = async (req,res) => {
    const data = req.body
    const images = []
    let decoded

    for(let i=0; i<req.files.length; i++){
        images.push(req.files[i].buffer)
    }

    let token = req.headers.authorization
    
    if(!token) {
        res.status(401).json({ error: "Unauthorized access" })
        return
    }

    token = token.split(' ')[1]
    try {
        decoded = jwt.verify(token, process.env.ACCESS_TOKEN_SECRET)
    } catch(error) {
        res.status(401).json({ error: "Unauthorized access" })
        return
    }

    try {
        const result = await insertPostImages(data, images, decoded.username)
        res.json(result)
    } catch(error) {
        console.log(error)
    } 
}

//handles the finding of friend suggestions of the current user
export const findSuggestedFriends = async (req,res) => {
    let token = req.headers.authorization
    let decoded
    
    if(!token) {
        res.status(401).json({ error: "Unauthorized access" })
        return
    }

    token = token.split(' ')[1]
    try {
        decoded = jwt.verify(token, process.env.ACCESS_TOKEN_SECRET)
    } catch(error) {
        res.status(401).json({ error: "Unauthorized access" })
        return
    }

    try {
        const suggestedFriends = await findSuggestedFriendsOfCurrentUser(decoded.username)
        res.json(suggestedFriends)
    } catch (error) {
        console.log(error)
    }
}