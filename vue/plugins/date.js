export default {
  install(Vue, _options) {
    let vcDatepickerConfig = function (_options) {
      return {
        id: "es-CL",
        firstDayOfWeek: 2, // sunday is number 1
      };
    };

    Vue.prototype.date = {
      vcDatepickerConfig,
    };
  },
};
