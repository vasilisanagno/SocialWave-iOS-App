import express from 'express'
import { getInbox, getNewChatFriends, 
    createNewChat, deleteChat, getMessages, createMessage, 
    makeTheLastMessageSeen,
    getNumOfUnseenChats
} from '../controllers/ChatController.js'

const router = express.Router()

//router that retrieves the inbox
router.get('/get-inbox', getInbox)

//router that gets the friends that the current user doesn't have yet a chat
router.get('/get-new-chat-friends', getNewChatFriends)

//router that creates a new chat for the current user
router.put('/create-new-chat', createNewChat)

//router that deletes the chat of the current user with some other user
router.delete('/delete-chat', deleteChat)

//router that fetches the messages for one chat room
router.get('/get-messages', getMessages)

//router that creates a new message in a specific chat room
router.put('/create-message', createMessage)

//router that updates the last message seen when the user see the messages
router.patch('/update-last-message-seen', makeTheLastMessageSeen)

//router that fetches the number of unseen chats
router.get('/get-of-unseen-chats', getNumOfUnseenChats)

export { router as ChatRouter }