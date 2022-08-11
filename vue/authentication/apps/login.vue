<script>
export default {
  data() {
    return {
      user: {
        username: "",
        password: "",
      },
      password_reset_enabled: true,
      verification_enabled: false,
    };
  },
  methods: {
    postSession(event) {
      if (event) {
        event.preventDefault();
      }

      let url = "/login";
      let data = {
        user: this.user,
      };
      this.http
        .post(url, data)
        .then((response) => {
          if (response.status == 200) {
            window.location.href = "/application";
          } else {
            this.notify(response.error.message, "danger");
            this.$refs["input-password"].focus();
          }
        })
        .catch((err) => {
          console.log(err);
        });
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
          <b-form class="border p-3" @submit="postSession">
            <h3 class="text-center">Iniciar Sesión</h3>
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
            <b-button block variant="primary" class="mb-3" type="submit">
              Iniciar Sesión
            </b-button>
            <div>
              <router-link to="/password/new" v-if="password_reset_enabled">
                ¿Olvidaste tu contraseña?
              </router-link>
            </div>
          </b-form>
        </div>
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
