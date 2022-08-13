<script>
import componentForm from "../components/services/form.vue";
import layoutMain from "../../../layout/main.vue";
import layoutHeader from "../../../layout/header.vue";

export default {
  components: { componentForm, layoutMain, layoutHeader },
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
    <layout-header
      :title="translations.services.text_edit_service"
      :action-new="translations.application.actions.services.new"
      url="services"
    >
      <router-link to="/services">
        <i class="fas fa-long-arrow-alt-left"></i>
        {{ translations.application.shared.text_back_to_index }}
      </router-link>
    </layout-header>
    <hr />
    <component-form class="mb-5" mode="edition" />
  </layout-main>
</template>
