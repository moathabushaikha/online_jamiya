const express = require('express');
const authRouter = express.Router();
const User = require('../models/user');
const bcryptjs = require('bcryptjs');
const jwt = require('jsonwebtoken');

authRouter.post('/api/signup', async (req,res) =>
    {
        try{
            const {userName, password,firstName,lastName,darkMode,registeredJamiyaID,imgUrl} = req.body;
            const existingUser = await User.findOne({userName});
            if(existingUser) {
                return res.status(400).json({
                    msg: "user already exist",
                });
            }
            const hashedPassword = await bcryptjs.hash(password, 8);
            let user = new User({
                userName: userName,
                password: hashedPassword,
                firstName: firstName,
                lastName: lastName,
                darkMode: darkMode,
                registeredJamiyaID: registeredJamiyaID,
                imgUrl: imgUrl,
            });
            user = await user.save();
            res.json(user);
        }
        catch (e){
            res.status(500).json({error: e.message});
        }
    }
);
authRouter.post('/api/signin', async (req,res) => {
    try{
        const {userName, password} = req.body;
        const user = await User.findOne({userName});
        if (!user){
            return res.status(400).json({msg: "User with this username doesn't exist"});
        }
        const isMatch = await bcryptjs.compare(password, user.password);
        if (!isMatch){
            return res.status(400).json({msg: "incorrect password"});
        }
        const token = jwt.sign({id: user._id}, "passwordKey");
        res.json({token, ...user._doc});
    }
    catch (e){
        res.status(500).json({error: e.message});
    }
});
module.exports = authRouter;
