require('dotenv').config()

module.exports = {
    jwt_secret: process.env.JWT_SECRET_KEY,
    mongo_connection_url: process.env.MONGODB_URL
}