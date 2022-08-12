<script>
import componentFilters from "../components/users/filters.vue";
import componentLoadingData from "../../../../components/layout/loading-data.vue";
export default {
  components: { componentLoadingData, componentFilters },

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

      headers: [
        {
          key: "profile_picture_src",
          label: I18n.t("activerecord.attributes.user.profile_picture"),
        },
        {
          key: "full_name",
          label: I18n.t("activerecord.attributes.user.full_name"),
          sortable: true,
        },
        {
          key: "username",
          label: I18n.t("activerecord.attributes.user.username"),
          sortable: true,
        },
        {
          key: "email",
          label: I18n.t("activerecord.attributes.user.email"),
          sortable: true,
        },
        {
          key: "personal_phone",
          label: I18n.t("activerecord.attributes.user.personal_phone"),
        },
        {
          key: "address",
          label: I18n.t("activerecord.attributes.user.address"),
        },
      ],
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
      this.http
        .get(url, { filters: filters })
        .then((response) => {
          if (response.success) {
            this.pagination.total_records = response.data.total_records;
            this.users = response.data.records;
          } else {
            this.notify(response.error.message, "danger");
          }
        })
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
  <div class="container-fluid">
    <div class="row mt-4 mb-5">
      <div class="col-12 px-4">
        <div class="row">
          <div class="col-6">
            <h2>
              <b>{{ translations.application.apps.users }}</b>
            </h2>
          </div>
          <div class="col-6 text-right">
            <router-link to="/new" class="btn btn-primary mr-1">
              <i class="fas fa-plus-square"></i> &nbsp;
              {{ translations.application.actions.users.new }}
            </router-link>
          </div>
        </div>
        <hr />
        <component-filters v-model="filters" />
        <div v-if="users">
          <b-table
            small
            :fields="headers"
            :items="users"
            outlined
            thead-class="bg-primary"
          >
            <template v-slot:cell(profile_picture_src)="data">
              <b-img
                class="img-profile-picture"
                :src="data.value"
                :fluid="true"
                :thumbnail="true"
              >
              </b-img>
            </template>

            <template v-slot:cell(email)="data">
              <text-highlight :queries="filters">{{
                data.value
              }}</text-highlight>
            </template>

            <template v-slot:cell(full_name)="data">
              <router-link :to="`users/${data.item.id}`">
                <text-highlight :queries="filters">{{
                  data.item.first_names
                }}</text-highlight>

                <text-highlight :queries="filters">{{
                  data.item.last_names
                }}</text-highlight>
              </router-link>
            </template>

            <template v-slot:cell(username)="data">
              <text-highlight :queries="filters">{{
                data.value
              }}</text-highlight>
            </template>
          </b-table>
          <b-pagination
            v-model="pagination.current_page"
            :total-rows="pagination.total_records"
            :per-page="pagination.per_page"
            align="center"
          />
        </div>
        <component-loading-data v-else />
      </div>
    </div>
  </div>
</template>
