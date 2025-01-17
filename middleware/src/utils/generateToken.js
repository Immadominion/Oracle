// filepath: /Users/immadominion/codes/oracle/middleware/generateToken.js
const jwt = require('jsonwebtoken');
const dotenv = require('dotenv');

dotenv.config();

const payload = {
  id: 'user123', // Replace with actual user ID
};

const token = jwt.sign(payload, process.env.SECRET_KEY, {
  expiresIn: '1h',
});

console.log('JWT Token:', token);