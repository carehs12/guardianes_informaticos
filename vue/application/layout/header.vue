<script>
export default {
  props: {
    title: {
      required: true
    },
    actionNew: {
      type: String,
      default: null
    },
    url: {
      required: true
    }
  }
};
</script>
<template>
  <div class="row">
    <div class="col-6">
      <h2>
        <b>{{ title }}</b>
      </h2>
      <slot></slot>
    </div>
    <div class="col-6 text-right">
      <router-link :to="`/${url}/new`" class="btn btn-primary mr-1" v-if="actionNew">
        <i class="fas fa-plus-square"></i> &nbsp;
        {{ actionNew }}
      </router-link>
    </div>
  </div>
</template>
