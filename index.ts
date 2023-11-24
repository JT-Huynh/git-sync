import figlet from "figlet";

const server = Bun.serve({
  port: Bun.env.PORT,
  fetch(req) {
    const url = new URL(req.url);

    if (url.pathname === "/ping") {
      const prompt = figlet.textSync("Git Sync Listening");
      return new Response(prompt);
    }

    if (url.pathname === "/sync") {
      return new Response();
    }

    return new Response("404!");
  },
});

console.log(`Listening on http://localhost:${server.port} ...`);
