const express = require("express");
const Interest = require("../models/interest");
const router = express.Router();

router.post("/addInterest/:email", async (req, res) => {
  try {
    const { percentValue, catgName } = req.body;
    const email = req.params.email;

    if (!email || !percentValue) {
      return res
        .status(400)
        .json({ error: "Email and percentValue are required fields." });
    }

    const savedInterest = new Interest({
      email,
      percentValue,
      catgName,
    });

    await savedInterest.save();
  } catch (error) {
    console.error("Error handling request:", error);
    res.status(500).json({ error: "Internal server error" });
  }
});
router.get("/getInterests/:email", async (req, res) => {
  try {
    const email = req.params.email;

    if (!email) {
      return res.status(400).json({ error: "Email is a required field." });
    }

    const interests = await Interest.find({ email });

    const categorizedInterests = {
      religious: 0.0,
      scientific: 0.0,
      cultural: 0.0,
    };

    interests.forEach((interest) => {
      const catgName = interest.catgName.toLowerCase();
      categorizedInterests[catgName] = interest.percentValue;
    });

    res.status(200).json({ interests: categorizedInterests });
  } catch (error) {
    console.error("Error handling request:", error);
    res.status(500).json({ error: "Internal server error" });
  }
});

module.exports = router;
