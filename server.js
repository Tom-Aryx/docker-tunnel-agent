
const port = process.env.PORT || 3000;

const express = require("express");
const app = express();

const { legacyCreateProxyMiddleware } = require("http-proxy-middleware");

var exec = require("child_process").exec;
var path = require("path");

// static
app.use(express.static(path.join(__dirname, 'public')));

app.get("/", function (req, res) {
  res.redirect('/index.html')
});

app.use(
  legacyCreateProxyMiddleware({
    target: 'http://127.0.0.1:8080/',
    ws: true,
    changeOrigin: true,
    on: {
      proxyRes: function proxyRes(proxyRes, req, res) {
      },
      proxyReq: function proxyReq(proxyReq, req, res) {
      },
      error: function error(err, req, res) {
        console.warn('websocket error.', err);
      }
    },
    pathRewrite: {
      '^/': '/',
    },
  })
);

// run script
exec("bash entrypoint.sh", function (err, stdout, stderr) {
  if (err) {
    console.error(err);
    return;
  }
  console.log(stdout);
});

app.listen(port, () => {
    console.log(`Listening on port ${port}!`)
});