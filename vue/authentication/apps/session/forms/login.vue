<script>
import vSubmit from "../../../../components/form/v-submit.vue";
import vTitle from "../../../../components/form/v-title.vue";
import vInput from "../../../../components/form/v-input.vue";

export default {
  components: { vSubmit, vTitle, vInput },
  data() {
    return {
      translations: {
        main: I18n.t("users.sessions.create"),
        application: I18n.t("application"),
        user: I18n.t("activerecord.attributes.user")
      },
      submit: {
        session: false,
      },
      session: {
        username: "",
        password: "",
      },
    };
  },

  methods: {
    postSessionHandler(event) {
      if (event) {
        event.preventDefault();
      }

      const data = { session: this.session };
      const url = "/login";
      this.submit.session = true;

      this.http
        .post(url, data)
        .then((response) => {
          if (response.success) {
            this.postSessionHandlerSuccess();
          } else {
            this.postSessionHandlerError(response.error.message);
          }
        })
        .finally(() => {
          this.submit.session = false;
        });
    },

    postSessionHandlerSuccess() {
      window.location.href = "/application";
    },

    postSessionHandlerError(error_message) {
      this.notify(error_message, "danger");
      this.$refs["input-password"].focus();
    },
  },
};
</script>

<template>
  <b-form class="border p-3" @submit="postSessionHandler">
    <v-title
      :title="translations.application.title"
      :subtitle="translations.main.text_login"
    ></v-title>
    <v-input
      :label="translations.user.username"
      required
      :placeholder="translations.user.username"
      v-model="session.username"
    ></v-input>
    <v-input
      :label="translations.user.password"
      type="password"
      ref="input-password"
      required
      v-model="session.password"
      placeholder="************"
    ></v-input>
    <v-submit
      :submitting="submit.session"
      :title="translations.main.text_login"
      icon="fas fa-sign-in-alt"
    ></v-submit>
    <div>
      <router-link to="/password/new">
        {{ translations.main.action_go_to_password_reset }}
      </router-link>
    </div>
  </b-form>
</template>
