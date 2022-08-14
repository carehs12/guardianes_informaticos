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
      },
      filters: {
        year: 2022,
        week: 1,
        date: new Date(),
      },
      work_hours: [
        {
          full_name: "Carlos Hermosilla",
          work_hours: 15,
        },
        {
          full_name: "Mafer Ovando",
          work_hours: 19,
        },
        {
          full_name: "Jose Pérez",
          work_hours: 18,
        },
      ],
      schedule: {
        id: 1,
        service_name: "SERVICIO 1",
        results: [
          {
            id: 10,
            start_at: 8,
            schedules: [
              { id: 1, user: "Carlos Hermosilla", user_id: 1 },
              { id: 2, user: "Carlos Hermosilla", user_id: 1 },
              { id: 3, user: "Carlos Hermosilla", user_id: 1 },
              { id: 4, user: "Carlos Hermosilla", user_id: 1 },
              { id: 5, user: "Carlos Hermosilla", user_id: 1 },
            ],
          },
          {
            id: 11,
            start_at: 10,
            schedules: [
              { id: 6, user: "Carlos Hermosilla", user_id: 1 },
              { id: 7, user: "Carlos Hermosilla", user_id: 1 },
              { id: 8, user: "Carlos Hermosilla", user_id: 1 },
              { id: 9, user: "Carlos Hermosilla", user_id: 1 },
              { id: 10, user: "Carlos Hermosilla", user_id: 1 },
            ],
          },
          {
            id: 12,
            start_at: 8,
            schedules: [
              { id: 11, user: "Carlos Hermosilla", user_id: 1 },
              { id: 12, user: "Carlos Hermosilla", user_id: 1 },
              { id: 13, user: "Carlos Hermosilla", user_id: 1 },
              { id: 14, user: "Carlos Hermosilla", user_id: 1 },
              { id: 15, user: "Carlos Hermosilla", user_id: 1 },
            ],
          },
          {
            start_at: 11,
            schedules: [
              { id: 16, user: "Mafer Ovando", user_id: 2 },
              { id: 17, user: "Mafer Ovando", user_id: 2 },
              { id: 18, user: "Mafer Ovando", user_id: 2 },
              { id: 19, user: "Mafer Ovando", user_id: 2 },
              { id: 20, user: "Mafer Ovando", user_id: 2 },
            ],
          },
          {
            start_at: 8,
            schedules: [
              { id: 21, user: "Mafer Ovando", user_id: 2 },
              { id: 22, user: "Mafer Ovando", user_id: 2 },
              { id: 23, user: "Mafer Ovando", user_id: 2 },
              { id: 24, user: "Mafer Ovando", user_id: 2 },
              { id: 25, user: null, user_id: 2 },
              { id: 25, user: null, user_id: 2 },
              { id: 25, user: "Mafer Ovando", user_id: 2 },
              { id: 25, user: "Mafer Ovando", user_id: 2 },
            ],
          },
          {
            start_at: 8,
            schedules: [
              { id: 26, user: "Jose Pérez", user_id: 3 },
              { id: 27, user: "Jose Pérez", user_id: 3 },
              { id: 28, user: "Jose Pérez", user_id: 3 },
              { id: 29, user: "Jose Pérez", user_id: 3 },
              { id: 30, user: "Jose Pérez", user_id: 3 },
            ],
          },
          {
            start_at: 8,
            schedules: [
              { id: 31, user: "Jose Pérez", user_id: 3 },
              { id: 32, user: "Jose Pérez", user_id: 3 },
              { id: 33, user: "Jose Pérez", user_id: 3 },
              { id: 34, user: "Jose Pérez", user_id: 3 },
              { id: 35, user: "Jose Pérez", user_id: 3 },
            ],
          },
        ],
      },
    };
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
        <component-work-hours :work-hours="work_hours"></component-work-hours>
      </div>
      <div class="col-9">
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
    </div>
  </layout-main>
</template>
