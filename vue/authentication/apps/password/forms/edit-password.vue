<script>
import vSubmit from "../../../../components/form/v-submit.vue";
import vTitle from "../../../../components/form/v-title.vue";

export default {
  components: { vSubmit, vTitle },

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
    <b-form-group label="Nueva Contraseña" label-for="reset-password-password">
      <b-form-input
        id="reset-password-password"
        type="password"
        ref="password"
        required
        v-model="user.password"
        @change="verifyPassword"
        :class="{ 'is-invalid': passwords_dont_match || password_too_short }"
      >
      </b-form-input>
    </b-form-group>
    <b-form-group
      label="Confirmar Contraseña"
      label-for="reset-password-password-confirmation"
    >
      <b-form-input
        type="password"
        id="reset-password-password-confirmation"
        ref="password-confirmation"
        required
        v-model="user.password_confirmation"
        @change="verifyPassword"
        :class="{ 'is-invalid': passwords_dont_match }"
      >
      </b-form-input>
    </b-form-group>
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

<style>
.form-group label {
  font-weight: bold;
  margin-bottom: 0px;
}
form {
  background-color: rgba(255, 255, 255, 0.8);
}
</style>
