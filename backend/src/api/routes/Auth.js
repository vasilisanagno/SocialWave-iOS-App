import express from 'express'
import { 
    signupUser, loginUser, 
    changePasswordOfUser, checkIfUserExists,
    verifyUserForAutoLogin, deleteUser
} from '../controllers/AuthController.js'

const router = express.Router()

//route for the login of the user
router.post("/login", loginUser)

//route for signup of the user
router.post("/signup", signupUser)

//route for checking if the email exists in reset password
router.post("/check-email", checkIfUserExists)

//route for resetting the password
router.post("/change-password", changePasswordOfUser)

//route for verifying the token of the user for auto-login
router.post("/verify-user", verifyUserForAutoLogin)

//route for delete of the user
router.delete("/delete-user", deleteUser)

export { router as AuthRouter }