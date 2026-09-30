import Fastify from "fastify";
import { controller } from "./routes/controller";

const app = Fastify({
  
  logger: !!process.env.LOGGER_ENABLED,
});

app.register(controller);

export default app;
