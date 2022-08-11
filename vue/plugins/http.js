import axios from "axios";

//  · Plugin initializing
// ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
export default {
  install(Vue, _options) {
    // Get authentication token from rails
    let meta = document.querySelector('meta[name="csrf-token"]');
    let token = "";

    if (meta) {
      token = meta.getAttribute("content");
    }

    let http = axios.create({
      headers: { "X-CSRF-Token": token },
    });

    http.interceptors.response.use(
      (response) => {
        if (response.status == 200) {
          return {
            data: response.data.data,
            status: response.status
          };
        }

        return {
          status: response.status,
          error: response.data.error,
        };
      },
      (error) => {
        let message = "";
        if (error.response.data.error && error.response.data.error.message) {
          message = error.response.data.error.message;
        } else {
          message = `HTTP Request ${error.config.method} to url ${error.config.url} ${error.message}`;
        }

        return {
          status: error.response.status,
          error: {
            error: error.response.statusText,
            message: message,
          },
        };
      }
    );
    Vue.prototype.http = http;
  },
};
