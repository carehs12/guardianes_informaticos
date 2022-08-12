<script>
export default {
  props: {
    url: {
      type: String,
      required: true,
    },
    icon: {
      type: String,
      default: null,
    },
    title: {
      type: String,
      required: true,
    },
  },
};
</script>
<template>
  <b-nav-item :href="url">
    <i v-if="icon" :class="`fas fa-${icon}`"></i>
    {{ title }}
  </b-nav-item>
</template>
