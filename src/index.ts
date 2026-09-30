import app from "./app";
console.log(
  "[v2 Deployment Track]: ",
  process.env.DEPLOYMENT_TRACK ?? "stable",
);

app.listen({
  port: 3000,
});
