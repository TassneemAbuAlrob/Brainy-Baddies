const mongoose = require("mongoose");

const commentSchema = new mongoose.Schema({
  user: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "User",
    required: true,
  },
  post: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "Post",
    required: true,
  },
  Textcomment: String,

  imagecomment: String,
  // for alaa
  // commenter: {
  //   type: mongoose.Schema.Types.ObjectId,
  //   ref: "User",
  // },
  // date: {
  //   type: String,
  //   required: true,
  // },

  // content: {
  //   type: String,
  //   required: true,
  // },
});

module.exports = mongoose.model("Comment", commentSchema);
