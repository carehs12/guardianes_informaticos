<script>
import vImage from "../../../../../components/form/v-image.vue";
import deleteConfirmation from "./delete-confirmation.vue";

export default {
  components: { vImage, deleteConfirmation },
  props: {
    records: {
      required: true,
    },

    pagination: {
      required: true,
    },
    query: {
      type: String,
      default: "",
    },
  },

  data() {
    return {
      headers: [
        {
          key: "profile_picture_src",
          label: I18n.t("activerecord.attributes.user.profile_picture"),
        },
        {
          key: "full_name",
          label: I18n.t("activerecord.attributes.user.full_name"),
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
        {
          key: "delete",
          label: "",
        },
      ],
    };
  },

  methods: {
    showDeleteConfirmation(user) {
      this.$refs["delete-confirmation"].confirm(user);
    },

    onUserDeleted(user){
      this.$emit('user-deleted', user)
    }
  },
};
</script>
<template>
  <div>
    <delete-confirmation ref="delete-confirmation" @user-deleted="onUserDeleted"></delete-confirmation>
    <b-table
      small
      :fields="headers"
      :items="records"
      outlined
      thead-class="bg-primary"
    >
      <template v-slot:cell(profile_picture_src)="data">
        <v-image :src="data.value" size="sm" align-to="left"> </v-image>
      </template>

      <template v-slot:cell(email)="data">
        <text-highlight :queries="query">{{ data.value }}</text-highlight>
      </template>

      <template v-slot:cell(full_name)="data">
        <router-link :to="`users/${data.item.id}/edit`">
          <text-highlight :queries="query">{{
            data.item.first_names
          }}</text-highlight>

          <text-highlight :queries="query">{{
            data.item.last_names
          }}</text-highlight>
        </router-link>
      </template>

      <template v-slot:cell(username)="data">
        <text-highlight :queries="query">{{ data.value }}</text-highlight>
      </template>

      <template v-slot:cell(delete)="data">
        <div class="text-right">
          <b-button
            variant="danger"
            size="sm"
            @click="showDeleteConfirmation(data.item)"
          >
            <i class="fas fa-trash-alt fa-sm"></i>
          </b-button>
        </div>
      </template>
    </b-table>
    <b-pagination
      v-model="pagination.current_page"
      :total-rows="pagination.total_records"
      :per-page="pagination.per_page"
      align="center"
    />
  </div>
</template>
