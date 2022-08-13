<script>
import vSubmit from "../../../../../components/form/v-submit.vue";
import vInput from "../../../../../components/form/v-input.vue";
import componentLoadingData from "../../../../../components/layout/loading-data.vue";

import formLayout from "../../../layouts/form.vue";
export default {
  components: {
    componentLoadingData,
    vSubmit,
    vInput,
    formLayout,
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
        services: I18n.t("activerecord.attributes.service"),
        notifications: I18n.t("apps.services.notifications"),
      },
      service_id: null,
      service: null,
      submit: {
        service: false,
      },
    };
  },

  mounted() {
    this.setServiceId();
    this.getService();
  },
  methods: {
    setServiceId() {
      this.service_id = this.$route.params.id;
    },

    getService() {
      if (this.service_id) {
        let url = `/services/${this.service_id}.json`;
        this.http.get(url).then((response) => {
          if (response.success) {
            this.service = response.data;
            this.focusOnName();
          } else {
            this.notify(response.error.message, "danger");
          }
        });
      } else {
        this.initializeServiceStructure();
        this.focusOnName();
      }
    },

    initializeServiceStructure() {
      this.service = {
        name: ''
      };
    },

    submitServiceHandler(event) {
      if (event) {
        event.preventDefault();
      }
      if (this.service_id) {
        this.putServiceHandler();
      } else {
        this.postServiceHandler();
      }
    },

    postServiceHandler() {
      let data = { service: this.service };
      this.submit.service = true;
      this.http.post("/services.json", data).then((response) => {
        this.submit.service = false;
        if (response.success) {
          this.notify(this.translations.notifications.created, "success");
          this.$router.push(`/services/${response.data.id}/edit`);
        } else {
          this.notify(response.error.message, "danger");
        }
      });
    },

    putServiceHandler() {
      let url = `/services/${this.service_id}.json`;
      let data = { service: this.service };
      this.submit.service = true;

      this.http.put(url, data).then((response) => {
        this.submit.service = false;
        if (response.success) {
          this.notify(this.translations.notifications.updated, "success");
        } else {
          this.notify(response.error.message, "danger");
        }
      });
    },

    focusOnName() {
      this.$nextTick(() => {
        this.$refs["input-name"].focus();
      });
    },
  },
};
</script>
<template>
  <b-form @submit="submitServiceHandler" v-if="service">
    <form-layout>

      <v-input
        :description="translations.application.shared.text_field_required"
        :label="translations.services.name"
        required
        ref="input-name"
        v-model="service.name"
      ></v-input>

      <b-form-group>
        <v-submit
          :submitting="submit.service"
          :title="translations.application.actions.services.save"
          icon="fa-save"
        >
        </v-submit>
      </b-form-group>
    </form-layout>
  </b-form>
  <component-loading-data v-else />
</template>
