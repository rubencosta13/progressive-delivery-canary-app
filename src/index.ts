import app from "./app";
console.log(
  "[v2 Deployment Track]: ",
  process.env.DEPLOYMENT_TRACK ?? "stable",
);

app.listen({
  host: process.env.HOST!,
  port: 3000,
});
