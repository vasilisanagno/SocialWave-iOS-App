import jwt from "jsonwebtoken"
import { getNotifForTheCurrentUser, getNumberOfUnseenNotif, deleteNotifsOfTheCurrentUser } from "../services/NotificationService.js"

//handles the getting the notifications that are sent to the current user
export const getNotifications = async (req,res) => {
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
        const notifications = await getNotifForTheCurrentUser(decoded.username)
        res.json(notifications)
    } catch(error) {
        console.log(error)
    }
}

//handles the extracting the number of unseen notifications for the current user
export const getNumOfUnseenNotifications = async (req,res) => {
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
        const numOfUnseenNotif = await getNumberOfUnseenNotif(decoded.username)
        res.json({ unseenNotifications: numOfUnseenNotif })
    } catch(error) {
        console.log(error)
    }
}

//handles the deletion of notifications for the current user
export const deleteNotifications = async (req,res) => {
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
        await deleteNotifsOfTheCurrentUser(decoded.username)
        res.json({ success: true })
    } catch(error) {
        console.log(error)
    }
}