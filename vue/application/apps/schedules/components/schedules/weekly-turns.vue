<script>
export default {
  props: {
    scheduleDate: {
      required: true,
    },
    scheduleResults: {
      required: true,
    },
  },

  methods: {
    weekdayDate(index) {
      let new_date = this.date.weekStart(this.scheduleDate);
      new_date.setDate(new_date.getDate() + index);

      return this.date.format(new_date);
    },
  },
};
</script>
<template>
  <div class="row">
    <div
      v-for="(day, day_index) in scheduleResults"
      class="col-4"
      :key="day.id"
    >
      <table class="table b-table table-striped table-sm">
        <thead>
          <th colspan="2" class="text-center">{{ weekdayDate(day_index) }}</th>
        </thead>
        <tbody>
          <tr>
            <td class="text-center"><b>(T) Hora</b></td>
            <td class="text-center"><b>(T) Encargado</b></td>
          </tr>
          <tr
            v-for="(hour, index) in day.schedules"
            :key="`${day.id}-${index}`"
          >
            <td class="text-center">
              <b>
                <span :class="{ 'text-danger': !hour.user, 'text-success': hour.user}">
                  {{ date.zeroPad(day.start_at + index) }}:00
                </span>
              </b>
            </td>
            <td class="text-center">
              <span v-if="hour.user">
                {{ hour.user }}
              </span>
              <span v-else>
                <i class="fas fa-exclamation-triangle text-warning"></i>
              </span>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>
