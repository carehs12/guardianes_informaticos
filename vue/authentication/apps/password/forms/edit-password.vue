<script>
import vSubmit from "../../../../components/form/v-submit.vue";
import vTitle from "../../../../components/form/v-title.vue";
import vInput from "../../../../components/form/v-input.vue";

export default {
  components: { vSubmit, vTitle, vInput },

  data() {
    return {
      user: {
        password: "",
        password_confirmation: "",
      },
      submit: {
        password: false,
      },
      passwords_dont_match: true,
      password_too_short: false,
    };
  },

  methods: {
    putPasswordHandler(event) {
      if (event) {
        event.preventDefault();
      }

      const url = "/password";
      const data = {
        user: {
          password: this.user.password,
          password_confirmation: this.user.password_confirmation,
          reset_password_token: this.$route.query.reset_password_token,
        },
      };

      this.http
        .put(url, data)
        .then((response) => {
          if (response.success) {
            this.putPasswordHandlerSuccess(response);
          } else {
            this.putPasswordHandlerError(response.error.message);
          }
        })
        .finally(() => {
          this.submit.password = false;
        });
    },

    putPasswordHandlerSuccess() {
      this.notify(
        "La contraseña ha sido cambiada exitosamente. En unos instantes ingresarás al sistema",
        "success"
      );

      setTimeout(() => {
        window.location.href = "/application";
      }, 3000);
    },

    putPasswordHandlerError(error_message) {
      this.notify(error_message, "danger");
      this.user.password = "";
      this.user.password_confirmation = "";
    },

    verifyPassword() {
      if (!this.verifyPasswordLength()) {
        return;
      }

      this.verifyPasswordsMatch();
    },

    verifyPasswordLength() {
      if (this.user.password && this.user.password.length < 6) {
        this.notify(
          "Por favor utiliza una contraseña de al menos 6 caracteres",
          "danger"
        );
        this.password_too_short = true;
        return false;
      }

      this.password_too_short = false;
      return true;
    },

    verifyPasswordsMatch() {
      if (this.user.password && this.user.password_confirmation) {
        if (this.user.password != this.user.password_confirmation) {
          this.notify("Las contraseñas ingresadas no coinciden", "danger");
          this.passwords_dont_match = true;
          return;
        }
      }
      this.passwords_dont_match = false;
    },
  },
};
</script>

<template>
  <b-form class="border p-3" @submit="putPasswordHandler">
    <v-title
      title="Guardianes Informáticos"
      subtitle="Cambiar Contraseña"
    ></v-title>
    <v-input
      label="Nueva Contraseña"
      required
      type="password"
      v-model="user.password"
      @change="verifyPassword"
      :className="{ 'is-invalid': passwords_dont_match || password_too_short }"
    ></v-input>
    <v-input
      label="Confirmar Contraseña"
      required
      type="password"
        v-model="user.password_confirmation"
        @change="verifyPassword"
        :className="{ 'is-invalid': passwords_dont_match }"
    ></v-input>
    <v-submit
      :disabled="password_too_short || passwords_dont_match"
      :submitting="submit.password"
      title="Cambiar Contraseña"
      icon="fas fa-lock"
    ></v-submit>
    <div>
      <router-link to="/login"> Iniciar Sesión </router-link>
    </div>
  </b-form>
</template>
