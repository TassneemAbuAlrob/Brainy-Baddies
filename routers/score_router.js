const express = require("express");
const jwt = require("jsonwebtoken"); // Import the JWT library
const Score = require("../models/score");
const router = express.Router();
const { jwt_secret } = require("../models/config");
const User = require("../models/userModel");

router.post("/addscore/:email", async (req, res) => {
  const { email } = req.params;
  const { score, gameName } = req.body;

  try {
    // Retrieve the user based on the provided email
    const user = await User.findOne({ email });

    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }

    const newScore = new Score({
      user: user._id,
      userEmail: email, // Store the user's email in the newScore object
      score: score,
      gameName: gameName,
    });

    const savedScore = await newScore.save();

    res.status(201).json(savedScore);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: error.message });
  }
});
router.get("/sumOfScoresByUser/:gameName/:userEmail", async (req, res) => {
  const { gameName, userEmail } = req.params;

  try {
    const result = await Score.aggregate([
      {
        $match: { gameName: gameName, userEmail: userEmail }, // Add userEmail to the match condition
      },
      {
        $group: {
          _id: "$user",
          totalScore: { $sum: "$score" },
        },
      },
      {
        $project: {
          user: "$_id",
          totalScore: 1,
          _id: 0,
        },
      },
    ]);

    res.status(200).json(result);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;

// router.post("/addscore", async (req, res) => {
//   const { token } = req.headers;

//   try {
//     if (!token) {
//       return res.status(401).json({ error: "Token is missing" });
//     }

//     const decoded = jwt.verify(token, jwt_secret);

//     const { score, gameName } = req.body;

//     const newScore = new Score({
//       user: decoded.id,
//       score: score,
//       gameName: gameName,
//     });

//     const savedScore = await newScore.save();

//     res.status(201).json(savedScore);
//   } catch (error) {
//     console.error("Error adding score:", error);
//     res.status(500).json({ error: "Internal Server Error" });
//   }
// });
