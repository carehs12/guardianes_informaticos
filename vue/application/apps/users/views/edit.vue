<script>
import componentForm from "../components/users/form.vue";
import layoutMain from "../../../layout/main.vue";
export default {
  components: { componentForm, layoutMain },
  data() {
    return {
      translations: {
        application: I18n.t("application"),
        users: I18n.t("apps.users"),
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
          <b>{{ translations.users.text_new_user }}</b>
        </h3>
        <router-link to="/users">
          <i class="fas fa-long-arrow-alt-left"></i>
          {{ translations.application.shared.text_back_to_index }}
        </router-link>
      </div>
    </div>
    <hr />
    <component-form class="mb-5" mode="edition" />
  </layout-main>
</template>
