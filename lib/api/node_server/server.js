const express = require('express');
const mongoose = require('mongoose');
const authRouter = require('./routes/auth');
const PORT = process.env.port || 3000
const app = express();
const DB = "mongodb+srv://moath:moath85@cluster0.ip45qud.mongodb.net/?retryWrites=true&w=majority";

app.use(express.json());
app.use(authRouter);
mongoose.set('strictQuery', false);

mongoose.connect(DB).then( ()=>{console.log("connection successfully");}).catch((e)=>{console.log(e)});

app.listen(PORT, "0.0.0.0", () => {
console.log(`connected at port ${PORT}`);
});
