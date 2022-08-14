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

  data(){
    return {
      translations: {
        application: I18n.t("application"),
        schedules: I18n.t("apps.schedules")
      },
    }
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
  <div  class="mb-3">
    <h5 class="mb-0">
      <b>
        {{translations.application.shared.text_week_range}} {{ weekStart }} - {{ weekEnd }} - {{ serviceName }}
      </b>
    </h5>
    <router-link v-if="scheduleId" :to="`/schedules/${scheduleId}/edit`">
      <i class="fas fa-edit"></i>
      {{ translations.schedules.text_edit_schedule }}
    </router-link>
  </div>
</template>
