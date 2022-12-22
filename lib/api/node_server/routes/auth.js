const express = require('express');
const authRouter = express.Router();
const User = require('../models/user');
const bcryptjs = require('bcryptjs');

authRouter.post('/api/signup', async (req,res) =>
    {
        try{
            const {userName, password} = req.body;
            const existingUser = await User.findOne({userName});
            if(existingUser) {
                return res.status(400).json({
                    msg: "user already exist",
                });
            }
            const hashedPassword = await bcryptjs.hash(password, 8);
            let user = new User({
                userName: userName,
                password:hashedPassword,
            });
            user = await user.save();
            res.json(user);
        }
        catch (e){
            res.status(500).json({error: e.message});
        }
    }
);

module.exports = authRouter;
