<script>
import vSubmit from "../../../../components/form/v-submit.vue";
import vTitle from "../../../../components/form/v-title.vue";
import vInput from "../../../../components/form/v-input.vue";

export default {
  components: { vSubmit, vTitle, vInput },
  data() {
    return {
      translations: {
        shared: I18n.t("users.passwords.shared"),
        main: I18n.t("users.passwords.create"),
        application: I18n.t("application"),
      },
      submit: {
        password: false,
      },
      user: {
        username: "",
      },
    };
  },

  methods: {
    postPasswordHandler(event) {
      if (event) {
        event.preventDefault();
      }

      let url = "/password";
      let data = { user: this.user };
      this.submit.password = true;

      this.http
        .post(url, data)
        .then((response) => {
          if (response.success) {
            this.postPasswordHandlerSuccess(response);
          } else {
            this.postPasswordHandlerError(response.error.message);
          }
        })
        .finally(() => {
          this.submit.password = false;
        });
    },

    postPasswordHandlerSuccess(response) {
      let message = this.translations.main.reset_token_sent;
      message = message.replace("%{email}", response.data.email);
      this.notify(message, "success");
    },

    postPasswordHandlerError(error_message) {
      this.notify(error_message, "danger");
      this.$refs["password-username"].focus();
    },
  },
};
</script>

<template>
  <b-form class="border p-3" @submit="postPasswordHandler">
    <v-title
      :title="translations.application.title"
      :subtitle="translations.main.text_reset_password"
    ></v-title>
    <v-input
      :label="translations.main.text_username_or_email"
      ref="password-username"
      required
      :placeholder="translations.main.text_description_username_or_email"
      v-model="user.username"
    ></v-input>

    <v-submit
      :submitting="submit.password"
      :title="translations.main.action_send_email"
      icon="fas fa-envelope"
    ></v-submit>
    <div>
      <router-link to="/login">
        {{ translations.shared.action_go_to_login }}
      </router-link>
    </div>
  </b-form>
</template>
