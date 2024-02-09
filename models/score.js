const mongoose = require("mongoose");

const scoreSchema = new mongoose.Schema({
  user: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "User",
    required: true,
  },
  userEmail: {
    type: String,
    required: true,
  },

  score: {
    type: Number,
    required: true,
  },
  gameName: String,
});

const Score = mongoose.model("Score", scoreSchema);

module.exports = Score;
