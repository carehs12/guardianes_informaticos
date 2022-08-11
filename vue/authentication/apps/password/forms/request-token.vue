<script>
import vSubmit from "../../../../components/form/v-submit.vue";
import vTitle from "../../../../components/form/v-title.vue";
import vInput from "../../../../components/form/v-input.vue";

export default {
  components: { vSubmit, vTitle, vInput },
  data() {
    return {
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
      this.notify(
        `El correo con instrucciones ha sido enviado a ${response.data.email}`,
        "success"
      );
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
      title="Guardianes Informáticos"
      subtitle="Reinicio de Contraseña"
    ></v-title>
    <v-input
      label="Usuario o Correo Electrónico"
      ref="password-username"
      required
      placeholder="Nombre de usuario o correo asociado"
      v-model="user.username"
    ></v-input>

    <v-submit
      :submitting="submit.password"
      title="Enviar Correo con Instrucciones"
      icon="fas fa-envelope"
    ></v-submit>
    <div>
      <router-link to="/login"> Iniciar Sesión </router-link>
    </div>
  </b-form>
</template>
