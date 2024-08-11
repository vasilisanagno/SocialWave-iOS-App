import { Server as SocketIo } from 'socket.io'
import { getNumberOfUnseenNotif } from '../services/NotificationService.js'

export const createSocket = (server) => {
    //configurations for sockets
    const io = new SocketIo(server, {
        cors: {
            origin: "*",
            methods: ["GET","POST"],
            transports: ['websocket', 'polling'],
            credentials: true
        },
        allowEIO3: true
    })

    let sockets = []
    let chatRooms = []

    io.on('connection', (socket) => {
        
        //connect the user with his socket_id in the sockets array
        socket.on("connectUser", async (username) => {
            let userAlreadyExists = sockets.some((user) => {
                return user.username === username
            })

            let numOfUnseenNotifications = await getNumberOfUnseenNotif(username)
            if(!userAlreadyExists) {
                sockets.push({ socket_id: socket.id, username: username, numOfUnseenNotifications: numOfUnseenNotifications})
            }
            else {
                sockets.find((user) => {
                    if(user.username === username) {
                        user.socket_id = socket.id
                        user.numOfUnseenNotifications = numOfUnseenNotifications
                    }
                })
            }
        })

        //socket to listen for sending the notification to the other user
        socket.on("sendNotification", (usernameSender, usernameReceiver) => {
            let numOfUnseenNotifications
            if(usernameSender != usernameReceiver) {
                let receiverExists = sockets.find((user) => {
                    user.numOfUnseenNotifications++
                    numOfUnseenNotifications = user.numOfUnseenNotifications
                    return user.username === usernameReceiver
                })
                
                if(receiverExists) {
                    io.to(receiverExists.socket_id).emit("showNotification", numOfUnseenNotifications)
                }
            }
        })

        //socket to listen when the user click on notification tab the number of unseen notifications to be deleted
        socket.on("clearUnseenNotifications", (username) => {
            sockets.map((user) => {
                if(user.username === username) {
                    user.numOfUnseenNotifications = 0
                }
            })
        })
        
        //socket to listen when the user wants to create a new chat room
        socket.on("createChat", (usernameFirst,usernameSecond) => {
            function chatExists(username1, username2) {
                return chatRooms.some(chat =>
                    (chat.usernameFirst === username1 && chat.usernameSecond === username2) ||
                    (chat.usernameFirst === username2 && chat.usernameSecond === username1)
                )
            }
            if (!chatExists(usernameFirst, usernameSecond)) {
                chatRooms.push({ usernameFirst: usernameFirst, usernameSecond: usernameSecond})
            }
        })

        //socket to listen when the user send a message to show real time the new mesages to other user
        socket.on("showNewMessageToOther", (senderUsername) => {
            let currentUser = sockets.find(s => s.socket_id === socket.id)?.username
            if (currentUser) {
                let chat = chatRooms.find(chat => 
                    (chat.usernameFirst === currentUser || chat.usernameSecond === currentUser)
                )

                if (chat) {
                    let otherUsername = (chat.usernameFirst === currentUser) ? chat.usernameSecond : chat.usernameFirst

                    let otherUserSocket = sockets.find(s => s.username === otherUsername)?.socket_id

                    if (otherUserSocket) {
                        io.to(otherUserSocket).emit("showMessages", senderUsername)
                    }
                }
            }
        })

        //socket to listen when the user send a message and the other user does not see it yet
        //to show the number of unseen chats
        socket.on("showUpdatedChatsInTheReceiver", (username) => {
            let receiverExists = sockets.find((user) => {
                return user.username === username
            })
            if(receiverExists) {
                io.to(receiverExists.socket_id).emit("showUpdatedChats")
            }
        })
    })
}