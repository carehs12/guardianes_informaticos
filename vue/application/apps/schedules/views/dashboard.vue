<script>
import layoutMain from "../../../layout/main.vue";
import layoutHeader from "../../../layout/header.vue";

import componentFilters from "../components/schedules/filters.vue";
import componentWeeklyTurns from "../components/schedules/weekly-turns.vue";
import componentWorkHours from "../components/schedules/work-hours.vue";
import componentTitle from "../components/schedules/title.vue";

export default {
  components: {
    layoutMain,
    layoutHeader,
    componentFilters,
    componentWeeklyTurns,
    componentWorkHours,
    componentTitle,
  },

  data() {
    return {
      translations: {
        application: I18n.t("application"),
        schedules: I18n.t("apps.schedules"),
      },
      filters: {
        year: null,
        week: null,
        date: new Date(),
      },
      schedule: {
        id: null,
        results: [],
        work_hours: [],
      },
    };
  },

  methods: {
    setWeekAndYear() {
      let [year, week] = this.date.getWeekAndYear(this.filters.date);
      if (week != this.filters.week || year != this.filters.year) {
        this.filters.week = week;
        this.filters.year = year;

        if (this.filters.week && this.filters.year) {
          this.getSchedule();
        }
      }
    },

    getSchedule() {
      let url = `/schedules.json?week=${this.filters.week}&year=${this.filters.year}`;

      if (this.$route.query.id) {
        url = `/schedules/${this.$route.query.id}.json`;
      }

      this.http.get(url).then((response) => {
        if (response.success) {
          this.schedule = response.data;
          if (this.$route.query.id) {
            this.$router.replace('/')
            this.filters.date = new Date(this.schedule.date);
          }
        } else if (response.status == 404) {
          this.schedule = { id: null, results: [], work_hours: [] };
        } else {
          this.notify(response.error.message, "danger");
        }
      });
    },
  },

  watch: {
    "filters.date"() {
      if (this.filters.date) {
        this.setWeekAndYear();
      }
    },
  },
};
</script>
<template>
  <layout-main>
    <layout-header
      :title="translations.application.apps.schedules"
      :action-new="translations.application.actions.schedules.new"
      url="schedules"
    ></layout-header>
    <hr />
    <div class="row">
      <div class="col-3">
        <component-filters v-model="filters" />
        <component-work-hours
          :work-hours="schedule.work_hours"
        ></component-work-hours>
      </div>
      <div class="col-9">
        <div v-if="filters.date && schedule.id">
          <component-title
            :schedule-date="filters.date"
            :schedule-id="schedule.id"
            :service-name="schedule.service_name"
          ></component-title>
          <component-weekly-turns
            :schedule-date="filters.date"
            :schedule-results="schedule.results"
          ></component-weekly-turns>
        </div>
        <div v-else class="text-center text-muted">
          <h4>
            {{ translations.schedules.notifications.no_schedule_found }}
            <br />
            <i class="mt-3 fas fa-folder-open fa-2x"></i>
          </h4>
        </div>
      </div>
    </div>
  </layout-main>
</template>
