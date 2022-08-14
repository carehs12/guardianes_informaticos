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

  data(){
    return {
      translations: {
        schedule: I18n.t("activerecord.attributes.schedule")
      }
    }
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
            <td class="text-center"><b>{{translations.schedule.hour}}</b></td>
            <td class="text-center"><b>{{translations.schedule.user}}</b></td>
          </tr>
          <tr
            v-for="(hour, index) in day.schedules"
            :key="`${day.id}-${index}`"
          >
            <td class="text-center">
              <b>
                <span :class="{ 'text-danger': !hour, 'text-success': hour}">
                  {{ date.zeroPad(day.start_at + index) }}:00
                </span>
              </b>
            </td>
            <td class="text-center">
              <span v-if="hour">
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
