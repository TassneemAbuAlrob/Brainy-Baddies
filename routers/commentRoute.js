const express = require("express");
const Post = require("../models/postModel");
const Comment = require("../models/commentModel");
const User = require("../models/userModel");
const router = express.Router();

router.post("/addComment/:postId", async (req, res) => {
  console.log("Processing comment request...");

  try {
    const { Textcomment, email, imagecomment } = req.body;
    const postId = req.params.postId.trim();

    if (!email || !postId) {
      return res.status(400).json({ error: "Invalid email or postId" });
    }

    const user = await User.findOne({ email });

    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }

    let commentData = {
      post: postId,
      user: user._id,
    };

    if (imagecomment) {
      commentData = {
        ...commentData,
        Textcomment,
        imagecomment: imagecomment,
      };

      await saveCommentAndRespond(res, commentData);
    } else if (Textcomment) {
      // Handle text comment
      commentData = {
        ...commentData,
        Textcomment,
      };

      await saveCommentAndRespond(res, commentData);
    } else {
      return res.status(400).json({ error: "Invalid comment data" });
    }
  } catch (error) {
    console.error(error);
    res
      .status(500)
      .json({ error: "An error occurred while creating the comment" });
  }
});

function saveCommentAndRespond(res, commentData) {
  const comment = new Comment(commentData);

  comment
    .save()
    .then(() => {
      res.status(201).json({ message: "Comment created successfully" });
    })
    .catch((error) => {
      console.error(error);
      res.status(500).json({ error: "Error saving the comment" });
    });
}

//show comments
router.get("/getComments/:postId", async (req, res) => {
  let postId = req.params.postId;

  // Remove leading/trailing whitespaces
  postId = postId.trim();

  // Validate if postId is a valid ObjectId format
  const isValidObjectId = /^[0-9a-fA-F]{24}$/.test(postId);

  if (!isValidObjectId) {
    return res.status(400).json({ message: "Invalid post ID format" });
  }

  try {
    const post = await Post.findById(postId);

    if (!post) {
      return res.status(404).json({ message: "Post not found" });
    }

    const comments = await Comment.find({ post: postId }).populate(
      "user",
      "name email"
    );

    if (comments.length === 0) {
      return res.status(200).json({ message: "No comments for this post" });
    }

    const commentInfo = comments.map((comment) => {
      const commentData = {
        username: comment.user.name,
        email: comment.user.email,
      };

      // Check if it's a text comment
      if (comment.Textcomment) {
        commentData.commentType = "text";
        commentData.comment = comment.Textcomment;
      }
      // Check if it's an image comment
      else if (comment.imagecomment) {
        commentData.commentType = "image";
        commentData.comment = comment.imagecomment; // You might want to send the image path or URL here
      }

      return commentData;
    });

    res.status(200).json({ comments: commentInfo });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Error retrieving comments for the post" });
  }
});
router.get("/getcommentsCount/:postId", async (req, res) => {
  const postId = req.params.postId;

  try {
    const post = await Post.findById(postId);

    if (!post) {
      return res.status(404).json({ message: "Post not found" });
    }

    const commentCount = await Comment.countDocuments({ post: postId });

    res.status(200).json({ commentCount });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Error retrieving post Comment count" });
  }
});

module.exports = router;
