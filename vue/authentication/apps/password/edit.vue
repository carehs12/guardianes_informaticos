<script>
import formEditPassword from "./forms/edit-password.vue";
import layoutMain from "../../layout/main.vue";

export default {
  components: { formEditPassword, layoutMain },
};
</script>
<template>
  <layout-main>
    <form-edit-password></form-edit-password>
  </layout-main>
</template>
