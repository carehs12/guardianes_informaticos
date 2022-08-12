<script>
import ImageUploader from "vue-image-crop-upload";

export default {
  components: {
    ImageUploader,
  },

  props: {
    userId: {
      required: true,
    },
  },

  data() {
    return {
      translations: {
        application: I18n.t('application')
      },
      user: {
        profile_picture_src: null
      },
      show: false,
      headers: {
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
      },
    };
  },

  methods: {
    handleAvatar(dataURL, _field) {
      this.$emit('on-image-modified', dataURL);
    },

    onAvatarUpdate() {
      this.show = false;
      this.notify("Tu foto ha sido actualizada exitosamente", "success");
    },
  }
};
</script>
<template>
  <div class="form-row mt-2">
    <div class="col-md-6 offset-md-3 text-center">
      <image-uploader
        v-if="userId"
        field="user[profile_picture]"
        :headers="headers"
        method="PUT"
        :width="300"
        :height="300"
        :url="`/users/${userId}`"
        lang-type="es-MX"
        v-model="show"
        :no-circle="true"
        @crop-success="handleAvatar"
        @crop-upload-success="onAvatarUpdate"
      ></image-uploader>
      <b-button @click="show = !show" variant="primary">
        {{translations.application.actions.users.upload_profile_picture}}
      </b-button>
    </div>
  </div>
</template>
