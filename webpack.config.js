var webpack = require('webpack')

module.exports = {
  entry: './src/polydivision.coffee',
  output: {
    path: __dirname,
    filename: 'polydivision.js'
  },
  module: {
    rules: [
      {
        test: /\.coffee$/,
        use: [ 'coffee-loader' ]
      }
    ]
  }
}
