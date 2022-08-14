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

    /* For a given date, get the ISO week number
     *
     * Credits to: https://stackoverflow.com/questions/6117814/get-week-of-year-in-javascript-like-in-php
     * Based on information at:
     *
     *    THIS PAGE (DOMAIN EVEN) DOESN'T EXIST ANYMORE UNFORTUNATELY
     *    http://www.merlyn.demon.co.uk/weekcalc.htm#WNR
     *
     * Algorithm is to find nearest thursday, it's year
     * is the year of the week number. Then get weeks
     * between that date and the first day of that year.
     *
     * Note that dates in one year can be weeks of previous
     * or next year, overlap is up to 3 days.
     *
     * e.g. 2014/12/29 is Monday in week  1 of 2015
     *      2012/1/1   is Sunday in week 52 of 2011
     */
    function getWeekAndYear(d) {
      // Copy date so don't modify original
      d = new Date(Date.UTC(d.getFullYear(), d.getMonth(), d.getDate()));
      // Set to nearest Thursday: current date + 4 - current day number
      // Make Sunday's day number 7
      d.setUTCDate(d.getUTCDate() + 4 - (d.getUTCDay() || 7));
      // Get first day of year
      var yearStart = new Date(Date.UTC(d.getUTCFullYear(), 0, 1));
      // Calculate full weeks to nearest Thursday
      var weekNo = Math.ceil(((d - yearStart) / 86400000 + 1) / 7);
      // Return array of year and week number
      return [d.getUTCFullYear(), weekNo];
    }

    const weekdays = ["mon", "tue", "wed", "thu", "fri", "sat", "sun"];

    Vue.prototype.date = {
      vcDatepickerConfig,
      weekdays,
      weekStart,
      weekEnd,
      format,
      zeroPad,
      getWeekAndYear
    };
  },
};
