<script>
export default {
  props: {
    scheduleDate: {
      type: Date,
      required: true,
    },

    scheduleId: {
      required: true,
    },

    serviceName: {
      required: true,
    },
  },

  computed: {
    weekStart() {
      return this.date.format(this.date.weekStart(this.scheduleDate));
    },

    weekEnd() {
      return this.date.format(this.date.weekEnd(this.scheduleDate));
    },
  },
};
</script>
<template>
  <div>
    <h5 class="mb-0">
      <b v-if="scheduleId"
        >(T) Semana del {{ weekStart }} al {{ weekEnd }} - {{ serviceName }}</b
      >
      <b v-else>(T) No existe un horario para la semana seleccionada</b>
    </h5>
    <router-link v-if="scheduleId" :to="`/schedules/${scheduleId}/edit`">
      <i class="fas fa-edit"></i>
      {{ "(T) Editar" }}
    </router-link>
  </div>
</template>
