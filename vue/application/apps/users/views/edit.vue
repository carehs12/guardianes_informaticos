<script>
import componentForm from "../components/users/form.vue";
export default {
  components: { componentForm },
  data() {
    return {
      translations: {
        application: I18n.t('application'),
        users: I18n.t('apps.users')
      },
    };
  },
};
</script>
<template>
  <div class="container-fluid">
    <div class="row mt-4 mb-5">
      <div class="col-12 px-4">
        <div class="row">
          <div class="col-12">
            <h3>
              <b>{{ translations.users.text_new_user }}</b>
            </h3>
            <router-link to="/users">
              <i class="fas fa-long-arrow-alt-left"></i>
              {{ translations.application.shared.text_back_to_index }}
            </router-link>
          </div>
        </div>
        <hr />
        <component-form class="mb-5" mode="edition" />
      </div>
    </div>
  </div>
</template>
