<script>
export default {
  props: {
    workHours: {
      required: true,
    },
  },

  data() {
    return {
      translations: {
        schedules: I18n.t("apps.schedules")
      },
      fields: [
        { key: "full_name", label: I18n.t("activerecord.attributes.schedule.user") },
        { key: "work_hours", label: I18n.t("apps.schedules.text_assigned_hours") },
      ],
    };
  },
};
</script>
<template>
  <div class="card">
    <div class="card-body">
      <div class="text-center">
        <h5><b>{{translations.schedules.text_hours_count}}</b></h5>
        <b-table small striped :items="workHours" :fields="fields"></b-table>
      </div>
    </div>
  </div>
</template>
