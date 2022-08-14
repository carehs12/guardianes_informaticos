<script>
import vInput from "../../../../../components/form/v-input.vue";
import vDate from "../../../../../components/form/v-date.vue";
import vSubmit from "../../../../../components/form/v-submit.vue";

export default {
  components: { vInput, vDate, vSubmit },
  props: {
    value: {
      type: Object,
      default: null,
    },
  },

  data() {
    return {
      submit: {
        search: false,
      },
      filters: {
        year: null,
        week: null,
        date: null,
      },
    };
  },

  mounted() {
    this.filters = { ...this.value };
  },

  methods: {
    getScheduleHandler(event) {
      if (event) {
        event.preventDefault();
      }

      this.submit.search = true;

      this.$nextTick(() => {
        this.submit.search = false;
      });
    },
  },

  watch: {
    "value.date"() {
      if (this.value.date != this.filters.date) {
        this.filters.date = this.value.date;
      }
    },

    "value.year"() {
      if (this.value.year != this.filters.year) {
        this.filters.year = this.value.year;
      }
    },

    "value.week"() {
      if (this.value.week != this.filters.week) {
        this.filters.week = this.value.week;
      }
    },

    "filters.date"() {
      this.$emit("input", this.filters);
    },
  },
};
</script>
<template>
  <div class="card">
    <div class="card-body">
      <div class="text-center">
        <h5><b>(T) Buscar Horario</b></h5>
      </div>
      <b-form @submit="getScheduleHandler">
        <v-date v-model="filters.date" :label="'(T) Selecciona una Fecha'">
        </v-date>
        <v-input
          :label="'(T) Semana'"
          type="text"
          readonly
          :min="1"
          :max="53"
          v-model="filters.week"
        >
        </v-input>
        <v-input
          :label="'(T) Año'"
          type="text"
          readonly
          :min="0"
          v-model="filters.year"
        ></v-input>
        <v-submit
          :submitting="submit.search"
          :title="'(T) Buscar Horario'"
          icon="fa-search"
        ></v-submit
      ></b-form>
    </div>
  </div>
</template>
