<script>
export default {
  props: {
    scheduleId: {
      required: true,
    },
  },

  data() {
    return {
      availability: null,
      translations: {
        availabilities: I18n.t("apps.availabilities"),
        application: I18n.t("application"),
      },
    };
  },

  methods: {
    confirm(availability) {
      this.availability = availability;
      this.$bvModal.show("bv-modal-availability-delete");
    },

    deleteAvailability() {
      let url = `schedules/${this.scheduleId}/availabilities/${this.availability.id}.json`;
      this.http.delete(url).then((response) => {
        if (response.success) {
          this.$emit("availability-deleted", this.availability);
          this.notify(
            this.translations.availabilities.notifications.destroyed,
            "success"
          );
          this.$emit("user-deleted");
        } else {
          this.notify(response.error.message, "danger");
        }
      });
      this.$bvModal.hide("bv-modal-availability-delete");
    },
  },
};
</script>
<template>
  <b-modal id="bv-modal-availability-delete" hide-footer>
    <template #modal-title>
      {{ translations.availabilities.title_confirm_deletion }}
    </template>
    <div class="d-block">
      {{ translations.availabilities.text_confirm_deletion }}
    </div>
    <hr class="mb-1" />
    <div class="text-right">
      <b-button
        type="button"
        class="mt-3"
        @click="$bvModal.hide('bv-modal-availability-delete')"
      >
        {{ translations.application.shared.cancel }}
      </b-button>
      <b-button
        type="button"
        class="mt-3"
        variant="danger"
        @click="deleteAvailability"
      >
        {{ translations.application.actions.availabilities.delete }}
      </b-button>
    </div>
  </b-modal>
</template>
