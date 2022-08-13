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
        application: I18n.t("application"),
        services: I18n.t("apps.services")
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
      <h5>{{ translations.application.shared.search }}</h5>
    </div>
    <div class="col-12 px-4">
      <b-input
        class="border border-info"
        size="lg"
        :placeholder="translations.services.text_search_placeholder"
        v-model="filter"
      />
    </div>
  </div>
</template>
