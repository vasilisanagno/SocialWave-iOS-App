import jwt from "jsonwebtoken"
import { retrieveUserAndPosts, getLikes, updateCaption, 
    deletePostById, getFriendsPosts, 
    addLikeToPost, deleteLikeFromPost } from "../services/PostService.js"

//handles the retrieving of the posts and the details of them
export const getUserAndPosts = async (req,res) => {
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
        const result = await retrieveUserAndPosts(username)
        res.json(result)
    } catch(error) {
        console.log(error)
    }
}

//handles the retrieving of the post likes
export const getPostLikes = async (req,res) => {
    const { post } = req.query
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
        const user_likes = await getLikes(post)
        res.json(user_likes)
    } catch(error) {
        console.log(error)
    }
}

//handles the updating of the caption of a post
export const updatePostCaption = async (req, res) => {
    const { postId, newCaption } = req.query
    let token = req.headers.authorization

    if (!token) {
        res.status(401).json({ error: "Unauthorized access" })
        return
    }

    token = token.split(' ')[1]
    try {
        jwt.verify(token, process.env.ACCESS_TOKEN_SECRET)
    } catch (error) {
        res.status(401).json({ error: "Unauthorized access" })
        return
    }

    try {
        const updatedPost = await updateCaption(postId, newCaption)
        res.json(updatedPost)
    } catch (error) {
        console.error(error)
    }
}

//handles the deletion of a post
export const deletePost = async (req,res) => {
    const { postId } = req.query
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
        await deletePostById(decoded.username, postId)
        res.json({success: true})
    } catch(error) {
        console.log(error)
    }
}

//handles the posts of currentUser posts
export const fetchFriendsPosts = async (req,res) => {
    let token = req.headers.authorization
    if (!token) {
        return res.status(401).json({ error: "Unauthorized access" })
    }

    token = token.split(' ')[1] // Assuming Bearer token format
    let decoded
    try {
        decoded = jwt.verify(token, process.env.ACCESS_TOKEN_SECRET)
    } catch (error) {
        return res.status(401).json({ error: "Unauthorized access" })
    }

    try {
        const friendsPosts = await getFriendsPosts(decoded.username)
        res.json(friendsPosts)
    } catch (error) {
        console.error("Error fetching friends' posts1:", error)
        res.status(500).json({ error: "Internal server error" })
    }
}

//handles the like to add in post
export const addLike = async (req, res) => {
    const { userId, postId } = req.query
    let token = req.headers.authorization

    if (!token) {
        res.status(401).json({ error: "Unauthorized access" })
        return
    }
    
    token = token.split(' ')[1]
    try {
        jwt.verify(token, process.env.ACCESS_TOKEN_SECRET)
    } catch (error) {
        res.status(401).json({ error: "Unauthorized access" })
        return
    }

    try {
        const result = await addLikeToPost(userId, postId)
        res.json({likes: result})
    } catch (error) {
        console.error(error)
    }
}

//handles the like to add in post
export const deleteLike = async (req, res) => {
    const { userId, postId } = req.query
    let token = req.headers.authorization

    if (!token) {
        res.status(401).json({ error: "Unauthorized access" })
        return
    }
    
    token = token.split(' ')[1]
    try {
        jwt.verify(token, process.env.ACCESS_TOKEN_SECRET)
    } catch (error) {
        res.status(401).json({ error: "Unauthorized access" })
        return
    }

    try {
        const result = await deleteLikeFromPost(userId, postId)
        res.json({likes: result})
    } catch (error) {
        console.error(error)
    }
}
