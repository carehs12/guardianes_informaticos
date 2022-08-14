<script>
export default {
  data(){
    return {
      translations: {
        services: I18n.t('apps.services')
      }
    }
  }
}
</script>
<template>
  <b-alert variant="warning" show>
    {{translations.services.notifications.new_service_warning}}
  </b-alert>
</template>
