<script>
export default {
  props: {
    src: {
      type: String,
      required: true,
    },
    size: {
      type: String,
      default: "md"
    }
  },
};
</script>
<template>
  <div class="text-center">
    <b-img
      :class="`img-profile size-${size}`"
      :src="src"
      :fluid="true"
      :thumbnail="true"
    >
    </b-img>
  </div>
</template>
