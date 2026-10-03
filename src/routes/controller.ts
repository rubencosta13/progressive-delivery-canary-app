import type { FastifyInstance } from "fastify";
import { z } from "zod";

export const User = z.object({
  name: z.string().nonoptional(),
  number: z.number().nonoptional(),
});

export const controller = async (fastify: FastifyInstance) => {
  fastify.get("/", (_request, response) => {
    const responseJson = {
      message: `Hello from ${process.env.DEPLOYMENT_TRACK ?? "unknown"} app`,
      version: process.env.APP_VERSION,
      track: process.env.DEPLOYMENT_TRACK,
    };
    return response.code(200).send(responseJson);
  });

  fastify.post("/user", async (request, response) => {
    const user = await User.parseAsync(request.body);
    response.send(user);
  });

  fastify.get("/500", (_request, response) => {
    return response.code(500).send("Status code 500");
  });

  fastify.get("/404", (_request, response) => {
    return response.code(404).send("Status code 404");
  });

  fastify.get("/error", (_request, _response) => {
    throw new Error("Something went pretty wrong");
  });

  fastify.get("/flaky", (_request, response) => {
    if (Math.random() < 0.1) {
      return response.code(503).send("Temporarily Unavailable");
    }
    return response.status(200).send("Ok");
  });

  fastify.get("/slow", async (_request, response) => {
    await new Promise((r) => setTimeout(r, 300 + Math.random() * 700));
    return response.status(200).send("Ok");
  });

  fastify.get("/redirect", (request, response) => {
    return response.redirect("/");
  });
};
