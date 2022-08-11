/*
@description HTTP plugin for all components. Allows apps to 
  make http requests using axios
*/
import axios from "axios";

// @param response [Object] The response object as returned by axios
// @return [Object] An object containing the status of the response and
//   any data/error that was received
const responseHandler = (response) => {
  if (response.status == 200) {
    return {
      data: response.data.data,
      status: response.status,
      success: true
    };
  }

  return {
    status: response.status,
    error: response.data.error,
    success: false
  };
};

// @param error [Object] The error that ocurred when rending an HTTP request
// @return [Object] An object containing the error code and message 
const errorHandler = (error) => {
  let message = "";
  if (error.response.data.error && error.response.data.error.message) {
    message = error.response.data.error.message;
  } else {
    message = `HTTP Request ${error.config.method} to url ${error.config.url} ${error.message}`;
  }

  return {
    status: error.response.status,
    success: false,
    error: {
      error: error.response.statusText,
      message: message,
    },
  };
};

export default {
  install(Vue, _options) {
    // Get authentication token from rails
    let meta = document.querySelector('meta[name="csrf-token"]');
    let token = "";

    if (meta) {
      token = meta.getAttribute("content");
    }

    // Add the authentication token from rails
    let http = axios.create({
      headers: { "X-CSRF-Token": token },
    });

    http.interceptors.response.use(responseHandler, errorHandler);
    Vue.prototype.http = http;
  },
};
