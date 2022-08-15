<script>
import vInput from "../../../../../components/form/v-input.vue";
import VSubmit from "../../../../../components/form/v-submit.vue";
export default {
  components: { vInput, VSubmit },
  props: {
    scheduleId: {
      required: true,
    },
  },
  data() {
    return {
      delete_text: "",
      translations: {
        schedules: I18n.t("apps.schedules"),
      },
    };
  },

  methods: {
    deleteScheduleHandler(event) {
      if (event) {
        event.preventDefault();
      }

      let url = `/schedules/${this.scheduleId}.json`;
      this.http.delete(url).then((response) => {
        if (response.success) {
          this.$emit("schedule-deleted");
          this.notify(
            this.translations.schedules.notifications.destroyed,
            "success"
          );
        } else {
          this.notify(response.error.message, "danger");
        }
      });
    },
  },
};
</script>
<template>
  <div class="card">
    <div class="card-body">
      <b-alert variant="warning" show>
        {{ translations.schedules.notifications.delete_schedule_warning }}
      </b-alert>
      <b-form @submit="deleteScheduleHandler">
        <v-input v-model="delete_text"> </v-input>
        <v-submit
          class="btn-danger"
          :disabled="
            delete_text !=
            translations.schedules.text_confirmation_delete_schedule
          "
          :title="translations.schedules.text_delete_schedule"
          icon="fa-trash-alt"
        >
        </v-submit>
      </b-form>
    </div>
  </div>
</template>
