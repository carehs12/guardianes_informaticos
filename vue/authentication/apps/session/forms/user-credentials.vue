<script>
import vSubmit from "../../../../components/form/v-submit.vue";
import vTitle from "../../../../components/form/v-title.vue";

export default {
  components: { vSubmit, vTitle },
  data() {
    return {
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
    <v-title title="Guardianes Informáticos" subtitle="Iniciar Sesión"></v-title>
    <b-form-group label="Usuario" label-for="session-username">
      <b-form-input
        id="session-username"
        required
        v-model="session.username"
        placeholder="Usuario"
      >
      </b-form-input>
    </b-form-group>
    <b-form-group label="Contraseña" label-for="session-password">
      <b-form-input
        id="session-password"
        required
        type="password"
        ref="input-password"
        v-model="session.password"
        placeholder="************"
      >
      </b-form-input>
    </b-form-group>
    <v-submit
      :submitting="submit.session"
      title="Iniciar Sesión"
      icon="fas fa-sign-in-alt"
    ></v-submit>
    <div>
      <router-link to="/password/new">
        ¿Olvidaste tu contraseña?
      </router-link>
    </div>
  </b-form>
</template>
