const mongoose = require("mongoose");
const Schema = mongoose.Schema;

const newSchema = new Schema({
  parentUser: {
    type: String,
    required: false,
  },
  email: {
    type: String,
    required: true,
  },
  password: {
    type: String,
    required: true,
  },

  following: [
    {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
    },
  ],
  followers: [
    {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
    },
  ],

  unique_id: {
    type: String,
    required: true,
  },

  // interests: [{
  //     cul
  // }],

  phone: {
    type: String,
    required: true,
  },

  name: {
    type: String,
    required: true,
  },

  role: {
    type: String,
    enum: ["child", "parent"],
    required: true,
  },

  image: {
    type: String,
    required: true,
  },

  joined_at: {
    type: String,
    required: true,
  },
});

let UserModel = mongoose.model("User", newSchema);

module.exports = UserModel;
