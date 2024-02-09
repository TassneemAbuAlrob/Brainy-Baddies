const express = require("express");
const User = require("../models/userModel");
const router = express.Router();
const moment = require("moment");
const jwt = require("jsonwebtoken");
const { jwt_secret } = require("../models/config");

const multer = require("multer");

// Set up multer
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    // Set the destination folder where files will be saved
    cb(null, "public/images/users/"); // Create a folder named 'uploads' in your project root
  },
  filename: function (req, file, cb) {
    // Set the file name with original name + timestamp to make it unique
    cb(null, moment() + "_" + file.originalname);
  },
});

const upload = multer({ storage: storage });

router.get("/users/count", async (req, res) => {
  let count = await User.countDocuments();
  return res.status(200).json(count);
});

router.post("/login", async (req, res) => {
  try {
    const { email, password } = req.body;

    console.log(req.body);

    let user = await User.findOne({ email: email });
    if (!user) {
      return res.status(404).send("User not found");
    }

    let userPassword = user.password;
    if (userPassword != password) {
      return res.status(400).send("Password mismatch");
    }

    let token = jwt.sign(
      {
        id: user.id,
        email: email,
        role: user.role,
      },
      jwt_secret
    );

    return res.status(200).json({
      token,
      user,
    });
  } catch (err) {
    return res.status(500).send(err.message);
  }
});

router.post("/register", upload.single("image"), async (req, res) => {
  try {
    const { email, password, name, role, phone, unique_id } = req.body;

    let user = await User.findOne({ email: email });
    if (user) {
      return res.status(404).send("User Already Registered");
    }

    let image = req.file;
    let link = process.env.APP_URL + image.path;

    await User.create({
      email: email,
      password: password,
      role: role,
      name: name,
      phone: phone,
      image: link,
      unique_id: unique_id,
      joined_at: moment().format("YYYY-MM-DD HH:mm:ss"),
    });

    return res.status(200).send("User successfully created");
  } catch (err) {
    return res.status(500).send(err.message);
  }
});

router.get("/users", async (req, res) => {
  try {
    let users = await User.find();
    return res.status(200).json(users);
  } catch (err) {
    return res.status(500).send(err.message);
  }
});

router.get("/users/:id", async (req, res) => {
  try {
    const id = req.params.id;
    let user = await User.findOne({
      _id: id,
    }).populate([]);
    return res.status(200).json(user);
  } catch (err) {
    return res.status(500).send(err.message);
  }
});

router.delete("/users/:id", async (req, res) => {
  try {
    let { id } = req.params;
    let isDeleted = await User.deleteOne({
      _id: id,
    });

    if (isDeleted) {
      return res.status(200).send("user was deleted");
    }

    return res.status(400).send("not deleted");
  } catch (err) {
    return res.status(500).send(err.message);
  }
});

router.put("/users/:id/followings", async (req, res) => {
  try {
    const data = req.body;
    const { id } = req.params;

    console.log(data);
    console.log(id);

    let user = await User.findOne({ _id: id });
    let otherUser = await User.findOne({ _id: data.otherId });
    if (user.following.some((following) => following == data.otherId)) {
      return res.status(400).send("Already Following");
    }

    user.following.push(data.otherId);
    otherUser.followers.push(id);

    await user.save();
    return res.status(200).send("added ");
  } catch (error) {
    return res.status(500).send(error.message);
  }
});

// router.put('/users/:id/followers', async (req, res) => {
//   try{
//     const data = req.body;
//     const { id } = req.params;

//     let user = await User.findOne({ _id: id });
//     let otherUser = await User.findOne({ _id: data.otherId });

//     if(user.followers.some(follower => follower == data.otherId)) {
//       return res.status(400).send('Already follow him')
//     }

//     user.followers.push(data.otherId)
//     otherUser.following.push(id)
//     await user.save()

//     return res.status(200).send('added follower')
//   }catch(error){
//     return res.status(500).send(error.message)
//   }
// })

