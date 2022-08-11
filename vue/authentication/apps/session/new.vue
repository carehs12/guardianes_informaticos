<script>
import formUserCredetials from "./forms/user-credentials.vue";
import layoutMain from "../../layout/main.vue";

export default {
  components: { formUserCredetials, layoutMain },
};
</script>
<template>
  <layout-main>
    <form-user-credetials></form-user-credetials>
  </layout-main>
</template>
