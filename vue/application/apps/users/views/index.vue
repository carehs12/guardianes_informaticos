<script>
import layoutMain from "../../../layout/main.vue";
import layoutHeader from "../../../layout/header.vue";

import componentFilters from "../components/users/filters.vue";
import componentTable from "../components/users/table.vue";
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
      users: null,
      filters: "",
    };
  },

  mounted() {
    this.getUsers();
  },

  methods: {
    getUsers(filters) {
      let query = `?page=${this.pagination.current_page}&per_page=${this.pagination.per_page}`;
      if (filters) {
        query += `&query=${encodeURI(filters)}`;
      }
      let url = `/users.json${query}`;
      this.http.get(url, { filters: filters }).then((response) => {
        if (response.success) {
          this.pagination.total_records = response.data.total_records;
          this.users = response.data.records;
        } else {
          this.notify(response.error.message, "danger");
        }
      });
    },

    removeUser(user) {
      this.users = this.users.filter((e) => e.id != user.id);
    },
  },

  watch: {
    filters() {
      this.disable_pagination = true;
      this.pagination.current_page = 1;
      this.getUsers(this.filters);
      this.disable_pagination = false;
    },

    "pagination.current_page"() {
      if (!this.disable_pagination) {
        this.getUsers(this.filters);
      }
    },
  },
};
</script>

<template>
  <layout-main>
    <layout-header
      :title="translations.application.apps.users"
      :action-new="translations.application.actions.users.new"
      url="users"
    ></layout-header>
    <hr />
    <component-filters v-model="filters" />
    <component-table
      v-if="users"
      :records="users"
      :pagination="pagination"
      :query="filters"
      @user-deleted="removeUser"
    >
    </component-table>
    <component-loading-data v-else />
  </layout-main>
</template>
