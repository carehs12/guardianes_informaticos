<script>
import layoutMain from "../../../layout/main.vue";
import layoutHeader from "../../../layout/header.vue";

import componentFilters from "../components/schedules/filters.vue";
import componentFormWeeklyTurns from "../components/schedules/form-weekly-turns.vue";
import componentWorkHours from "../components/schedules/work-hours.vue";
import componentTitle from "../components/schedules/title.vue";
import VSubmit from "../../../../components/form/v-submit.vue";

export default {
  components: {
    layoutMain,
    layoutHeader,
    componentFilters,
    componentFormWeeklyTurns,
    componentWorkHours,
    componentTitle,
    VSubmit,
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
      submit: {
        schedule: false,
      },
      schedule: {
        id: null,
        availabilities: [],
      },
    };
  },

  mounted() {
    this.getAvailabilities();
  },

  methods: {
    getAvailabilities() {
      let url = `/schedules/${this.$route.params.id}/availabilities.json`;
      this.http.get(url).then((response) => {
        if (response.success) {
          this.schedule = response.data;
          this.filters.year = this.schedule.year;
          this.filters.week = this.schedule.week;
        } else if (response.status == 404) {
          this.schedule = { id: null, results: [], work_hours: [] };
        } else {
          this.notify(response.error.message, "danger");
        }
      });
    },

    putAvailabilitiesHander(event) {
      if (event) {
        event.preventDefault();
      }

      let data = {
        schedule: {
          availabilities_attributes: this.constructAvailabilitiesData().flat(),
        },
      };
      this.submit.schedule = true;

      let url = `/schedules/${this.$route.params.id}/availabilities.json`;
      this.http
        .put(url, data)
        .then((response) => {
          if (response.success) {
            this.notify(
              this.translations.schedules.notifications.updated,
              "success"
            );
          } else {
            this.notify(response.error.message, "danger");
          }
        })
        .finally(() => {
          this.submit.schedule = false;
        });
    },

    constructAvailabilitiesData() {
      return this.schedule.availabilities.map((availabilities) => {
        return availabilities.map((availability) => {
          const availability_data = {};
          availability.availability.forEach((hour_element, index) => {
            return (availability_data[
              `hour${this.date.zeroPad(index + availability.start_at)}`
            ] = hour_element);
          });
          return {
            ...availability_data,
            id: availability.id,
          };
        });
      });
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
        <component-filters
          v-model="filters"
          hide-date
          :title="translations.schedules.schedule"
        />
      </div>
      <div class="col-9">
        <div v-if="filters.date && schedule.id">
          <component-title
            hide-edit
            :schedule-date="new Date(schedule.date)"
            :schedule-id="schedule.id"
            :service-name="schedule.service_name"
          ></component-title>
          <b-tabs content-class="mt-3">
            <b-tab
              v-for="(weekday, day_index) in date.weekdays"
              :key="weekday"
              :title="translations.schedules.wdays[weekday]"
            >
              <b-form @submit="putAvailabilitiesHander">
                <fieldset :disabled="submit.schedule">
                  <component-form-weekly-turns
                    :schedule-date="filters.date"
                    :day-availabilities="schedule.availabilities[day_index]"
                    :day-index="day_index"
                  >
                  </component-form-weekly-turns>
                  <v-submit
                    :title="translations.application.actions.schedules.update"
                    :submitting="submit.schedule"
                    icon="fa-save"
                  ></v-submit>
                </fieldset>
              </b-form>
            </b-tab>
          </b-tabs>
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
