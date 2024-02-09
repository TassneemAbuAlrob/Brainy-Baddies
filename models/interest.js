const mongoose = require("mongoose");

const interestSchema = new mongoose.Schema({
  percentValue: String,
  email: {
    type: String,
    required: true,
  },
  catgName: String,
});

const Interest = mongoose.model("Interest", interestSchema);

module.exports = Interest;
