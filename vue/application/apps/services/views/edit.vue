<script>
import componentForm from "../components/services/form.vue";
import layoutMain from "../../../layout/main.vue";

export default {
  components: { componentForm, layoutMain },
  data() {
    return {
      translations: {
        application: I18n.t("application"),
        services: I18n.t("apps.services"),
      },
    };
  },
};
</script>
<template>
  <layout-main>
    <div class="row">
      <div class="col-12">
        <h3>
          <b>{{ translations.services.text_new_service }}</b>
        </h3>
        <router-link to="/services">
          <i class="fas fa-long-arrow-alt-left"></i>
          {{ translations.application.shared.text_back_to_index }}
        </router-link>
      </div>
    </div>
    <hr />
    <component-form class="mb-5" mode="edition" />
  </layout-main>
</template>