router.put("/users/:id", upload.single("image"), async (req, res) => {
  console.log("he was geers");
  try {
    const data = req.body;
    const { id } = req.params;

    let user = await User.findOne({ _id: id });
    user.name = data.name;
    user.email = data.email;
    user.phone = data.phone;

    if (req.file != null) {
      const link = process.env.APP_URL + req.file.path;

      user.image = link;
    }

    await user.save();

    return res.status(200).json(user);
  } catch (err) {
    return res.status(500).send(err.message);
  }
});

//addchild

router.post("/addchild", upload.single("image"), async (req, res) => {
  try {
    const { email, password, name, role, phone, unique_id, parentUser } =
      req.body;

    let user = await User.findOne({ email: email });
    if (user) {
      return res.status(404).send("User Already added");
    }

    let image = req.file;
    let link = process.env.APP_URL + image.path;

    await User.create({
      email: email,
      password: password,
      role: role,
      name: name,
      phone: phone,
      image: link,
      unique_id: unique_id,
      joined_at: moment().format("YYYY-MM-DD HH:mm:ss"),
      parentUser: parentUser,
    });

    return res.status(200).send("User successfully created");
  } catch (err) {
    return res.status(500).send(err.message);
  }
});

//number of children
const countChildUsers = async (parentUser) => {
  try {
    const count = await User.countDocuments({ parentUser: parentUser });
    return count;
  } catch (error) {
    console.error(error);
    throw new Error("Error counting child users");
  }
};
router.get("/countChildUsers", async (req, res) => {
  try {
    const parentUser = req.query.parentUser;
    const userCount = await countChildUsers(parentUser);

    res.status(200).json({ count: userCount });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Internal server error" });
  }
});

//fetch children

router.get("/fetchChildren", async (req, res) => {
  const parentUser = req.query.parentUser;

  try {
    const childrenforParent = await User.findOne({ email: parentUser });

    if (!childrenforParent) {
      return res.status(404).json({ error: "Parent user not found" });
    }

    const children = await User.find({
      parentUser: parentUser,
      role: "child",
    });

    const childrenList = children.map((child) => ({
      name: child.name,
      email: child.email,
      image: child.image,
    }));

    res.status(200).json(childrenList);
  } catch (error) {
    console.error(error);
    res
      .status(500)
      .json({ error: "An error occurred while fetching children users" });
  }
});

///
//list of users
router.get("/ListOfUsers/:email", async (req, res) => {
  const { email } = req.params;
  try {
    const users = await User.find(
      { email: { $ne: email } },
      "name email phone role image"
    );

    const usersWithCompleteData = users.map((user) => ({
      name: user.name,
      email: user.email,
      phone: user.phone,
      role: user.role,
      image: user.image,
    }));

    res.json(usersWithCompleteData);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "An error occurred while fetching users" });
  }
});

///

//follow
router.post("/usersfollow/:email", async (req, res) => {
  const userEmail = req.params.email;
  const { followUserEmail, follow } = req.body;

  try {
    const user = await User.findOne({ email: userEmail });
    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }

    const followUser = await User.findOne({ email: followUserEmail });
    if (!followUser) {
      return res
        .status(404)
        .json({ error: "User to follow/unfollow not found" });
    }

    if (follow) {
      if (!user.following.includes(followUser._id)) {
        user.following.push(followUser._id);
      }
      if (!followUser.followers.includes(user._id)) {
        followUser.followers.push(user._id);
      }
    } else {
      user.following = user.following.filter(
        (id) => id.toString() !== followUser._id.toString()
      );
      followUser.followers = followUser.followers.filter(
        (id) => id.toString() !== user._id.toString()
      );
    }

    await user.save();
    await followUser.save();

    res.status(200).json({ message: "Operation successful" });
  } catch (error) {
    res.status(500).json({ error: "Could not follow/unfollow user" });
  }
});

