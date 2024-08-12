import mongoose from "mongoose"

const connectMongoDB = async() => {
    try {
        await mongoose.connect(`mongodb+srv://${process.env.USERNAME}:${process.env.PASSWORD}@${process.env.DATABASE_HOST}/SocialWaveDB?retryWrites=true&w=majority&appName=Cluster0`)
        .then(console.log("MongoDB Connected"))
    } catch(error) {
        console.log(error.message)
    }
}

export { connectMongoDB }