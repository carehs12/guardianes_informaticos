<script>
import deleteConfirmation from "./delete-confirmation.vue";

export default {
  components: { deleteConfirmation },
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
          key: "name",
          label: I18n.t("activerecord.attributes.service.name"),
          sortable: true,
        },
      ],
    };
  },

  methods: {
    showDeleteConfirmation(service) {
      this.$refs["delete-confirmation"].confirm(service);
    },

    onServiceDeleted(service) {
      this.$emit("service-deleted", service);
    },
  },
};
</script>
<template>
  <div>
    <delete-confirmation
      ref="delete-confirmation"
      @service-deleted="onServiceDeleted"
    ></delete-confirmation>
    <b-table
      small
      :fields="headers"
      :items="records"
      outlined
      thead-class="bg-primary"
    >
      <template v-slot:cell(name)="data">
        <router-link :to="`services/${data.item.id}/edit`">
          <text-highlight :queries="query">{{ data.value }}</text-highlight>
        </router-link>
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
