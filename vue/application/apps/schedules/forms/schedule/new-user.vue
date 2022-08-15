<script>
import vSubmit from "../../../../../components/form/v-submit.vue";
export default {
  components: { vSubmit },

  props: {
    submitting: {
      type: Boolean,
      default: false,
    },
  },

  data() {
    return {
      translations: {
        application: I18n.t("application"),
      },
      new_user_id: null,
      users: [],
    };
  },

  mounted() {
    this.getUsers();
  },

  methods: {
    getUsers() {
      let url = "/users.json?page=1&per_page=1000";
      this.http.get(url).then((response) => {
        if (response.success) {
          this.users = response.data.records;
        } else {
          this.notify(response.error.message, "danger");
        }
      });
    },

    addUserHandler(event) {
      if (event) {
        event.preventDefault();
      }

      this.$emit("add-user", this.new_user_id);
    },
  },
};
</script>
<template>
  <b-form @submit="addUserHandler">
    <b-form-select v-model="new_user_id" class="mb-2">
      <b-form-select-option
        v-for="user in users"
        :value="user.id"
        :key="user.id"
      >
        {{ user.first_names }}
        {{ user.last_names_names }}
      </b-form-select-option>
    </b-form-select>

    <v-submit
      class="mb-4"
      :disabled="!new_user_id"
      icon="fa-save"
      :submitting="submitting"
      :title="translations.application.actions.schedules.create_availability"
    >
    </v-submit>
  </b-form>
</template>
