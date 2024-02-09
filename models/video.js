const mongoose = require("mongoose");
const CommentModel = require("./comment");

const VideoSchema = new mongoose.Schema({
  link: {
    type: String,
    required: true,
  },

  poster: {
    type: String,
    required: true,
  },

  rating: {
    type: mongoose.Schema.Types.Number,
    default: 1.0,
  },

  title: {
    type: String,
    required: true,
  },

  description: {
    type: String,
  },

  publish_date: {
    type: String,
    required: true,
  },

  publisher: {
    type: String,
    required: true,
  },

  views: {
    type: Number,
    default: 0,
  },

  category: {
    type: String,
    default: null,
  },

  age: {
    type: String,
    default: null,
  },

  interactions: {
    type: [String],
    default: [],
  },

  comments: {
    type: [String],
    default: [],
  },
  likes: [
    {
      date: {
        type: String,
        required: true,
      },
      user: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "User",
        required: true,
      },
    },
  ],
});

const VideoModel = mongoose.model("Video", VideoSchema);

module.exports = VideoModel;
