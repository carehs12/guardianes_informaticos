<script>
export default {
  props: {
    value: {
      type: String,
      required: true,
    },
  },
  data() {
    return {
      translations: {
        shared: I18n.t("shared"),
        users: I18n.t("users"),
      },
      filter: "",
    };
  },
  watch: {
    filter() {
      this.$emit("input", this.filter);
    },
  },
};
</script>
<template>
  <div class="row mb-3">
    <div class="col-12 px-4">
      <h5>{{ translations.shared.general.search }}</h5>
    </div>
    <div class="col-12 px-4">
      <b-input
        class="border border-info"
        size="lg"
        :placeholder="translations.users.view.list.filters"
        v-model="filter"
      />
    </div>
  </div>
</template>
