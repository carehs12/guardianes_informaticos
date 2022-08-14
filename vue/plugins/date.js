export default {
  install(Vue, _options) {
    const zeroPad = (num, places = 2) => String(num).padStart(places, "0");

    const vcDatepickerConfig = function (_options) {
      return {
        id: "es-CL",
        firstDayOfWeek: 2, // sunday is number 1
      };
    };

    const weekStart = function (date) {
      const new_date = new Date(date.getTime());
      const days_from_monday = (new_date.getDay() + 6) % 7;
      new_date.setDate(new_date.getDate() - days_from_monday);
      return new_date;
    };

    const weekEnd = function (date) {
      const week_start = weekStart(date);
      let new_date = new Date(week_start.getTime());
      new_date.setDate(new_date.getDate() + 6);
      return new_date;
    };

    const format = function (date) {
      return `${zeroPad(date.getDate())}/${zeroPad(
        date.getMonth() + 1
      )}/${date.getFullYear()}`;
    };

    const weekdays = ["mon", "tue", "wed", "thu", "fri", "sat", "sun"];

    Vue.prototype.date = {
      vcDatepickerConfig,
      weekdays,
      weekStart,
      weekEnd,
      format,
      zeroPad,
    };
  },
};
