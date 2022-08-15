<script>
export default {
  data(){
    return {
      translations: {
        schedules: I18n.t('apps.schedules')
      }
    }
  }
}
</script>
<template>
  <b-alert variant="warning" show>
    {{translations.schedules.notifications.new_schedule_warning}}
  </b-alert>
</template>
