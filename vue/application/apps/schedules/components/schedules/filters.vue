<script>
export default {
  props: {
    value: {
      type: Object,
      default: null,
    },
  },

  data() {
    return {
      filters: {
        year: 2022,
        week: 1,
      },
    };
  },
};
</script>
<template>
  <div class="form-row mb-3">
    <div class="col-2">
      <h5>(T) Año</h5>
      <b-input class="border border-info" v-model="filters.year"> </b-input>
    </div>

    <div class="col-2">
      <h5>(T) Semana</h5>
      <b-input class="border border-info" v-model="filters.week"> </b-input>
    </div>
    <div class="col-12 mt-2">
      <b-button @click="$emit('submit-search')" block variant="primary">
        Buscar
      </b-button>
    </div>
  </div>
</template>
