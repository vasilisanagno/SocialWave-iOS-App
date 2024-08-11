import { User } from '../models/UserModel.js'
import bcrypt from 'bcrypt'

//finds a user according to email
export async function findUser(email) {
    let user = await User.findOne({ 
        email: email
    })
    
    return user
}

//checks if a users exists with the same username or email
export async function checkIfEmailOrUsernameExists(username, email) {
    let user = await User.findOne({ 
        email: email
    })

    if(user!==null) {
        return null
    }
    else {
        user = await User.findOne({ 
            username: username
        })
        if(user!==null) {
            return null
        }
    }
    return true
}

//adds a user in collection User, the password in the database inserts with hashing/encrypted. 
export async function addUser(data) {
    //const newPassword = await bcrypt.hash(data.password, 10)
    const user = await User.create({
        fullname: null,
        username: data.username,
        email: data.email,
        password: data.password,
        receiving: [],
        sending: [],
        friends: [],
        description: null,
        profileImage: null
    })
    return user
}

//checks if a user exists in the collection User with this email 
//and the password is correct for this email in the database
export async function checkLoginUser(data) {
    let user = await User.findOne({ 
        email: data.email
    })
    if(user===null) {
        return null
    }
    
    //const match = await bcrypt.compare(data.password,user.password)
    const match = await User.findOne({
        password: data.password
    })
    if(match) {
        return user
    }
    else {
        return null
    }
}

//changes the password of the user with the given email
export async function updatePassword(email,password) {
    //const newPassword = await bcrypt.hash(password, 10)
    await User.findOneAndUpdate({email: email}, {password: password})
}

//finds the user by username that is saved inside the token
export async function findUserByUsername(username) {
    let user = await User.findOne({username: username}, 
        '_id fullname username description profileImage receiving sending friends posts'
    ).lean()
    user.id = user._id.toString()
    delete user._id
    return user
}

//deletes the user by username
export async function deleteUserByUsername(username) {
    await User.deleteOne({username: username})
}