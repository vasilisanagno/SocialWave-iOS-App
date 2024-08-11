import express from 'express'
import { getPostComments, addComment, deleteComment, 
    addLikeToComment, deleteLikeFromComment } from '../controllers/CommentController.js'

const router = express.Router()

//router that retrieves the users that made a comment to a post
router.get('/get-post-comments', getPostComments)

//router that adds a new comment to a post
router.put('/add-comment', addComment)

//router that deletes a comment from a post
router.delete('/delete-comment', deleteComment)

//router that adds a like to a comment for a post
router.patch('/add-like-to-comment', addLikeToComment)

//router that deletes a like from a comment for a post
router.patch('/delete-like-from-comment', deleteLikeFromComment)

export { router as CommentRouter }