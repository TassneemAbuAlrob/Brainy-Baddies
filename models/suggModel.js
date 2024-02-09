const mongoose = require("mongoose");

const suggestionSchema = new mongoose.Schema({
  email: {
    type: String,
    required: true,
  },
  feedbackText: {
    type: String,
    required: true,
  },
  feedbackValue: {
    type: Number,
    required: true,
  },
  suggText: String,
});

const Suggestion = mongoose.model("Suggestion", suggestionSchema);

module.exports = Suggestion;
