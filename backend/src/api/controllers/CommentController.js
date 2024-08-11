import jwt from "jsonwebtoken"
import { getComments, addCommentToPost, 
    deleteCommentFromPost, addLikeToCommentForPost, 
    deleteLikeFromCommentForPost 
} from "../services/CommentService.js"

//handles the retrieving of the post likes
export const getPostComments = async (req,res) => {
    const { postId } = req.query
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
        const userComments = await getComments(postId)
        res.json(userComments)
    } catch(error) {
        console.log(error)
    }
}

//handles the adding of a new comment to a post
export const addComment = async (req,res) => {
    const { postId, userId, content } = req.body
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
        const userComments = await addCommentToPost(postId, userId, content)
        res.json(userComments)
    } catch(error) {
        console.log(error)
    }
}

//handles the deleting of a comment to a post
export const deleteComment = async (req,res) => {
    const { postId, userId, content } = req.query
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
        const userComments = await deleteCommentFromPost(postId, userId, content)
        res.json(userComments)
    } catch(error) {
        console.log(error)
    }
}

//handles the adding of a like to a comment to a post
export const addLikeToComment = async (req,res) => {
    const { postId, userId, content, currentUser } = req.query
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
        const userCommentsLikes = await addLikeToCommentForPost(postId, userId, content, currentUser)
        res.json(userCommentsLikes)
    } catch(error) {
        console.log(error)
    }
}

//handles the adding of a like to a comment to a post
export const deleteLikeFromComment = async (req,res) => {
    const { postId, userId, content, currentUser } = req.query
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
        const userCommentsLikes = await deleteLikeFromCommentForPost(postId, userId, content, currentUser)
        res.json(userCommentsLikes)
    } catch(error) {
        console.log(error)
    }
}