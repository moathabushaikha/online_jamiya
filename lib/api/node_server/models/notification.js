const mongoose = require('mongoose');
const notificationSchema = mongoose.Schema({
    jamiyaId : {
        type : String,
        required: true,
    },
    userToNoti: {
        type: String,
        required: true,
    },
    userFromNoti:{
        type:String,
        required:true
    },
    notificationDate:{
        type:String,
        required:true,
    },
    notificationType:{
        type:String,
        required:true
    }
});
const Notification = mongoose.model('notification',notificationSchema);
module.exports = Notification;