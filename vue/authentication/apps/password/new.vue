<script>
export default {
  data() {
    return {
      verification_enabled: false,
      user: {
        username: "",
      },
      loading: false,
    };
  },
  methods: {
    postPassword(event) {
      if (event) {
        event.preventDefault();
      }
      let url = "/password";
      let data = {
        user: this.user,
      };
      this.loading = true;
      this.http
        .post(url, data)
        .then((response) => {
          this.loading = false;
          if (response.successful) {
            this.notify(
              `El correo con instrucciones ha sido enviado a ${response.data.email}`,
              "success"
            );
          } else {
            this.notify(response.error.message, "danger");
          }
        })
        .catch((err) => {
          this.loading = false;
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
          <b-form class="border p-3" @submit="postPassword">
            <h3 class="text-center">Reinicia tu Contraseña</h3>
            <b-form-group
              label="Usuario o Correo Electrónico"
              label-for="login-username"
            >
              <b-form-input
                id="login-username"
                required
                placeholder="Nombre de usuario o correo asociado"
                v-model="user.username"
              >
              </b-form-input>
            </b-form-group>
            <b-button
              block
              variant="primary"
              class="mb-3"
              type="submit"
              v-if="loading"
              disabled
            >
              <i class="fas fa-circle-notch fa-spin"></i> Enviando correo
            </b-button>
            <b-button block variant="primary" class="mb-3" type="submit" v-else>
              Enviar Correo con Instrucciones
            </b-button>
            <div>
              <router-link to="/login"> Iniciar Sesión </router-link>
              <br />
              <router-link to="/verification" v-if="verification_enabled">
                ¿No recibiste correo de confirmacion?
              </router-link>
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
