import Fastify from "fastify";
import { controller } from "./routes/controller";

const app = Fastify({
  logger: true,
});

app.register(controller);

export default app;
