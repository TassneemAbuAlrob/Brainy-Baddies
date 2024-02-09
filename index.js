// const dotenv = require("dotenv");
// dotenv.config();

// const express = require("express");
// const app = express();
// const port = 4000 || process.env.PORT;
// const cors = require("cors");
// const bodyParser = require("body-parser");

// const http = require("http");

// const server = http.createServer(app);

// const socket = require("socket.io");

// const io = socket(server);

// app.set("io", io);

// io.on("connection", (socket) => {
//   console.log(
//     `a new connection and count is: ${socket.client.conn.server.clientsCount}`
//   );

//   socket.on("disconnect", () => {
//     console.log(
//       `User disconnected and count is: ${socket.client.conn.server.clientsCount}`
//     );
//   });
// });

// const mongoose = require("mongoose");
// const uri =
//   "mongodb://admin:admin123@70.34.210.186:27017/alaa?authSource=admin";

// const path = require("path");
// const { mongo_connection_url } = require("./models/config");

// mongoose.connect(uri).then(() => console.log("connected mongoose"));

// app.use(
//   cors({
//     origin: "*",
//   })
// );
// app.use(bodyParser.urlencoded({ extended: true }));
// app.use(bodyParser.json());

// app.use("/public", express.static(path.join(__dirname, "public")));

// const userRoute = require("./routers/userRoute");
// const managerRoute = require("./routers/manager_route");
// const storyRoute = require("./routers/story_router");
// const videoRoute = require("./routers/video_router");
// const chatRoute = require("./routers/chat_route");
// const quizRoute = require("./routers/quiz_route");

// const categoryRoute = require("./routers/category_router");
// const ageRoute = require("./routers/age_router");
// const postRoute = require("./routers/post_route");
// const suggRoute = require("./routers/suggRoute");
// const score = require("./routers/score_router");
// const interest = require("./routers/interest_router");

// app.use(
//   "/api",
//   userRoute,
//   managerRoute,
//   storyRoute,
//   videoRoute,
//   chatRoute,
//   quizRoute,
//   categoryRoute,
//   ageRoute,
//   postRoute,
//   suggRoute,
//   score,
//   interest
// );

// server.listen(4000);
const dotenv = require("dotenv");
dotenv.config();

const express = require("express");
const app = express();
const port = 4000 || process.env.PORT;
const cors = require("cors");
const bodyParser = require("body-parser");

const http = require("http");

const server = http.createServer(app);

const socket = require("socket.io");

const io = socket(server);

app.set("io", io);

io.on("connection", (socket) => {
  console.log(
    `a new connection and count is: ${socket.client.conn.server.clientsCount}`
  );

  io.emit("notification", {
    notification: {
      title: `A new video was added`,
      body: `Video 'The Story of letter (A)`,
      type: "video",
    },
  });

  socket.on("disconnect", () => {
    console.log(
      `User disconnected and count is: ${socket.client.conn.server.clientsCount}`
    );
  });
});

const mongoose = require("mongoose");
// const uri = 'mongodb+srv://danaaka8:p6TPp7ILrQUlDKfE@cluster0.uyhqfof.mongodb.net/alaa'; // Replace with your MongoDB connection URI
const uri =
  "mongodb://admin:admin123@70.34.210.186:27017/alaa?authSource=admin";

//const uri = 'mongodb+srv://danaaka8:p6TPp7ILrQUlDKfE@cluster0.uyhqfof.mongodb.net/alaa'; // Replace with your MongoDB connection URI

const path = require("path");

mongoose.connect(uri).then(() => console.log("connected mongoose"));

app.use(
  cors({
    origin: "*",
  })
);
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

app.use("/public", express.static(path.join(__dirname, "public")));

const userRoute = require("./routers/userRoute");
const managerRoute = require("./routers/manager_route");
const storyRoute = require("./routers/story_router");
const videoRoute = require("./routers/video_router");
const chatRoute = require("./routers/chat_route");
const quizRoute = require("./routers/quiz_route");

const categoryRoute = require("./routers/category_router");
const ageRoute = require("./routers/age_router");
const postRoute = require("./routers/post_route");
const suggRoute = require("./routers/suggRoute");
const score = require("./routers/score_router");
const interest = require("./routers/interest_router");

app.use(
  "/api",
  userRoute,
  managerRoute,
  storyRoute,
  videoRoute,
  chatRoute,
  quizRoute,
  categoryRoute,
  ageRoute,
  postRoute,
  suggRoute,
  score,
  interest
);

server.listen(4000);
