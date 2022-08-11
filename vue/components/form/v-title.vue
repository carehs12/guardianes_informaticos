<script>
export default {
  props: {

    title: {
      type: String,
      required: true
    },

    subtitle: {
      type: String,
      default: null
    }
  }
}
</script>
<template>
  <div>
    <h3 class="text-center">{{title}}</h3>
    <h5 class="text-center" v-if="subtitle">{{subtitle}}</h5>
  </div>
</template>


    