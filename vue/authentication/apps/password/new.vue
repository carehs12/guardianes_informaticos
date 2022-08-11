<script>
import formRequestToken from "./forms/request-token.vue";

export default {
  components: { formRequestToken }
};
</script>
<template>
  <section>
    <div class="container-fluid">
      <div class="row mt-5 pt-5 mb-5 pb-5">
        <div
          class="col-lg-4 offset-lg-4 col-md-6 offset-md-3 col-sm-8 offset-sm-2 col-12"
        >
          <form-request-token></form-request-token>
        </div>
      </div>
    </div>
  </section>
</template>
