import jwt from "jsonwebtoken"
import { getChatsOfTheCurrentUser, getFriendsWithoutChat, 
    createNewChatForCurrentUser, deleteChatForCurrentUser,
    getMessagesForCurrentChat, createANewMessage,
    updateLastMessageSeen, getNumberOfUnseenChats
} from "../services/ChatService.js"

//handles the fetching of all chats in the inbox
export const getInbox = async (req,res) => {
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
        const chats = await getChatsOfTheCurrentUser(decoded.username)
        res.json(chats)
    } catch(error) {
        console.log(error)
    }
}

//handles the fetching of all friends that current user doesn't have yet a chat
export const getNewChatFriends = async (req,res) => {
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
        const friendsWithoutChat = await getFriendsWithoutChat(decoded.username)
        res.json(friendsWithoutChat)
    } catch(error) {
        console.log(error)
    }
}

//handles the creating of a new chat in the current user's inbox
export const createNewChat = async (req,res) => {
    const { chatMember } = req.body
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
        const chats = await createNewChatForCurrentUser(decoded.username, chatMember)
        res.json(chats)
    } catch(error) {
        console.log(error)
    }
}

//handles the deletion of a chat in the current user's inbox
export const deleteChat = async (req,res) => {
    const { chatId } = req.query
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
        const chats = await deleteChatForCurrentUser(decoded.username, chatId)
        res.json(chats)
    } catch(error) {
        console.log(error)
    }
}

//handles the fetching of messages of one chat
export const getMessages = async (req,res) => {
    const { chatId } = req.query
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
        const messages = await getMessagesForCurrentChat(chatId)
        res.json(messages)
    } catch(error) {
        console.log(error)
    }
}

//handles the creation of a message in a chat
export const createMessage = async (req,res) => {
    const { currentUserId, chatMemberId, chatMemberUsername, text } = req.body
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
        const newMessage = await createANewMessage(decoded.username, currentUserId, 
            chatMemberId, chatMemberUsername, text)
        res.json(newMessage)
    } catch(error) {
        console.log(error)
    }
}

//handles the update of the seen in the last message
export const makeTheLastMessageSeen = async (req,res) => {
    const { chatId } = req.query
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
        await updateLastMessageSeen(chatId)
        res.json({ success: true })
    } catch(error) {
        console.log(error)
    }
}

//handles the extracting the number of unseen chats for the current user
export const getNumOfUnseenChats = async (req,res) => {
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
        const numOfUnseenChats = await getNumberOfUnseenChats(decoded.username)
        res.json({ numOfUnseenChats: numOfUnseenChats })
    } catch(error) {
        console.log(error)
    }
}