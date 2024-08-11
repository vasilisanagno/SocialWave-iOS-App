import express from 'express'
import cors from 'cors'
import 'dotenv/config'
import https from 'https'
import fs from 'fs'
import { connectMongoDB } from './config/DatabaseConfig.js'
import { AuthRouter } from "./api/routes/Auth.js"
import { OTPRouter } from "./api/routes/OTP.js"
import { UserRouter } from './api/routes/User.js'
import { PostRouter } from './api/routes/Post.js'
import { CommentRouter } from './api/routes/Comment.js'
import { createSocket } from './api/socketListeners/socket.js'
import { NotificationRouter } from './api/routes/Notification.js'
import { ChatRouter } from './api/routes/Chat.js'

const app = express()
const PORT = process.env.PORT || 5000

app.use(cors())
app.use(express.urlencoded({extended:false}))
app.use(express.json())

await connectMongoDB()

app.use("/socialwave",AuthRouter)
app.use("/socialwave",OTPRouter)
app.use("/socialwave",UserRouter)
app.use("/socialwave",PostRouter)
app.use("/socialwave",CommentRouter)
app.use("/socialwave",NotificationRouter)
app.use("/socialwave",ChatRouter)

const server = https.createServer(
    {
        key: fs.readFileSync('key.pem'),
        cert: fs.readFileSync('cert.pem')
    }
    ,app
)

createSocket(server)

server.listen(PORT,() => {
    console.log(`HTTPS Server is open at ${PORT}`)
})