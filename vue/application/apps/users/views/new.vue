<script>
import componentForm from "../components/users/form.vue";
import layoutMain from "../../../layout/main.vue";
import layoutHeader from "../../../layout/header.vue";

export default {
  components: { componentForm, layoutMain, layoutHeader },
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
    <layout-header
      :title="translations.users.text_new_user"
      url="users"
    >
      <router-link to="/users">
        <i class="fas fa-long-arrow-alt-left"></i>
        {{ translations.application.shared.text_back_to_index }}
      </router-link>
    </layout-header>
    <hr />
    <component-form class="mb-5" mode="creation" />
  </layout-main>
</template>
