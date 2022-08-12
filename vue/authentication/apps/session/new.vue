<script>
import formLogin from "./forms/login.vue";
import layoutMain from "../../layout/main.vue";

export default {
  components: { formLogin, layoutMain },
};
</script>
<template>
  <layout-main>
    <form-login></form-login>
  </layout-main>
</template>
