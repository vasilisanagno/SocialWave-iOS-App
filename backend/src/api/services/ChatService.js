import { Chat } from '../models/ChatModel.js'
import { User } from '../models/UserModel.js'
import { Message } from '../models/MessageModel.js'
import moment from 'moment'

//retrieves all the chats of the current user
export async function getChatsOfTheCurrentUser(username) {
    const chats = await Chat.find({ username: username })
                            .populate('chatMember', '_id username fullname profileImage')
                            .sort({ lastMessageCreatedAt: -1 })
                            .lean()

    const now = moment()
    const yesterday = moment().subtract(1, 'days').startOf('day')
    const finalChats = chats.map(chat => ({
        id: chat._id,
        username: chat.username,
        chatMemberId: chat.chatMember._id,
        chatMemberUsername: chat.chatMember.username,
        chatMemberFullname: chat.chatMember.fullname,
        chatMemberProfileImage: chat.chatMember.profileImage,
        lastMessageSeen: chat.lastMessageSeen,
        lastMessage: chat.lastMessage,
        lastMessageCreatedAt: 
        (moment(chat.lastMessageCreatedAt).isSame(now, 'day')) ?
        moment(chat.lastMessageCreatedAt).from(now).charAt(0).toUpperCase() + moment(chat.lastMessageCreatedAt).from(now).slice(1) // Returns "a few seconds ago", "20 minutes ago", etc.
        : (moment(chat.lastMessageCreatedAt).isSame(yesterday, 'day')) ?
            "Yesterday"
        :
            moment(chat.lastMessageCreatedAt).from(now).charAt(0).toUpperCase() + moment(chat.lastMessageCreatedAt).from(now).slice(1) // Returns "2 days ago", "3 weeks ago", etc.
    }))
    return finalChats
}

//finds friends who aren't in any chat with the current user
export async function getFriendsWithoutChat(username) {
    const userWithFriends = await User.find({username: username}).select('friends').lean()

    const chats = await Chat.find({ username: username }).select('chatMember').lean()

    const chatMemberIds = new Set(chats.map(chat => chat.chatMember.toString()))

    const friendsWithoutChats = await User.find({
        _id: { $in: userWithFriends[0].friends, $nin: Array.from(chatMemberIds) }
    }).lean()

    for(let i=0; i<friendsWithoutChats.length; i++) {
        friendsWithoutChats[i].id = friendsWithoutChats[i]._id.toString()
        delete friendsWithoutChats[i]._id
    }

    return friendsWithoutChats
}

//creates chat with the user that is selected from the current user
export async function createNewChatForCurrentUser(username, chatMember) {
    await Chat.create({
        username: username,
        chatMember: chatMember,
        lastMessageSeen: true,
        lastMessage: null,
        lastMessageCreatedAt: null,
        messages: []
    })
    const chats = await Chat.find({username: username})
                        .populate('chatMember', '_id username fullname profileImage')
                        .sort({ createdAt: -1 })
                        .lean()

    const now = moment()
    const yesterday = moment().subtract(1, 'days').startOf('day')
    const finalChats = chats.map(chat => ({
        id: chat._id,
        username: chat.username,
        chatMemberId: chat.chatMember._id,
        chatMemberUsername: chat.chatMember.username,
        chatMemberFullname: chat.chatMember.fullname,
        chatMemberProfileImage: chat.chatMember.profileImage,
        lastMessageSeen: chat.lastMessageSeen,
        lastMessage: chat.lastMessage,
        lastMessageCreatedAt: 
        (moment(chat.lastMessageCreatedAt).isSame(now, 'day')) ?
        moment(chat.lastMessageCreatedAt).from(now).charAt(0).toUpperCase() + moment(chat.lastMessageCreatedAt).from(now).slice(1) // Returns "a few seconds ago", "20 minutes ago", etc.
        : (moment(chat.lastMessageCreatedAt).isSame(yesterday, 'day')) ?
            "Yesterday"
        :
            moment(chat.lastMessageCreatedAt).from(now).charAt(0).toUpperCase() + moment(chat.lastMessageCreatedAt).from(now).slice(1) // Returns "2 days ago", "3 weeks ago", etc.
    }))
    return finalChats
}

