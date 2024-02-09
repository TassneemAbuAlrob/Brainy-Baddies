const express = require("express");
const router = express.Router();

const multer = require("multer");
const moment = require("moment");
const Video = require("../models/video");
// Set up multer
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    // Set the destination folder where files will be saved
    cb(null, "public/videos/"); // Create a folder named 'uploads' in your project root
  },
  filename: function (req, file, cb) {
    // Set the file name with original name + timestamp to make it unique
    cb(null, moment() + "_" + file.originalname);
  },
});

const upload = multer({ storage: storage });

router.post("/videos", upload.any(), async (req, res) => {
  try {
    let { title, description, publisher, age, category } = req.body;

    console.log(req.files);

    if (title == undefined || description == undefined) {
      return res.status(400).json({
        success: false,
        message: "please provide a title and description",
      });
    }

    let publish_date = moment().format("YYYY-MM-DD HH:mm:ss");
    const link =
      process.env.APP_URL +
      req.files.filter((file) => {
        return file.fieldname == "video";
      })[0].path;

    let posterFile = req.files.filter((file) => {
      return file.fieldname == "image";
    })[0];

    let posterLink = process.env.APP_URL + posterFile.path;

    const video = await Video.create({
      title: title,
      description: description,
      link: link,
      publish_date: publish_date,
      publisher: publisher ?? "admin",
      poster: posterLink,
      age: age == "null" ? null : age,
      category: category == "null" ? null : category,
    });

    const io = req.app.get("io");

    io.emit("notification", {
      notification: {
        title: `A new video was added`,
        body: `${title} \n ${description}`,
      },
    });

    return res.status(200).json({
      success: true,
      video: video,
    });
  } catch (e) {
    return res.status(500).json(e.message);
  }
});

router.get("/videos", async (req, res) => {
  let videos = await Video.find().populate([
    {
      path: "age",
      ref: "Age",
    },
    {
      path: "category",
      ref: "Category",
    },
  ]);
  return res.status(200).json(videos);
});
router.get("/videos/admin", async (req, res) => {
  let videos = await Video.find({
    publisher: "admin",
  }).populate([
    {
      path: "age",
      ref: "Age",
    },
    {
      path: "category",
      ref: "Category",
    },
  ]);
  return res.status(200).json(videos);
});

router.get("/videos/user/:id", async (req, res) => {
  const userId = req.params.id;
  let videos = await Video.find({
    publisher: userId,
  }).populate([
    {
      path: "age",
      ref: "Age",
    },
    {
      path: "category",
      ref: "Category",
    },
  ]);
  return res.status(200).json(videos);
});

router.get("/videos/count", async function (req, res) {
  try {
    let count = await Video.countDocuments();
    return res.status(200).json(count);
  } catch (err) {
    return res.status(500).json(err.message);
  }
});

router.get("/videos/:id", async (req, res) => {
  try {
    const { id } = req.params;
    let video = await Video.findOne({ _id: id });
    if (!video) return res.status(404).json({ message: "video not found" });

    return res.status(200).json(video);
  } catch (e) {
    return res.status(500).json({
      success: false,
      message: e.message,
    });
  }
});

router.delete("/videos/:id/", async (req, res) => {
  await Video.deleteOne({ _id: req.params.id });
  return res.status(200).json({
    success: true,
    message: "Video deleted successfully",
  });
});

router.put("/videos/:id", async (req, res) => {
  try {
    const { title, description } = req.body;

    if (!title || !description) {
      return res.status(400).json({
        success: false,
        message: "Invalid title or description provided",
      });
    }

    let updateStatus = await Video.updateOne(
      {
        _id: req.params.id,
      },
      { title, description }
    );

    if (updateStatus) {
      return res.status(200).json({ success: updateStatus });
    }
  } catch (err) {
    return res.status(500).json({ error: err.message });
  }
});

router.get("/videos/count", async (req, res) => {
  let count = await Video.count();
  return res.status(200).json(count);
});

//like videos
router.post("/video/:id/like", async (req, res) => {
  try {
    const { id } = req.params;
    const { userId } = req.body;

    const video = await Video.findById(id);

    if (
      video.likes.some((like) => like.user.toString() === userId.toString())
    ) {
      return res.status(400).json({ error: "Already Liked" });
    }

    video.likes.push({
      user: userId,
      date: moment().format("YYYY-MM-DD HH:mm:ss"),
    });

    await video.save();
    return res.status(200).json({ message: "Video Liked Successfully" });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
});

/// like count
router.get("/videos/:id/likes/count", async (req, res) => {
  try {
    const { id } = req.params;
    const video = await Video.findById(id);

    if (!video) {
      return res.status(404).json({ message: "Video not found" });
    }

    const likesCount = video.likes.length;

    return res.status(200).json({ likesCount });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
});
//rate

router.post("/videos/:id/rate", async (req, res) => {
  try {
    const { id } = req.params;
    const { rating } = req.body;

    if (!rating || isNaN(rating) || rating < 1 || rating > 5) {
      return res.status(400).json({ error: "Invalid rating value" });
    }

    const video = await Video.findById(id);

    if (!video) {
      return res.status(404).json({ message: "Video not found" });
    }

    // Update the video's rating field
    video.rating = rating;

    // Save the updated video document
    await video.save();

    return res.status(200).json({ message: "Video rated successfully" });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
});
//getrate

router.get("/videos/:id/rating", async (req, res) => {
  try {
    const { id } = req.params;

    const video = await Video.findById(id);

    if (!video) {
      return res.status(404).json({ message: "Video not found" });
    }

    const rating = video.rating;

    return res.status(200).json({ rating });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
});
//comment to video

router.post("/videos/:id/comment", async (req, res) => {
  try {
    const { id } = req.params;
    const { userId, text } = req.body;

    if (!text || !userId) {
      return res
        .status(400)
        .json({ error: "Please provide a comment text and user ID" });
    }

    const video = await Video.findById(id);

    if (!video) {
      return res.status(404).json({ message: "Video not found" });
    }

    const comment = {
      text,
      user: userId, // Add the user ID to the comment
      date: moment().format("YYYY-MM-DD HH:mm:ss"),
    };

    video.comments.push(comment);

    await video.save();

    return res
      .status(200)
      .json({ message: "Comment added successfully", comment });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
});

module.exports = router;
