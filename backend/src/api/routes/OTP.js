import express from 'express'
import { checkOTP, sendOTP } from '../controllers/OTPController.js'
const router = express.Router()

//router that handles the sending of otp for verification of the email
router.post('/send-otp', sendOTP)

//router that checks if the typed otp from user is the same with this from the database
router.post('/check-otp', checkOTP)

export { router as OTPRouter }