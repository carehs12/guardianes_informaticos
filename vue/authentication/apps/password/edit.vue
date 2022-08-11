<script>
export default {
  data() {
    return {
      user: {
        password: "",
        password_confirmation: "",
      },
      matching_passwords: true,
      password_too_short: false,
    };
  },
  methods: {
    putPassword(event) {
      if (event) {
        event.preventDefault();
      }
      let url = "/password";
      let data = {
        user: {
          password: this.user.password,
          password_confirmation: this.user.password_confirmation,
          reset_password_token: this.$route.query.reset_password_token,
        },
      };
      this.http
        .put(url, data)
        .then((response) => {
          if (response.successful) {
            this.notify(
              "La contraseña ha sido cambiada exitosamente. En unos instantes ingresarás al sistema",
              "success"
            );
            setTimeout(() => {
              window.location.href = "/dashboard";
            }, 3000);
          } else {
            this.notify(response.error.message, "danger");
            this.user.password = "";
            this.user.password_confirmation = "";
          }
        })
        .catch((err) => {
          console.log(err);
        });
    },
    verifyPassword() {
      if (this.user.password && this.user.password.length < 6) {
        this.notify(
          "Por favor utiliza una contraseña de al menos 6 caracteres",
          "danger"
        );
        this.password_too_short = true;
        return;
      }
      this.password_too_short = false;
      if (this.user.password && this.user.password_confirmation) {
        if (this.user.password != this.user.password_confirmation) {
          this.notify("Las contraseñas ingresadas no coinciden", "danger");
          this.matching_passwords = false;
          return;
        }
      }
      this.matching_passwords = true;
    },
  },
};
</script>
<template>
  <section>
    <div class="container-fluid">
      <div class="row mt-5 pt-5 mb-5 pb-5">
        <div
          class="col-lg-4 offset-lg-4 col-md-6 offset-md-3 col-sm-8 offset-sm-2 col-12"
        >
          <b-form class="border p-3" @submit="putPassword">
            <h3 class="text-center">Reinicio de Contraseña</h3>
            <b-form-group
              label="Nueva Contraseña"
              label-for="reset-password-password"
            >
              <b-form-input
                id="reset-password-password"
                type="password"
                ref="password"
                required
                v-model="user.password"
                @change="verifyPassword"
                :class="{
                  'is-invalid': !matching_passwords || password_too_short,
                }"
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
                :class="{ 'is-invalid': !matching_passwords }"
              >
              </b-form-input>
            </b-form-group>
            <b-button block variant="primary" class="mb-3" type="submit">
              Cambiar Contraseña
            </b-button>
            <div>
              <router-link to="/login"> Iniciar Sesión </router-link>
            </div>
          </b-form>
        </div>
      </div>
      <div class="footer bg-dark text-white text-center py-2">
        <span>
          2022 Vallejo Dental Group - Akari Intelligence &nbsp;
          <a href="/privacy_policy">Política de Privacidad</a>
        </span>
      </div>
    </div>
  </section>
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
