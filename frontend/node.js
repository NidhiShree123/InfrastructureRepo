const http = require('http');
const fs = require('fs');
const path = require('path');

const PORT = 3000;

const server = http.createServer((req, res) => {
    // Serve a simple HTML frontend
    if (req.url === '/' || req.url === '/index.html') {
        fs.readFile(path.join(__dirname, 'index.html'), (err, data) => {
            if (err) {
                res.writeHead(500, { 'Content-Type': 'text/plain' });
                res.end('Server Error');
                return;
            }
            res.writeHead(200, { 'Content-Type': 'text/html' });
            res.end(data);
        });
    } else if (req.url === '/style.css') {
        fs.readFile(path.join(__dirname, 'style.css'), (err, data) => {
            if (err) {
                res.writeHead(404, { 'Content-Type': 'text/plain' });
                res.end('Not Found');
                return;
            }
            res.writeHead(200, { 'Content-Type': 'text/css' });
            res.end(data);
        });
    } else {
        res.writeHead(404, { 'Content-Type': 'text/plain' });
        res.end('Not Found');
    }
});

server.listen(PORT, () => {
    console.log(`Server running at http://localhost:${PORT}/`);
});

// Sample index.html and style.css files should be created in the same directory:
// index.html:
// <!DOCTYPE html>
// <html>
// <head>
//   <title>Sample Node.js Frontend</title>
//   <link rel="stylesheet" href="style.css">
// </head>
// <body>
//   <h1>Hello from Node.js Frontend!</h1>
//   <p>This is a simple frontend served by Node.js.</p>
// </body>
// </html>
//
// style.css:
// body { font-family: Arial, sans-serif; background: #f0f0f0; }
// h1 { color: #0078d7; }