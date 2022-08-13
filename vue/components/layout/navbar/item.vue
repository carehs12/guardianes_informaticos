<script>
export default {
  props: {
    url: {
      type: String,
      default: null,
    },
    to: {
      type: String,
      default: null,
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
  <b-nav-item :to="to" :href="url">
    <i v-if="icon" :class="`fas fa-${icon}`"></i>
    {{ title }}
  </b-nav-item>
</template>
