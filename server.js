const webpackDevServer = require('webpack-dev-server');
const webpack = require('webpack');
const config = require('./webpack.config.js');

const options = {
  hot: true,
  host: 'localhost'
};

webpackDevServer.addDevServerEntrypoints(config, options);

const compiler = webpack(config);
const server = new webpackDevServer(compiler, options);

server.listen(3000, 'localhost', err => {
  if (err) {
    console.log(err);
  }
  console.log('dev server listening on port 3000');
});

