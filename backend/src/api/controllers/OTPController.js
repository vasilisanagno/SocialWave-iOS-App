import { generate } from 'otp-generator'
import { checkIfEmailOrUsernameExists } from '../services/AuthService.js'
import { findOTP, createOTP, deleteOTP } from '../services/OTPService.js'

//handles the sending of the otp in the signup process
export const sendOTP = async (req,res) => {
    const data = req.body
    try {
        if(data.process === "signup") {
            // Check if user is already present
            const checkUserPresent = await checkIfEmailOrUsernameExists(data.username,data.email)
            
            // If user found with provided username
            if (checkUserPresent === null) {
                return res.json({
                    success: false,
                    message: 'Invalid username or email!'
                })
            }
        }
        if(data.process === "requestAgain") {
            await deleteOTP(data.email)
        }
        let otp = generate(6, {
            upperCaseAlphabets: false,
            lowerCaseAlphabets: false,
            specialChars: false
        })
        
        let result = await findOTP(otp,null,0)
        while (result) {
            otp = generate(6, {
                upperCaseAlphabets: false,
                lowerCaseAlphabets: false,
                specialChars: false
            })
            result = await findOTP(otp,null,0)
        }
        const otpPayload = { email: data.email , otp: otp }
        await createOTP(otpPayload)
        res.json({
            success: true,
            message: 'OTP sent successfully'
        })
    } catch (error) {
        console.log(error)
    }
}

//checks the otp if it is correct 
export const checkOTP = async (req,res) => {
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
            return res.json({
                success: true
            })
        }
    } catch(error) {
        console.log(error)
    }
}