<script>
import formNewUser from "../../forms/schedule/new-user.vue";
import deleteAvailability from "./delete-availability.vue";
import DeleteAvailability from "./delete-availability.vue";

export default {
  components: {
    formNewUser,
    deleteAvailability,
    DeleteAvailability,
  },

  props: {
    scheduleId: {
      required: true,
    },

    users: {
      required: true,
    },

    submitting: {
      type: Boolean,
      default: false,
    },
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
        this.notify(
          this.translations.schedules.notifications.user_already_assigned,
          "danger"
        );
      } else {
        this.$emit("add-user", user_id);
      }
    },

    confirmDeletion(user) {
      this.$refs["confirm-delete"].confirm(user);
    },

    userDeleted() {
      this.$emit("user-deleted");
    },
  },
};
</script>
<template>
  <div class="card">
    <div class="card-body">
      <delete-availability
        @user-deleted="userDeleted"
        ref="confirm-delete"
        :schedule-id="scheduleId"
      ></delete-availability>
      <div class="text-center">
        <form-new-user
          :users="users"
          :submitting="submitting"
          @add-user="addUserHandler"
        ></form-new-user>
        <b-table small striped :items="users" :fields="fields">
          <template #cell(actions)="data">
            <div class="text-right">
              <b-button
                size="sm"
                variant="danger"
                @click="confirmDeletion(data.item)"
              >
                <i class="fas fa-trash-alt fa-sm"></i>
              </b-button>
            </div>
          </template>
        </b-table>
      </div>
    </div>
  </div>
</template>
