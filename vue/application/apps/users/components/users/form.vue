<script>
import DatePicker from "v-calendar/lib/components/date-picker.umd";
import vSubmit from "../../../../../components/form/v-submit.vue";
import vInput from "../../../../../components/form/v-input.vue";
import vImage from "../../../../../components/form/v-image.vue";
import componentLoadingData from "../../../../../components/layout/loading-data.vue";
import imageUpload from "./image-upload.vue";
import messageNewUser from "./message-new-user.vue";

import formLayout from "../../../layouts/form.vue";
export default {
  components: {
    componentLoadingData,
    vSubmit,
    vInput,
    formLayout,
    vImage,
    DatePicker,
    imageUpload,
    messageNewUser,
  },

  props: {
    mode: {
      type: String,
      required: true,
    },
  },
  data() {
    return {
      translations: {
        application: I18n.t("application"),
        users: I18n.t("activerecord.attributes.user"),
        notifications: I18n.t("apps.users.notifications"),
      },
      user_id: null,
      user: null,
      submit: {
        user: false,
      },
    };
  },

  mounted() {
    this.setUserId();
    this.getUser();
  },
  methods: {
    setUserId() {
      this.user_id = this.$route.params.id;
    },

    getUser() {
      if (this.user_id) {
        let url = `/users/${this.user_id}.json`;
        this.http.get(url).then((response) => {
          if (response.success) {
            this.user = this.parseUser(response.data);
            this.focusOnName();
          } else {
            this.notify(response.error.message, "danger");
          }
        });
      } else {
        this.initializeUserStructure();
        this.focusOnName();
      }
    },

    parseUser(user) {
      if (user.detail_attributes.birth_date) {
        user.detail_attributes.birth_date = new Date(
          user.detail_attributes.birth_date
        );
      }
      return user;
    },

    initializeUserStructure() {
      this.user = {
        detail_attributes: {},
      };
    },

    submitUserHandler(event) {
      if (event) {
        event.preventDefault();
      }
      this.user.username = this.user.username.trim();
      if (this.user_id) {
        this.putUserHandler();
      } else {
        this.postUserHandler();
      }
    },

    postUserHandler() {
      let data = { user: this.user };
      this.submit.user = true;
      this.http.post("/users.json", data).then((response) => {
        this.submit.user = false;
        if (response.success) {
          this.notify(this.translations.notifications.created, "success");
          this.$router.push(`/users/${response.data.id}/edit`);
        } else {
          this.notify(response.error.message, "danger");
        }
      });
    },

    putUserHandler() {
      let url = `/users/${this.user_id}.json`;
      let data = { user: this.user };
      this.submit.user = true;

      this.http.put(url, data).then((response) => {
        this.submit.user = false;
        if (response.success) {
          this.notify(this.translations.notifications.updated, "success");
        } else {
          this.notify(response.error.message, "danger");
        }
      });
    },

    focusOnName() {
      this.$nextTick(() => {
        this.$refs["input-username"].focus();
      });
    },

    setProfilePicture(picture) {
      this.user.profile_picture_src = picture;
    },
  },
};
</script>
<template>
  <b-form @submit="submitUserHandler" v-if="user">
    <form-layout>
      <v-image
        v-if="user_id"
        :src="user.profile_picture_src"
        size="md"
      ></v-image>
      <message-new-user v-else></message-new-user>

      <image-upload
        v-if="user_id"
        :user-id="user_id"
        @on-image-modified="setProfilePicture"
      ></image-upload>

      <v-input
        :description="translations.application.shared.text_field_required"
        :label="translations.users.username"
        required
        ref="input-username"
        v-model="user.username"
      ></v-input>

      <v-input
        :description="translations.application.shared.text_field_required"
        :label="translations.users.email"
        required
        v-model="user.email"
      ></v-input>

      <v-input
        :description="translations.application.shared.text_field_required"
        :label="translations.users.first_names"
        required
        v-model="user.detail_attributes.first_names"
      ></v-input>

      <v-input
        :description="translations.application.shared.text_field_required"
        :label="translations.users.last_names"
        required
        v-model="user.detail_attributes.last_names"
      ></v-input>

      <b-form-group :label="translations.users.birth_date">
        <date-picker
          v-model="user.detail_attributes.birth_date"
          :locale="date.vcDatepickerConfig()"
          :popover="{ visibility: 'focus' }"
        >
          <template v-slot="{ inputValue, inputEvents }">
            <input
              class="form-control"
              v-on="inputEvents"
              :value="inputValue"
              placeholder="(T) Seleccionar Fecha"
            />
          </template>
        </date-picker>
      </b-form-group>

      <v-input
        :label="translations.users.personal_phone"
        v-model="user.detail_attributes.personal_phone"
      ></v-input>

      <v-input
        :label="translations.users.emergency_phone"
        v-model="user.detail_attributes.emergency_phone"
      ></v-input>

      <b-form-group :label="translations.users.address">
        <b-textarea v-model="user.detail_attributes.address" />
      </b-form-group>

      <b-form-group>
        <v-submit
          :submitting="submit.user"
          :title="translations.application.actions.users.save"
          icon="fa-save"
        >
        </v-submit>
      </b-form-group>
    </form-layout>
  </b-form>
  <component-loading-data v-else />
</template>
