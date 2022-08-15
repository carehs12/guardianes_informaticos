<script>
import vSubmit from "../../../../../components/form/v-submit.vue";
import vInput from "../../../../../components/form/v-input.vue";
import vDate from "../../../../../components/form/v-date.vue";
import componentLoadingData from "../../../../../components/layout/loading-data.vue";
import messageNewSchedule from "../../components/schedules/message-new-schedule.vue";

import formLayout from "../../../layouts/form.vue";
export default {
  components: {
    componentLoadingData,
    vSubmit,
    vInput,
    vDate,
    formLayout,
    messageNewSchedule,
  },

  props: {
    mode: {
      type: String,
      required: true,
    },
  },
  data() {
    return {
      translations: {
        application: I18n.t("application"),
        schedules: I18n.t("activerecord.attributes.schedule"),
        notifications: I18n.t("apps.schedules.notifications"),
      },
      schedule_id: null,
      schedule: null,
      services: [],
      submit: {
        schedule: false,
      },
    };
  },

  mounted() {
    this.getSchedule();
    this.getServices();
  },
  methods: {
    setWeekAndYear() {
      let [year, week] = this.date.getWeekAndYear(this.schedule.date);
      this.schedule.week = week;
      this.schedule.year = year;
    },

    getServices() {
      let url = "/services.json?page=1&per_page=1000";
      this.http.get(url).then((response) => {
        if (response.success) {
          this.services = response.data.records;
        } else {
          this.notify(response.error.message, "danger");
        }
      });
    },

    getSchedule() {
      if (this.schedule_id) {
        let url = `/schedules/${this.schedule_id}.json`;
        this.http.get(url).then((response) => {
          if (response.success) {
            this.schedule = response.data;
            this.focusOnDate();
          } else {
            this.notify(response.error.message, "danger");
          }
        });
      } else {
        this.initializeScheduleStructure();
        this.focusOnDate();
      }
    },

    initializeScheduleStructure() {
      this.schedule = {
        date: new Date(),
      };
    },

    postScheduleHandler(event) {
      if (event) {
        event.preventDefault();
      }

      let data = { schedule: this.schedule };
      this.submit.schedule = true;
      this.http.post("/schedules.json", data).then((response) => {
        this.submit.schedule = false;
        if (response.success) {
          this.notify(this.translations.notifications.created, "success");
          this.$router.push(`/schedules/${response.data.id}/edit`);
        } else {
          this.notify(response.error.message, "danger");
        }
      });
    },

    focusOnDate() {
      this.$nextTick(() => {
        this.$refs["input-date"].focus();
      });
    },
  },

  watch: {
    "schedule.date"() {
      if (this.schedule.date) {
        this.setWeekAndYear();
      }
    },
  },
};
</script>
<template>
  <b-form @submit="postScheduleHandler" v-if="schedule">
    <form-layout>
      <message-new-schedule v-if="mode == 'creation'"></message-new-schedule>
      <b-form-group :label="translations.schedules.service">
        <b-form-select v-model="schedule.service_id" class="mb-2">
          <b-form-select-option
            v-for="service in services"
            :value="service.id"
            :key="service.id"
          >
            {{ service.name }}
          </b-form-select-option>
        </b-form-select>
      </b-form-group>
      <v-date
        :description="translations.application.shared.text_field_required"
        :label="translations.schedules.date"
        required
        ref="input-date"
        v-model="schedule.date"
      ></v-date>
      <v-input
        :label="translations.schedules.week"
        type="text"
        readonly
        :min="1"
        :max="53"
        v-model="schedule.week"
      >
      </v-input>
      <v-input
        :label="translations.schedules.year"
        type="text"
        readonly
        :min="0"
        v-model="schedule.year"
      ></v-input>

      <b-form-group>
        <v-submit
          :submitting="submit.schedule"
          :title="translations.application.actions.schedules.save"
          icon="fa-save"
        >
        </v-submit>
      </b-form-group>
    </form-layout>
  </b-form>
  <component-loading-data v-else />
</template>
