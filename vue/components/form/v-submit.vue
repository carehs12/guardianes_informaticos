<script>
export default {
  props: {
    submitting: {
      type: Boolean,
      default: false
    },

    title: {
      type: String,
      required: true
    },

    icon: {
      type: String,
      default: null
    }
  }
}
</script>
<template>
  <b-button block variant="primary" class="mb-3" type="submit" :disabled="submitting">
    {{title}}
    <i v-if="submitting" class="fas fa-circle-notch fa-spin"></i>
    <i v-else-if="icon" :class="`fas ${icon}`"></i>
  </b-button>
</template>
