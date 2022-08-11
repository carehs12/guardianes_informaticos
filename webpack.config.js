// · Including plugins and dependencies
var dayjs = require("dayjs");
var webpack = require("webpack");
var TerserPlugin = require("terser-webpack-plugin");
var VueLoaderPlugin = require("vue-loader/lib/plugin");

// ·
module.exports = (env) => {
  // set mode
  env.mode = env.mode ? env.mode : "development";
  env.watch = env.watch ? env.watch : false;

  // set production boolean
  var production = env.mode == "production" ? true : false;

  // default webpack configuration
  return {
    watch: env.watch == "true",
    mode: production ? "production" : "development",
    performance: { hints: false },
    optimization: {
      minimize: production,
      minimizer: [
        new TerserPlugin({
          terserOptions: {
            format: {
              comments: false,
            },
          },
          extractComments: false,
          parallel: true,
        }),
      ],
    },
    entry: {
      authentication: "./vue/authentication/app.js",
      application: "./vue/application/app.js"
    },
    output: {
      path: __dirname,
      filename: "app/assets/javascript/[name]/app.js",
    },
    resolve: {
      alias: {
        // resolve vuejs
        vue: production ? "vue/dist/vue.min.js" : "vue/dist/vue.js",
      },
      extensions: [".js"],
    },

    module: {
      rules: [
        {
          test: /\.vue$/,
          loader: "vue-loader",
        },
        {
          test: /\.css$/,
          use: [
            "style-loader", // creates style nodes from JS strings
            "css-loader", // translates CSS into CommonJS
          ],
        },
        {
          test: /\.scss$/,
          use: [
            "style-loader", // creates style nodes from JS strings
            "css-loader", // translates CSS into CommonJS
            {
              loader: "sass-loader", // compiles Sass to CSS, using Node Sass by default
            },
          ],
        },
        {
          test: /\.m?js$/,
          exclude: /(node_modules|bower_components)/,
          use: {
            loader: "babel-loader",
            options: {
              presets: [["@babel/preset-env", { targets: "defaults" }]],
            },
          },
        },
      ],
    },

    watchOptions: {
      poll: 1000,
      aggregateTimeout: 300,
      ignored: /node_modules/,
    },

    plugins: [
      new VueLoaderPlugin(),
      new webpack.DefinePlugin({
        app_mode_production: JSON.stringify(production),
        app_mode_development: JSON.stringify(!production),
        app_compilation: JSON.stringify(
          `[BUILD] (core) ${dayjs().format("YYMMDD.HHmm").toString()} `
        ),
      }),
    ],
  };
};
