<script>
import layoutMain from "../../../layout/main.vue";
import layoutHeader from "../../../layout/header.vue";

import componentFilters from "../components/services/filters.vue";
import componentTable from "../components/services/table.vue";
import componentLoadingData from "../../../../components/layout/loading-data.vue";
export default {
  components: {
    layoutMain,
    layoutHeader,
    componentLoadingData,
    componentFilters,
    componentTable,
  },

  data() {
    return {
      translations: {
        application: I18n.t("application"),
      },

      pagination: {
        current_page: 1,
        per_page: 6,
        total_records: 0,
      },

      disable_pagination: false,
      services: null,
      filters: "",
    };
  },

  mounted() {
    this.getServices();
  },

  methods: {
    getServices(filters) {
      let query = `?page=${this.pagination.current_page}&per_page=${this.pagination.per_page}`;
      if (filters) {
        query += `&query=${encodeURI(filters)}`;
      }
      let url = `/services.json${query}`;
      this.http.get(url, { filters: filters }).then((response) => {
        if (response.success) {
          this.pagination.total_records = response.data.total_records;
          this.services = response.data.records;
        } else {
          this.notify(response.error.message, "danger");
        }
      });
    },

    removeService(service) {
      this.services = this.services.filter((e) => e.id != service.id);
    },
  },

  watch: {
    filters() {
      this.disable_pagination = true;
      this.pagination.current_page = 1;
      this.getServices(this.filters);
      this.disable_pagination = false;
    },

    "pagination.current_page"() {
      if (!this.disable_pagination) {
        this.getServices(this.filters);
      }
    },
  },
};
</script>

<template>
  <layout-main>
    <layout-header
      :title="translations.application.apps.services"
      :action-new="translations.application.actions.services.new"
      url="services"
    ></layout-header>
    <hr />
    <component-filters v-model="filters" />
    <component-table
      v-if="services"
      :records="services"
      :pagination="pagination"
      :query="filters"
      @service-deleted="removeService"
    >
    </component-table>
    <component-loading-data v-else />
  </layout-main>
</template>
