import express from 'express'
import { searchUsers, editProfile, 
    findFriends, uploadPost,
    findRequests, acceptRequest, rejectRequest,
    sendRequest, unsendRequest, fetchCurrentUserSRF,
    findSuggestedFriends, deleteFriend
} from '../controllers/UserController.js'
import multer from "multer"

//multer setup for handling memory storage
const storage = multer.memoryStorage()
const upload = multer({ storage: storage })

const router = express.Router()

//router that handles the searching of users according the text that provided the user
router.get('/search-users', searchUsers)

//router that handles the editing of user details like image, description and fullname
router.post('/edit-user-profile', upload.single('profileImage'), editProfile)

//router that handles the finding of friends of the users
router.get('/find-friends', findFriends)

//router that handles the finding of receiving requests of the current user
router.get('/find-requests', findRequests)

//router that handles the accept of receiving request of the current user
router.patch('/accept-request', acceptRequest)

//router that handles the reject of receiving request of the current user
router.patch('/reject-request', rejectRequest)

//router that handles the willingness of the current user to be friends with someone
router.patch('/send-request', sendRequest)

//router that handles the reject of willingness of the current user to be friends with someone
router.patch('/unsend-request', unsendRequest)

//router that handles the deletion of friendship between two users
router.patch('/delete-friend', deleteFriend)

//router that handles the fetching of current user sendings, receivings and friends
router.get('/fetch-current-user-srf-details', fetchCurrentUserSRF)

//router that handles the uploading of the post
router.post('/upload-post', upload.array('postImages',5), uploadPost)

//router that handles the fetching of the suggested friends
router.get('/find-suggested-friends', findSuggestedFriends)

export { router as UserRouter }