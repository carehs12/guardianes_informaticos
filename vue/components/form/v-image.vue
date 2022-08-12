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
    },
    alignTo: {
      type: String,
      default: "center"
    }
  },
};
</script>
<template>
  <div :class="`text-${alignTo}`">
    <b-img
      :class="`img-profile size-${size}`"
      :src="src"
      :fluid="true"
      :thumbnail="true"
    >
    </b-img>
  </div>
</template>
