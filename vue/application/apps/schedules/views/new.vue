<script>
import formNew from "../forms/schedule/new.vue";
import layoutMain from "../../../layout/main.vue";
import layoutHeader from "../../../layout/header.vue";

export default {
  components: { formNew, layoutMain, layoutHeader },
  data() {
    return {
      translations: {
        application: I18n.t("application"),
        schedules: I18n.t("apps.schedules"),
      },
    };
  },
};
</script>
<template>
  <layout-main>
    <layout-header
      :title="translations.schedules.text_new_schedule"
      url="schedules"
    >
      <router-link to="/schedules/dashboard">
        <i class="fas fa-long-arrow-alt-left"></i>
        {{ translations.application.shared.text_back_to_index }}
      </router-link>
    </layout-header>
    <hr />
    <form-new class="mb-5" mode="creation" />
  </layout-main>
</template>