//unfollow
router.delete("/usersunfollow/:email", async (req, res) => {
  const userEmail = req.params.email;
  const { followUserEmail } = req.body;

  try {
    const user = await User.findOne({ email: userEmail });
    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }

    const followUser = await User.findOne({ email: followUserEmail });
    if (!followUser) {
      return res.status(404).json({ error: "User to unfollow not found" });
    }

    // Remove followUser's ID from user's following
    user.following = user.following.filter(
      (id) => id.toString() !== followUser._id.toString()
    );

    // Remove user's ID from followUser's followers
    followUser.followers = followUser.followers.filter(
      (id) => id.toString() !== user._id.toString()
    );

    // Save changes to both user and followUser
    await user.save();
    await followUser.save();

    res.status(200).json({ message: "Unfollow successful" });
  } catch (error) {
    res.status(500).json({ error: "Could not unfollow user" });
  }
});

//list of followers

router.get("/followers/:email", async (req, res) => {
  const userEmail = req.params.email;

  try {
    const user = await User.findOne({ email: userEmail });

    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }

    const followers = await User.find({ _id: { $in: user.followers } });

    const followerList = followers.map((follower) => ({
      _id: follower._id,
      name: follower.name,
      email: follower.email,
      phone: follower.phone,
      image: follower.image,
    }));

    res.status(200).json(followerList);
  } catch (error) {
    console.error(error);
    res
      .status(500)
      .json({ error: "An error occurred while fetching followers" });
  }
});

// View Following Endpoint
router.get("/following/:email", async (req, res) => {
  const userEmail = req.params.email;

  try {
    // Find the user based on the provided email
    const user = await User.findOne({ email: userEmail });

    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }

    const following = await User.find({ _id: { $in: user.following } });

    const followingList = following.map((followedUser) => ({
      _id: followedUser._id,

      name: followedUser.name,
      email: followedUser.email,
      phone: followedUser.phone,

      image: followedUser.image,
    }));

    res.status(200).json(followingList);
  } catch (error) {
    console.error(error);
    res
      .status(500)
      .json({ error: "An error occurred while fetching following users" });
  }
});

///get id
router.get("/userID/:email", async (req, res) => {
  try {
    const { email } = req.params;
    const user = await User.findOne({ email: email }, "_id");

    return user
      ? res.json({ userId: user._id })
      : res.status(404).json({ error: "User not found" });
  } catch (error) {
    console.error("Error getting user ID by email:", error);
    res.status(500).json({ error: "Internal server error" });
  }
});

//FOR CHART:

router.get("/monthlyJoinData", async (req, res) => {
  try {
    const result = await User.aggregate([
      {
        $project: {
          month: {
            $dateToString: {
              format: "%Y-%m",
              date: {
                $dateFromString: {
                  dateString: "$joined_at",
                  format: "%Y-%m-%d %H:%M:%S",
                },
              },
            },
          },
        },
      },
      {
        $group: {
          _id: "$month",
          count: { $sum: 1 },
        },
      },
      {
        $sort: {
          _id: 1,
        },
      },
      {
        $project: {
          _id: 0,
          month: "$_id",
          count: 1,
        },
      },
    ]);

    const labels = result.map((entry) => entry.month);
    const data = result.map((entry) => entry.count);

    res.json({ labels, data });
  } catch (error) {
    console.error("Error fetching monthly join data:", error);
    res.status(500).json({ error: "Internal Server Error" });
  }
});

//get children

router.get("/children/:id", async (req, res) => {
  const parentUserId = req.params.id;

  try {
    const parentUser = await User.findOne({ _id: parentUserId });

    if (!parentUser || parentUser.role !== "parent") {
      return res.status(404).json({ error: "Parent user not found" });
    }

    const children = await User.find({
      parentUser: parentUser.email, // Update to use parentUser's email
      role: "child",
    });

    const childrenList = children.map((child) => ({
      name: child.name,
      email: child.email,
      image: child.image,
      // Add other fields as needed
    }));

    res.status(200).json(childrenList);
  } catch (error) {
    console.error(error);
    res
      .status(500)
      .json({ error: "An error occurred while fetching children users" });
  }
});

module.exports = router;
