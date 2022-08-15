<script>
import formNewUserVue from "./form-new-user.vue";
export default {
  components: {
    formNewUserVue,
  },

  props: {
    users: {
      required: true,
    },
    submitting: {
      type: Boolean,
      default: false
    }
  },

  data() {
    return {
      translations: {
        schedules: I18n.t("apps.schedules"),
      },
      fields: [
        {
          key: "full_name",
          label: I18n.t("apps.schedules.text_assigned_users"),
        },
        { key: "actions", label: "" },
      ],
    };
  },

  methods: {
    addUserHandler(user_id) {
      if (this.users.find((user) => user.id == user_id)) {
          this.notify(this.translations.schedules.notifications.user_already_assigned, "danger");
      } else {
        this.$emit('add-user', user_id)
      }
    },
  },
};
</script>
<template>
  <div class="card">
    <div class="card-body">
      <div class="text-center">
        <form-new-user-vue
          :users="users"
          :submitting="submitting"
          @add-user="addUserHandler"
        ></form-new-user-vue>
        <b-table small striped :items="users" :fields="fields"></b-table>
      </div>
    </div>
  </div>
</template>
