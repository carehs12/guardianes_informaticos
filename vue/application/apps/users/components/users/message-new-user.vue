<script>
export default {
  data(){
    return {
      translations: {
        users: I18n.t('apps.users')
      }
    }
  }
}
</script>
<template>
  <b-alert variant="warning" show>
    {{translations.users.notifications.new_user_warning}}
  </b-alert>
</template>
