<script>
export default {
  data() {
    return {
      service: null,
      translations: {
        services: I18n.t("apps.services"),
        application: I18n.t("application"),
      },
    };
  },

  methods: {
    confirm(service) {
      this.service = service;
      this.$bvModal.show("bv-modal-service-delete");
    },

    deleteUser() {
      let url = `/services/${this.service.id}.json`;
      this.http.delete(url).then((response) => {
        if (response.success) {
          this.$emit("service-deleted", this.service);
          this.notify(
            this.translations.services.notifications.destroyed,
            "success"
          );
        } else {
          this.notify(response.error.message, "danger");
        }
      });
      this.$bvModal.hide("bv-modal-service-delete");
    },
  },
};
</script>
<template>
  <b-modal id="bv-modal-service-delete" hide-footer>
    <template #modal-title>
      {{ translations.services.title_confirm_deletion }}
    </template>
    <div class="d-block">
      {{ translations.services.text_confirm_deletion }}
    </div>
    <hr class="mb-1" />
    <div class="text-right">
      <b-button
        type="button"
        class="mt-3"
        @click="$bvModal.hide('bv-modal-service-delete')"
      >
        {{ translations.application.shared.cancel }}
      </b-button>
      <b-button type="button" class="mt-3" variant="danger" @click="deleteUser">
        {{ translations.application.actions.services.delete }}
      </b-button>
    </div>
  </b-modal>
</template>
