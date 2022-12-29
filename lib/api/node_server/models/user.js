const mongoose = require('mongoose');
const userSchema = mongoose.Schema({
    userName : {
        type : String,
        required: true,
        trim: true,
    },
    password: {
        type: String,
        required: true,
    },
    firstName:{
        type:String,
        required:false
    },
    lastName:{
        type:String,
        required:false
    },
    darkMode:{
        type:String,
        required:false
    },
    registeredJamiyaID:{
        type:String,
        required:false
    },
    imgUrl:{
    type:String,
    required:false
    },
});
const User = mongoose.model('User',userSchema);
module.exports = User;