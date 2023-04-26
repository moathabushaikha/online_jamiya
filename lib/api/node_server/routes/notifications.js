const express = require('express');
const notificationRouter = express.Router();
const Notification = require('../models/notification');

notificationRouter.post("/api/addNotification", async (req, res) =>
{
    try{
        const {jamiyaId, userFromNoti, userToNoti, notificationDate, notificationType} = req.body;
        let notification = new Notification({
            jamiyaId: jamiyaId,
            userFromNoti: userFromNoti,
            userToNoti: userToNoti,
            notificationDate: notificationDate,
            notificationType: notificationType,
        });
        notification = await notification.save();
        res.json(notification);
    }
    catch (e){
        res.status(500).json({error: e.message});
        }
});
notificationRouter.post("/api/deleteNotifications", async (req, res) =>
{
    try{
        const {_id} = req.body;
//        console.log(req.body);
        let notification = await Notification.findByIdAndDelete({_id});
        res.json(notification);
    }
    catch (e){
        res.status(500).json({error: e.message});
        }
});

notificationRouter.get("/api/notifications", async (req, res) =>
 {
    try{
        if (Object.keys(req.query).length === 0){
            const notifications = await Notification.find({});
            res.json(notifications);
        }
        else{
            const _id = req.query._id;
            const notification = await Notification.find({_id});
            res.json(notification);
        }
    }catch (e){
        res.status(500).json({error: e.message});
    }
 }
);

module.exports = notificationRouter;

