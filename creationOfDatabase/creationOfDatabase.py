from faker import Faker
from pymongo import MongoClient
import random
import requests
from datetime import datetime

#initialize Faker
fake = Faker()

#connect to MongoDB
client = MongoClient("mongodb+srv://vanagnostop:ekgAlDHHUoZzmsDA@cluster0.wuvnd31.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0")
db = client['SocialWaveDB']  #replace with your actual database name
users_collection = db['Users']
posts_collection = db['Posts']
comments_collection = db['Comments']

#helper function to generate a username from a fullname
def generateUsername(fullname):
    parts = fullname.split()
    if len(parts) > 1:
        username_base = parts[0][0].lower() + parts[-1].lower()
    else:
        username_base = parts[0].lower()
    return username_base + str(random.randint(10, 99))

#helper function to generate an email from a username
def generateEmail(username):
    return f"{username}@gmail.com"

def fetchRandomImage(num_images=1, profile=True):
    '''Fetches a specified number of random images and return them as a list of bytes objects.'''
    images = []
    for _ in range(num_images):
        image_url = "https://picsum.photos/200"  #image source URL
        response = requests.get(image_url)
        if response.status_code == 200:
            images.append(response.content)
    return images if num_images >= 1 and not profile else images[0]  #return the first image directly if only one is requested

def generateUser():
    fullname = fake.name()
    username = generateUsername(fullname)
    email = generateEmail(username)
    return {
        'fullname': fullname,
        'username': username,
        'email': email,
        'password': fake.password(),  #remember, in real scenarios, hash this password
        'description': fake.text(),
        'profileImage': fetchRandomImage(),  #fetch only one image for profile
        'receiving': [], #requests from probably friends taht received the user
        'sending': [], #pending requests that sends the user to others
        'friends': [],  #to be updated with actual user references after insertion
        'posts': []  #assuming you'll handle posts similarly; adjust as needed
    }

def generatePost(user_id):
    '''Generates a single post data structure for a given user with multiple images.'''
    num_images = random.randint(1, 5)  #decide how many images to fetch
    images = fetchRandomImage(num_images, profile=False)  # Fetch multiple images
    return {
        'text': fake.sentence(),
        'username': users_collection.find_one({'_id': user_id})['username'],
        'userId': user_id,
        'images': images,  #attach the list of images
        'likes': [],
        'createdAt': fake.date_time_this_year(),
        'updatedAt': fake.date_time_this_year()
    }


def likePost(user_id, post_id):
    #retrieve the post and the author's friends list
    post_document = posts_collection.find_one({'_id': post_id})
    userId = post_document['userId']
    author_document = users_collection.find_one({'_id': userId})
    author_friends = author_document['friends']
    
    #check if the liking user is a friend of the author
    if user_id in author_friends:
        #record the like
        if user_id not in post_document.get('likes', []):
            posts_collection.update_one(
                {'_id': post_id},
                {'$push': {'likes': user_id}}
            )
        else:
            print("User has already liked this post.")
    else:
        print("User is not a friend of the post's author and cannot like this post.")


def createPostsForUsers(user_ids):
    """Creates a specified number of posts for each user and updates the user document with post IDs."""
    for user_id in user_ids:
        post_ids = []
        for _ in range(random.randint(3, 7)):
            post_data = generatePost(user_id)
            result = posts_collection.insert_one(post_data)
            post_ids.append(result.inserted_id)
            #new block to add 1 to 5 likes from friends
            author_document = users_collection.find_one({'_id': user_id})
            author_friends = author_document['friends']
            num_likes = random.randint(1, min(10, len(author_friends)))  # Ensure not more friends than available
            liked_friends = random.sample(author_friends, num_likes)
            for friend_id in liked_friends:
                likePost(friend_id, result.inserted_id)
        
        #update the user's document with the new post IDs
        users_collection.update_one({'_id': user_id}, {'$push': {'posts': {'$each': post_ids}}})

def addLikeToComment(user_id, comment_id):
    comment = comments_collection.find_one({"_id": comment_id})
    if user_id not in comment['likes']:
        comments_collection.update_one({"_id": comment_id}, {"$addToSet": {"likes": user_id}})
    return

#function to add comments to posts
def addCommentsToPosts():
    posts = posts_collection.find()
    for post in posts:
        user_id = post['userId']
        user_document = users_collection.find_one({'_id': user_id})
        if user_document and 'friends' in user_document:
            num_comments = random.randint(1, min(3, len(user_document['friends'])))
            friends_to_comment = random.sample(user_document['friends'], num_comments)
            
            for friend_id in friends_to_comment:
                comment_content = random.choice(["Great post!", "Really loved this!", "Awesome!"])
                comment = {
                    'content': comment_content,
                    'user': friend_id,
                    'post': post['_id'],
                    'likes': [],
                    'createdAt': datetime.now()
                }
                comments_collection.insert_one(comment)
                if random.choice([True, False]):
                    addLikeToComment(friend_id, comments_collection.find_one({'post': post['_id'],'user': friend_id, 'content': comment_content})['_id'])


def createUsersWithFriends(num_users):
    users_ids = []
    
    #step 1: Generate and insert users without friends
    for _ in range(num_users):
        user_data = generateUser()
        result = users_collection.insert_one(user_data)
        users_ids.append(result.inserted_id)
    
    #step 2: Randomly assign friends, ensuring mutual friendship
    for user_id in users_ids:
        #select 2 to 5 random friends for this user
        friends_ids = random.sample([uid for uid in users_ids if uid != user_id], random.randint(2, 5))
        
        #update the current user's friends list
        for friend_id in friends_ids:
            users_collection.update_one({'_id': user_id}, {'$addToSet': {'friends': friend_id}})
        
        #ensure mutual friendships by adding this user to their friends' lists
        for friend_id in friends_ids:
            users_collection.update_one({'_id': friend_id}, {'$addToSet': {'friends': user_id}})
    
    #step 3: Assign sending and receiving requests
    for user_id in users_ids:
        current_user_doc = users_collection.find_one({'_id': user_id})
        current_friends = current_user_doc['friends']
        
        potential_requests = [uid for uid in users_ids if uid != user_id and uid not in current_friends]
        random.shuffle(potential_requests)

        half_point = len(potential_requests) // 2
        sending = potential_requests[:half_point]

        #update sending for the current user
        users_collection.update_one({'_id': user_id}, {'$set': {'sending': sending}})

        #update receiving for other users based on current user's sending
        for receiver in sending:
            users_collection.update_one({'_id': receiver}, {'$addToSet': {'receiving': user_id}})
    
    for user in users_ids:
        #find overlaps between 'friends' and 'receiving' and 'sending'
        current_user_doc = users_collection.find_one({'_id': user_id})
        friends = current_user_doc['friends']
        receiving = current_user_doc['receiving']
        sending = current_user_doc['sending']
    
        overlapsReceiving = [uid for uid in receiving if uid in friends]
        overlapsSending = [uid for uid in sending if uid in friends]

        #remove overlaps from 'receiving'
        if overlapsReceiving:
            users_collection.update_one(
                {'_id': user},
                {'$pullAll': {'receiving': overlapsReceiving}}
            )
        #remove overlaps from 'sending'
        if overlapsReceiving:
            users_collection.update_one(
                {'_id': user},
                {'$pullAll': {'sending': overlapsSending}}
            )
            
    #step 4: Generate posts for each user
    createPostsForUsers(users_ids)

#example usage
createUsersWithFriends(100)  #creates 50 users with interconnected friends
addCommentsToPosts()
