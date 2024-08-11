import mongoose from "mongoose"
import nodemailer from 'nodemailer'

//function that sends the email
const mailSender = async (email, title, body) => {

    const transporter = nodemailer.createTransport({
        service: 'gmail',
        auth: {
          user: 'noreply.socialwave2024@gmail.com',
          pass: process.env.EMAIL_PASSWORD
        }
    })    
    try {
        // Send emails to users
        let info = await transporter.sendMail({
            from: 'noreply.socialwave2024@gmail.com',
            to: email,
            subject: title,
            html: body
        })
        console.log("Email info: ", info)
        return info
    } catch (error) {
        console.log(error.message)
    }
}

const OTPSchema = new mongoose.Schema({
    email: {
        type: String,
        required: true,
    },
    otp: {
        type: String,
        required: true,
    },
    createdAt: {
        type: Date,
        default: Date.now,
        expires: 60 * 10, // The document will be automatically deleted after 10 minutes of its creation time
    }
})
// Define a function to send emails
async function sendVerificationEmail(email, otp) {
    try {
        const mailResponse = await mailSender(
            email,
            "Verification Email",
            `<h2>Please confirm your OTP</h2>
            <p>Here is your OTP code: ${otp}</p>`
        )
        console.log("Email sent successfully: ", mailResponse)
    } catch (error) {
        console.log("Error occurred while sending email: ", error)
        throw error
    }
}
OTPSchema.pre("save", async function (next) {
    console.log("New document saved to the database");
    // Only send an email when a new document is created
    if (this.isNew) {
        await sendVerificationEmail(this.email, this.otp)
    }
    next()
})
const OTP = mongoose.model('OTP', OTPSchema, 'OTP')
export  { OTP }