<script>
export default {
  data() {
    return {
      type: "info",
      message: "",
      dismissSecs: 10,
      dismissCountDown: 0,
      showDismissibleAlert: false,
    };
  },
  mounted() {
    this.setSubscriptions();
  },
  methods: {
    setSubscriptions() {
      this.bus.subscribe("show:components/layout/notification", (message, type) => {
        this.message = message;
        this.type = type;
        this.dismissCountDown = this.dismissSecs;
      });
    },
    countDownChanged(dismissCountDown) {
      this.dismissCountDown = dismissCountDown;
    },
  },
};
</script>
<template>
  <section class="notification">
    <b-alert
      :show="dismissCountDown"
      dismissible
      fade
      :variant="type"
      @dismiss-count-down="countDownChanged"
    >
      {{ `${message}  (${dismissCountDown})` }}
    </b-alert>
  </section>
</template>
<style scoped>
.notification {
  position: fixed;
  right: 0;
  bottom: 0;
  z-index: 100;
}
.notification .alert {
  margin-bottom: 3.5rem;
  margin-right: 1.5rem;
}
</style>
