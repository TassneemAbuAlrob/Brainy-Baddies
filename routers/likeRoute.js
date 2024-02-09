const express = require("express");
const router = express.Router();
const Like = require("../models/likeModel");
const User = require("../models/userModel");
const Post = require("../models/postModel");

//show post likes
router.get("/getLikes/:postId", async (req, res) => {
  const postId = req.params.postId;

  try {
    const post = await Post.findById(postId);

    if (!post) {
      return res.status(404).json({ message: "Post not found" });
    }

    const likes = await Like.find({ post: postId }).populate(
      "user",
      "name email"
    );

    if (likes.length === 0) {
      return res.status(200).json({ message: "No likes for this post" });
    }

    const likesInfo = likes.map((like) => {
      return {
        username: like.user.name,
        email: like.user.email,
      };
    });

    res.status(200).json({ likes: likesInfo });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Error retrieving likes for the post" });
  }
});

//add like
router.post("/addLike/:postId", async (req, res) => {
  const postId = req.params.postId;

  try {
    const post = await Post.findById(postId);

    if (!post) {
      return res.status(404).json({ message: "Post not found" });
    }

    const userEmail = req.body.email;

    const user = await User.findOne({ email: userEmail });

    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    const existingLike = await Like.findOne({ user: user._id, post: postId });

    if (existingLike) {
      return res
        .status(400)
        .json({ message: "You've already liked this post" });
    }

    const newLike = new Like({
      user: user._id,
      post: postId,
    });

    await newLike.save();

    res.status(201).json({ message: "Like added successfully" });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Error adding like to the post" });
  }
});

// count like for each post
router.get("/getLikesCount/:postId", async (req, res) => {
  const postId = req.params.postId;

  try {
    const post = await Post.findById(postId);

    if (!post) {
      return res.status(404).json({ message: "Post not found" });
    }

    const likeCount = await Like.countDocuments({ post: postId });

    res.status(200).json({ likeCount });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Error retrieving post like count" });
  }
});
module.exports = router;
