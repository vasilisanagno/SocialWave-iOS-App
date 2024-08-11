import jwt from "jsonwebtoken"
import { addUser, findUser, 
    checkLoginUser, updatePassword, 
    findUserByUsername, deleteUserByUsername } from "../services/AuthService.js"
import { deleteOTP, findOTP } from "../services/OTPService.js"

//handles the submission of the signup form and checks if the user does not exist already and sends a response to the client
export const signupUser = async (req,res) => {
    const data = req.body
    
    try {
        const response = await findOTP(null,data.email,1)
        if (response.length === 0 || data.otp !== response[0].otp) {
            return res.json({
                success: false,
                message: 'The OTP is not valid'
            })
        }
        else {
            await addUser(data)
        }
        res.json({ success: true })
    } catch(error) {
        console.log(error)
    }
}

//handles the submission of the login form and checks if the user exists and sends a response to the client
export const loginUser = async (req,res) => {
    const { email, password } = req.body
    
    try {
        const user = await checkLoginUser({email,password})
        if(user === null) {
            res.json({ success: false, token: "" })
        }
        else {
            const token = jwt.sign({ 
                username: user.username
            }, process.env.ACCESS_TOKEN_SECRET, {
                    expiresIn: '365 days'
                }
            )
            await deleteOTP(email)
            res.json({ success: true, token: token })
        }
    } catch(error) {
        console.log(error)
    }
}

//checks if the user exists with a specific email in reset password
export const checkIfUserExists = async (req,res) => {
    const { email } = req.body
    
    try {
        const user = await findUser(email)
        if(user !== null) {
            res.json({ success: true })
        }
        else {
            res.json({ success: false })
        }
    } catch(error) {
        console.log(error)
    }
}

//handles the resetting of the password and change it in the database
export const changePasswordOfUser = async (req,res) => {
    const data = req.body

    try {
        await updatePassword(data.email,data.password)
        res.json({ success: true })
    } catch(error) {
        console.log(error)
    }
}

//handles the verification for auto login with token
export const verifyUserForAutoLogin = async (req,res) => {
    const { token } = req.body

    try {
        const decoded = jwt.verify(token, process.env.ACCESS_TOKEN_SECRET)
        
        const user = await findUserByUsername(decoded.username)
        res.json(user)
    } catch(error) {
        console.log(error)
        res.status(401).json({error: "Unauthorized access"})
    }
}

//handles the deletion of the user
export const deleteUser = async (req,res) => {
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
        await deleteUserByUsername(decoded.username)
        res.json({success: true})
    } catch(error) {
        console.log(error)
    }
}