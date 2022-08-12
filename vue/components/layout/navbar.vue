<script>
import navbarItem from "./navbar/item.vue";

export default {
  components: { navbarItem },
  data() {
    return {
      translations: {
        application: I18n.t("application"),
      },
    };
  },
};
</script>
<template>
  <b-navbar toggleable="lg" type="dark" variant="primary">
    <b-navbar-brand href="/">{{translations.application.title}}</b-navbar-brand>

    <b-navbar-toggle target="nav-collapse"></b-navbar-toggle>

    <b-collapse id="nav-collapse" is-nav>
      <b-navbar-nav>
        <navbar-item
          url="/users"
          icon="user"
          :title="translations.application.apps.users"
        ></navbar-item>
        <navbar-item
          url="/horarios"
          icon="list"
          :title="translations.application.apps.schedules"
        ></navbar-item>
      </b-navbar-nav>

      <!-- Right aligned elements -->
      <b-navbar-nav class="ml-auto">
        <navbar-item
          url="/logout"
          icon="sign-out-alt"
          :title="translations.application.apps.logout"
        ></navbar-item>
      </b-navbar-nav>
    </b-collapse>
  </b-navbar>
</template>
