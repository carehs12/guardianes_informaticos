<script>
import formRequestToken from "./forms/request-token.vue";
import layoutMain from "../../layout/main.vue";

export default {
  components: { formRequestToken, layoutMain  }
};
</script>
<template>
  <layout-main>
      <form-request-token></form-request-token>
  </layout-main>
</template>
