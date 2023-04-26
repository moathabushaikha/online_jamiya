const express = require('express');
const jamiyaRouter = express.Router();
const Jamiya = require('../models/jamiya');

jamiyaRouter.post("/api/addJamiya", async (req, res) =>
{
    try{
        const {name, startingDate,endingDate,maxParticipants,participantsId,creatorId,shareAmount} = req.body;
        const existingJamiya = await Jamiya.findOne({name});
        if(existingJamiya) {
            return res.status(400).json({
                msg: "jamiya already exist",
            });
        }
        let jamiya = new Jamiya({
            name: name,
            startingDate: startingDate,
            endingDate: endingDate,
            maxParticipants: maxParticipants,
            participantsId: participantsId,
            creatorId: creatorId,
            shareAmount: shareAmount,
        });
        jamiya = await jamiya.save();
        res.json(jamiya);
    }
    catch (e){
        res.status(500).json({error: e.message});
        }
});
jamiyaRouter.put("/api/jamiyas", async (req, res) =>
{
    try{
        const {name, startingDate,endingDate,maxParticipants,participantsId,creatorId,shareAmount} = req.body;
        const existingJamiya = await Jamiya.findOne({name});
        if(existingJamiya) {
            let jamiya = new Jamiya({
                name: name,
                startingDate: startingDate,
                endingDate: endingDate,
                maxParticipants: maxParticipants,
                participantsId: participantsId,
                creatorId: creatorId,
                shareAmount: shareAmount,
            });
            const updatedJamiya = await Jamiya.findByIdAndUpdate(
                req.query._id,
                {name, startingDate,endingDate,maxParticipants,participantsId,creatorId,shareAmount},
                {new: true}
            );
            jamiya = await updatedJamiya.save();
            res.json(jamiya);
        }
        else
        {
            return res.status(400).json(
                {
                    msg: "jamiya already exist",
                });
        }

    }
    catch (e){
        res.status(500).json({error: e.message});
    }
});
jamiyaRouter.get("/api/jamiyas", async (req, res) =>
 {
// console.log(Object.keys(req.query).length);
    try{
        if (Object.keys(req.query).length === 0){
            const jamiyas = await Jamiya.find({});
             res.json(jamiyas);
        }
        else{
            const _id = req.query._id;
            const jamiya = await Jamiya.find({_id});
            res.json(jamiya);
        }
    }catch (e){
        res.status(500).json({error: e.message});
    }
 }
);

module.exports = jamiyaRouter;

