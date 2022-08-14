<script>
export default {
  props: {
    workHours: {
      required: true,
    },
  },

  data() {
    return {
      fields: [
        { key: "full_name", label: "(T) Nombre" },
        { key: "work_hours", label: "(T) Horas Asignadas" },
      ],
    };
  },
};
</script>
<template>
  <div class="card">
    <div class="card-body">
      <div class="text-center">
        <h5><b>(T) Recuento de Horas</b></h5>
        <b-table small striped :items="workHours" :fields="fields"></b-table>
      </div>
    </div>
  </div>
</template>
