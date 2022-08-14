<script>
import layoutMain from "../../../layout/main.vue";
import layoutHeader from "../../../layout/header.vue";

import componentFilters from "../components/schedules/filters.vue";

export default {
  components: {
    layoutMain,
    layoutHeader,
    componentFilters,
  },

  data() {
    return {
      translations: {
        application: I18n.t("application"),
      },
      filters: {
        year: 2022,
        week: 1,
      },
    };
  },
};
</script>
<template>
  <layout-main>
    <layout-header
      :title="translations.application.apps.schedules"
      :action-new="translations.application.actions.schedules.new"
      url="schedules"
    ></layout-header>
    <hr />
    <component-filters v-model="filters" />
  </layout-main>
</template>
