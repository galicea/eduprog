var path = require('path');
var webpack = require('webpack');
 
module.exports = {
  entry: './src/index.js',
  output: { path: __dirname, filename: 'example01.js' },
  module: {
    loaders: [
      { test: /\.svg$/, loader: 'svg-loader' },
      { test: /\.css$/, loader: 'css-loader' },
      {
        test: /\.js$/,
        use: [ { loader: 'babel-loader', options: { presets: ['es2015', 'react'] } } ],
        exclude: /node_modules/,
      }
   ]
 },
};