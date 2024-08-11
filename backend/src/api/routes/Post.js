import express from 'express'
import { getUserAndPosts, getPostLikes, updatePostCaption, deletePost, 
    fetchFriendsPosts, addLike, deleteLike } from '../controllers/PostController.js'

const router = express.Router()

//router thst handles the posts of the users to show in ui
router.get('/get-user-posts', getUserAndPosts)

//router that handles the users that liked a post
router.get('/get-post-likes', getPostLikes)

//router that updates the caption of an existing post
router.patch('/update-post-caption', updatePostCaption)

//router that deletes a user's post
router.delete('/delete-post', deletePost)

//router that handles the posts of the currentUser's friends
router.get('/fetch-friends-posts', fetchFriendsPosts)

//router that adds a like from the current user to a specific post
router.patch('/add-like', addLike)

//router that deletes a like from the current user to a specific post
router.patch('/delete-like', deleteLike)

export { router as PostRouter }