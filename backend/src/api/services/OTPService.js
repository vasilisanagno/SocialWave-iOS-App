import { OTP } from '../models/OTPModel.js'

//finds if otp exists
export async function findOTP(otp, email, option) {
    let otpResponse

    if(option === 0) {
        otpResponse = await OTP.findOne({ otp: otp })
    }
    else {
        // Find the most recent OTP for the email
        otpResponse = await OTP.find({ email: email }).sort({ createdAt: -1 }).limit(1)
    }
    return otpResponse
}

//creates otp for the user
export async function createOTP(otpPayload) {
    const otp = await OTP.create(otpPayload)
    return otp
}

//delete otps that are created for a specific user
export async function deleteOTP(email) {
    await OTP.deleteOne({email: email})
}