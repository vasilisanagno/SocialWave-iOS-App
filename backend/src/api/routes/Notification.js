import express from 'express'
import { deleteNotifications, getNotifications, getNumOfUnseenNotifications } from '../controllers/NotificationController.js'

const router = express.Router()

//router that handles the fetching of the notifications for the current user
router.get("/get-notifications", getNotifications)

//router that handles the fetching of the number of unseen notifications for the current user
router.get("/num-unseen-notifications", getNumOfUnseenNotifications)

//router that handles the deletion of notifications for the current user
router.delete("/delete-notifications", deleteNotifications)

export { router as NotificationRouter }