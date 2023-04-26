const express = require('express');
const userRouter = express.Router();
const User = require('../models/user');
userRouter.get("/api/users", async (req, res) =>
 {
    try{
        const _id = req.query._id;
        let user = await User.findById({_id});
        res.json(user);
    }catch (e){
        res.status(500).json({error: e.message});
    }
 }
);
userRouter.put("/api/users", async (req, res) =>
{
    try{
        const {userName, password,firstName,lastName,darkMode,registeredJamiyaID,imgUrl} = req.body;
        const existingUser = await User.findOne({userName});
        if(existingUser) {
            let user = new User({
                userName,
                password,
                firstName,
                lastName,
                darkMode,
                registeredJamiyaID,
                imgUrl,
            });
            const updatedUser = await User.findByIdAndUpdate(
                req.query._id,
                {userName, password,firstName,lastName,darkMode,registeredJamiyaID,imgUrl},
                {new: true}
            );
            user = await updatedUser.save();
            res.json(user);
        }
        else
        {
            return res.status(400).json(
                {
                    msg: "User does not exist",
                });
        }

    }
    catch (e){
        res.status(500).json({error: e.message});
    }
});

module.exports = userRouter;
