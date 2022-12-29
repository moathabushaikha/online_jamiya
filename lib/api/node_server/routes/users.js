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

module.exports = userRouter;
