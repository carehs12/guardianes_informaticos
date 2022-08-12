<script>
import vImage from "../../../../../components/form/v-image.vue";

export default {
  components: { vImage },
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
      ],
    };
  },
};
</script>
<template>
  <div>
    <b-table
      small
      :fields="headers"
      :items="records"
      outlined
      thead-class="bg-primary"
    >
      <template v-slot:cell(profile_picture_src)="data">
        <v-image
          :src="data.value"
          size="sm"
        >
        </v-image>
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
    </b-table>
    <b-pagination
      v-model="pagination.current_page"
      :total-rows="pagination.total_records"
      :per-page="pagination.per_page"
      align="center"
    />
  </div>
</template>
