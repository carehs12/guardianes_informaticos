<script>
import vSubmit from "../../../components/form/v-submit.vue";
import vTitle from "../../../components/form/v-title.vue";

export default {
  components: { vSubmit, vTitle },
  data() {
    return {
      submit: {
        session: false,
      },
      user: {
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

      const data = { user: this.user };
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
        .catch((error) => {
          this.postSessionHandlerError(error);
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
    <b-form-group label="Usuario" label-for="login-username">
      <b-form-input
        id="login-username"
        required
        v-model="user.username"
        placeholder="Usuario"
      >
      </b-form-input>
    </b-form-group>
    <b-form-group label="Contraseña" label-for="login-password">
      <b-form-input
        id="login-password"
        required
        type="password"
        ref="input-password"
        v-model="user.password"
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
