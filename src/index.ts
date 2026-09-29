import app from "./app";
console.log("[Deployment Track]: ", process.env.DEPLOYMENT_TRACK ?? "stable");

app.listen({
  port: 3000,
});
