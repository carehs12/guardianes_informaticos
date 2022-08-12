<script>
export default {
  data() {
    return {
      user: null,
      translations: {
        users: I18n.t("apps.users"),
        application: I18n.t("application"),
      },
    };
  },

  methods: {
    confirm(user) {
      this.user = user;
      this.$bvModal.show("bv-modal-user-delete");
    },

    deleteUser() {
      let url = `/users/${this.user.id}.json`;
      this.http.delete(url).then((response) => {
        if (response.success) {
          this.$emit("user-deleted", this.user);
          this.notify(
            this.translations.users.notifications.destroyed,
            "success"
          );
        } else {
          this.notify(response.error.message, "danger");
        }
      });
      this.$bvModal.hide("bv-modal-user-delete");
    },
  },
};
</script>
<template>
  <b-modal id="bv-modal-user-delete" hide-footer>
    <template #modal-title>
      {{ translations.users.title_confirm_deletion }}
    </template>
    <div class="d-block">
      {{ translations.users.text_confirm_deletion }}
    </div>
    <hr class="mb-1" />
    <div class="text-right">
      <b-button
        type="button"
        class="mt-3"
        @click="$bvModal.hide('bv-modal-user-delete')"
      >
        {{ translations.application.shared.cancel }}
      </b-button>
      <b-button type="button" class="mt-3" variant="danger" @click="deleteUser">
        {{ translations.application.actions.users.delete }}
      </b-button>
    </div>
  </b-modal>
</template>
