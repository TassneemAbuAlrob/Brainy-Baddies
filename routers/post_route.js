const express = require("express");
const url = require("url");
const PostModel = require("../models/post");

const router = express.Router();
const moment = require("moment");
const multer = require("multer");
const jwt = require("jsonwebtoken");
const { jwt_secret } = require("../models/config");

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

router.post("/posts", upload.any(), async (req, res) => {
  try {
    const { token } = req.headers;
    const decoded = jwt.verify(token, jwt_secret);
    console.log(decoded);
    console.log(token);

    console.log(req.body);

    let post = {
      text_content: req.body.textContent,
      date: moment().format("YYYY-MM-DD HH:mm:ss"),
      comments: [],
      likes: [],
      user: decoded.id,
      type: req.body.type,
    };

    for (let file of req.files) {
      console.log(file);
      if (file != null) {
        const link = process.env.APP_URL + file.path;
        if (file.fieldname == "image") {
          post.image_content = link;
        } else {
          post.video = link;
        }
      }
    }

    let newPost = await PostModel.create(post);

    console.log(newPost);
    return res.status(200).json(newPost);
  } catch (error) {
    return res.status(500).send(error.message);
  }
});

router.post("/posts/:id/like", async (req, res) => {
  try {
    const { id } = req.params;
    const { userId } = req.body;

    let post = await PostModel.findById(id);
    if (
      post.likes.some((like) => {
        return like.user == userId;
      })
    ) {
      return res.status(400).send("Already Liked");
    }

    post.likes.push({
      user: userId,
      date: moment().format("YYYY-MM-DD HH:mm:ss"),
    });

    await post.save();
    return res.sendStatus(200);
  } catch (error) {
    return res.status(500).send(error.message);
  }
});

router.post("/posts/:id/comment", async (req, res) => {
  try {
    const { id } = req.params;
    const { userId, comment } = req.body;

    // Validate userId and comment
    if (!userId || !comment) {
      return res
        .status(400)
        .json({ error: "Missing userId or comment", status: 400 });
    }

    let post = await PostModel.findById(id);
    if (
      post.comments.some((existingComment) => existingComment.user == userId)
    ) {
      return res.status(400).json({ error: "Already Commented", status: 400 });
    }

    post.comments.push({
      user: userId,
      date: moment().format("YYYY-MM-DD HH:mm:ss"),
      content: comment,
    });

    await post.save();
    return res.sendStatus(200);
  } catch (error) {
    console.error(error); // Log the error to the console
    return res
      .status(500)
      .json({ error: "Internal Server Error", status: 500 });
  }
});

router.get("/posts", async (req, res) => {
  try {
    if (req.query.limit != undefined && req.query.limit > 0) {
    }

    const posts = await PostModel.find().populate();

    return res.status(200).json(posts);
  } catch (err) {
    return res.status(500).send(err.message);
  }
});

router.get("/posts/:id", async (req, res) => {
  try {
    const { id } = req.params;
    const posts = await PostModel.find({
      _id: id,
    });

    return res.status(200).json(posts);
  } catch (err) {
    return res.status(500).send(err.message);
  }
});

router.get("/posts/user/:id", async (req, res) => {
  try {
    const { id } = req.params;

    const posts = await PostModel.find({
      user: id,
    }).populate([
      {
        path: "likes.user",
        ref: "User",
      },

      {
        path: "user",
        ref: "User",
      },
    ]);

    console.log(posts[0].likes);

    return res.status(200).json(posts);
  } catch (err) {
    return res.status(500).send(err.message);
  }
});

//delete post
router.delete("/deletePost/:postId", async (req, res) => {
  const postId = req.params.postId;

  try {
    const result = await PostModel.deleteOne({ _id: postId });

    if (result.deletedCount === 1) {
      res.status(200).json({ message: "Post deleted successfully" });
    } else {
      res.status(404).json({ message: "Post not found for deletion" });
    }
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Error deleting the post" });
  }
});

router.get("/posts/:id/comments", async (req, res) => {
  try {
    const { id } = req.params;

    // Find the post by its ID and populate the comments
    const post = await PostModel.findById(id).populate(
      "comments.user",
      "email"
    );

    if (!post) {
      return res.status(404).json({ message: "Post not found" });
    }

    // Return only the comments array
    const comments = post.comments;

    return res.status(200).json(comments);
  } catch (error) {
    return res.status(500).send(error.message);
  }
});

router.delete("/deleteComment/:postId/:commentId", async (req, res) => {
  const postId = req.params.postId;
  const commentId = req.params.commentId;

  try {
    const post = await PostModel.findById(postId);

    if (!post) {
      return res.status(404).json({ message: "Post not found" });
    }

    // Find the index of the comment in the comments array
    const commentIndex = post.comments.findIndex(
      (comment) => comment._id == commentId
    );

    if (commentIndex === -1) {
      return res
        .status(404)
        .json({ message: "Comment not found for deletion" });
    }

    // Remove the comment from the comments array
    post.comments.splice(commentIndex, 1);

    // Save the updated post
    await post.save();

    res.status(200).json({ message: "Comment deleted successfully" });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Error deleting the comment" });
  }
});
router.get("/allposts/:userId", async (req, res) => {
  try {
    const { userId } = req.params;

    // Find all posts excluding those from the specified user
    const posts = await PostModel.find({ user: { $ne: userId } }).populate([
      {
        path: "user",
        model: "User",
      },
      {
        path: "likes.user",
        model: "User",
      },
    ]);

    return res.status(200).json(posts);
  } catch (err) {
    return res.status(500).send(err.message);
  }
});

module.exports = router;
