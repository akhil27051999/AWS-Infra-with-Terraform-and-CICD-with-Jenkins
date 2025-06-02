console.log("Hello from Node.js app!");

// Simple example server (optional, if you want HTTP server)
const http = require('http');

const port = 3000;

const requestHandler = (req, res) => {
  res.end('Hello World!');
};

const server = http.createServer(requestHandler);

server.listen(port, () => {
  console.log(`Server running at http://localhost:${port}/`);
});
