const mongoose = require('mongoose');
const jamiyaSchema = mongoose.Schema({
    name : {
        type : String,
        required: true,
        trim: true,
    },
    startingDate: {
        type: String,
        required: true,
    },
    endingDate:{
        type:String,
        required:false
    },
    maxParticipants:{
        type:Number,
        required:true,
    },
    participantsId:{
        type:String,
        required:false
    },
    creatorId:{
        type:String,
        required:true,
    },
    shareAmount:{
    type:Number,
    required:true,
    },
});
const Jamiya = mongoose.model('Jamiya',jamiyaSchema);
module.exports = Jamiya;