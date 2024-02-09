const express = require("express");
const Suggestion = require("../models/suggModel");
const router = express.Router();

router.post("/addSuggestion/:email", async (req, res) => {
  try {
    const { email } = req.params;
    const { feedbackText, feedbackValue, suggText } = req.body;

    console.log("Request Parameters:", req.params);
    console.log("Request Body:", req.body);

    if (!email || !feedbackText || feedbackValue === undefined || !suggText) {
      return res.status(400).json({ error: "Missing required parameters" });
    }

    const newSuggestion = new Suggestion({
      email,
      feedbackText,
      feedbackValue,
      suggText,
    });

    await newSuggestion.save();

    return res.status(200).json({ message: "Suggestion added successfully" });
  } catch (error) {
    console.error("Error:", error);
    return res.status(500).json({ error: "Internal Server Error" });
  }
});
router.get("/getSuggestions", async (req, res) => {
  try {
    const suggestions = await Suggestion.find();
    return res.status(200).json(suggestions);
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: "Internal Server Error" });
  }
});

router.delete("/deleteSuggestion/:id", async (req, res) => {
  try {
    const { id } = req.params;

    const deletedSuggestion = await Suggestion.findByIdAndDelete(id);

    if (!deletedSuggestion) {
      return res.status(404).json({ error: "Suggestion not found" });
    }

    return res.status(200).json({ message: "Suggestion deleted successfully" });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: "Internal Server Error" });
  }
});
module.exports = router;
