<script>
export default {
  props: {
    scheduleDate: {
      required: true,
    },
    dayAvailabilities: {
      required: true,
    },
    dayIndex: {
      required: true,
    },
  },

  data() {
    return {
      translations: {
        schedule: I18n.t("activerecord.attributes.schedule"),
      },
    };
  },

  methods: {
    weekdayDate(index) {
      let new_date = this.date.weekStart(this.scheduleDate);
      new_date.setDate(new_date.getDate() + index);

      return this.date.format(new_date);
    },

    isAnyoneAvailable(hour_index) {
      let is_available = false;
      for (let i = 0; i < this.dayAvailabilities.length; i++) {
        let availability_data = this.dayAvailabilities[i];
        if (availability_data.availability[hour_index]) {
          is_available = true;
          break;
        }
      }

      return is_available;
    },
  },
};
</script>
<template>
  <table
    class="table b-table table-striped table-sm"
    v-if="dayAvailabilities.length > 0"
  >
    <thead>
      <th
        :colspan="1 + (dayAvailabilities[0].availability || []).length"
        class="text-center"
      >
        {{ weekdayDate(dayIndex) }}
      </th>
    </thead>
    <tbody>
      <tr>
        <td class="text-center">
          <b>{{ translations.schedule.user }}</b>
        </td>
        <td
          class="text-center"
          v-for="(_available, hour_index) in (dayAvailabilities[0].availability || [])"
          :key="hour_index"
        >
          <span :class="isAnyoneAvailable(hour_index) ? 'text-success' : 'text-danger'" >
            <b
              >{{
                date.zeroPad(dayAvailabilities[0].start_at + hour_index)
              }}:00</b
            >
          </span>
        </td>
      </tr>
      <tr
        v-for="(availability_data, user_index) in dayAvailabilities"
        :key="user_index"
      >
        <td class="text-center">
          <small>{{ availability_data.user_name }}</small>
        </td>
        <td
          class="text-center"
          v-for="(_available, index) in availability_data.availability"
          :key="`${availability_data.user_id}-${index}`"
        >
          <input
            type="checkbox"
            v-model="availability_data.availability[index]"
          />
        </td>
      </tr>
    </tbody>
  </table>
</template>
