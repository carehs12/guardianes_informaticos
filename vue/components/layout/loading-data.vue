<script>
export default {
  props: {
    size: {
      type: String,
      default: "large",
    },
  },
  computed: {
    iconSize() {
      switch (this.size) {
        case "large":
          return "fa-5x";
        case "medium":
          return "fa-3x";
        default:
          return "fa-3x";
      }
    },
  },
};
</script>
<template>
  <div class="row">
    <div class="col-12 text-center my-3">
      <i :class="`fas fa-circle-notch fa-spin ${iconSize} text-primary`"></i>
    </div>
  </div>
</template>