//deletes a chat for the current user
export async function deleteChatForCurrentUser(username,chatId) {
    await Chat.findByIdAndDelete(chatId)

    const chats = await Chat.find({username: username})
                        .populate('chatMember', '_id username fullname profileImage')
                        .sort({ createdAt: -1 })
                        .lean()

    const now = moment()
    const yesterday = moment().subtract(1, 'days').startOf('day')
    const finalChats = chats.map(chat => ({
        id: chat._id,
        username: chat.username,
        chatMemberId: chat.chatMember._id,
        chatMemberUsername: chat.chatMember.username,
        chatMemberFullname: chat.chatMember.fullname,
        chatMemberProfileImage: chat.chatMember.profileImage,
        lastMessageSeen: chat.lastMessageSeen,
        lastMessage: chat.lastMessage,
        lastMessageCreatedAt:
        (moment(chat.lastMessageCreatedAt).isSame(now, 'day')) ?
            moment(chat.lastMessageCreatedAt).from(now).charAt(0).toUpperCase() + moment(chat.lastMessageCreatedAt).from(now).slice(1) // Returns "a few seconds ago", "20 minutes ago", etc.
        : (moment(chat.lastMessageCreatedAt).isSame(yesterday, 'day')) ?
            "Yesterday"
        :
            moment(chat.lastMessageCreatedAt).from(now).charAt(0).toUpperCase() + moment(chat.lastMessageCreatedAt).from(now).slice(1) // Returns "2 days ago", "3 weeks ago", etc.
    }))
    return finalChats
}

//gets all the messages for current chat
export async function getMessagesForCurrentChat(chatId) {
    const chat = await Chat.findById(chatId)
        .populate({
            path: 'messages',
            select: '_id sender text createdAt'
        }).lean()
    
    const todayStart = moment().startOf('day')
    const weekStart = moment().startOf('week')
    for(let i=0; i < chat.messages.length; i++) {
        chat.messages[i].id = chat.messages[i]._id.toString()
        delete chat.messages[i]._id
        if (moment(chat.messages[i].createdAt).isSame(todayStart, 'd')) {
            //if the message was created today, return the time
            chat.messages[i].createdAt =  moment(chat.messages[i].createdAt).format('HH:mm')
        } else if (moment(chat.messages[i].createdAt).isSameOrAfter(weekStart, 'day')) {
            //if the message was created on a previous day, return the day and time
            chat.messages[i].createdAt =  moment(chat.messages[i].createdAt).format('ddd HH:mm')
        } else {
            //if the message was created on a previous week, return the day, date, and time
            chat.messages[i].createdAt = moment(chat.messages[i].createdAt).format('ddd DD-MM-YYYY')
        }
    }
    return chat.messages
}

//creates a new message for the current chat
export async function createANewMessage(username, currentUserId, 
    chatMemberId, chatMemberUsername, text) {
    const newMessage = await Message.create({
        sender: currentUserId,
        text: text
    })
    
    await Chat.findOneAndUpdate(
        { username: username, chatMember: chatMemberId },
        {
            $set: { lastMessageSeen: true, lastMessage: text, lastMessageCreatedAt: newMessage.createdAt },
            $push: { messages: newMessage._id }
        },
        { new: true, upsert: true } //upsert option to create the chat if it doesn't exist
    )

    await Chat.findOneAndUpdate(
        { username: chatMemberUsername, chatMember: currentUserId },
        {
            $set: { lastMessageSeen: false, lastMessage: text, lastMessageCreatedAt: newMessage.createdAt },
            $push: { messages: newMessage._id }
        },
        { new: true, upsert: true } //upsert option to create the chat if it doesn't exist
    )
    
    const message = newMessage.toObject()
    message.id = message._id.toString()
    delete message._id

    const todayStart = moment().startOf('day')
    const weekStart = moment().startOf('week')
    if (moment(message.createdAt).isSame(todayStart, 'day')) {
        //if the message was created today, return the time
        message.createdAt = moment(message.createdAt).format('HH:mm')
    } else if (moment(message.createdAt).isSameOrAfter(weekStart, 'day')) {
        //if the message was created this week, return the day and time
        message.createdAt = moment(message.createdAt).format('ddd HH:mm')
    } else {
        //if the message was created on a previous week, return the day, date, and time
        message.createdAt = moment(message.createdAt).format('ddd DD-MM-YYYY')
    }
    return message
}

//updates the last message seen to true when the user see the messages
export async function updateLastMessageSeen(chatId) {
    await Chat.findByIdAndUpdate(chatId, { lastMessageSeen: true })
}

//fetches the unseen chats and returns the number of these
export async function getNumberOfUnseenChats(username) {
    const unseenChats = await Chat.find({username: username, lastMessageSeen: false})
    return unseenChats.length
}