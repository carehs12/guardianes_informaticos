/*
@description Bus plugin for all components. Allows apps to 
  publish and subscribe to events, ragarding of parent/child hierarchy
*/
export default {
  install(Vue, _options) {
    // new vue instance as bus
    Vue.prototype.bus = new Vue();

    // Vue bus aliases
    Object.defineProperties(Vue.prototype.bus, {
      subscribe: {
        get() {
          return this.$on.bind(this);
        },
      },
      publish: {
        get() {
          return this.$emit.bind(this);
        },
      },
    });

    Vue.prototype.notify = (message, type) => {
      Vue.prototype.bus.publish("show:components/layout/notification", message, type);
    };
  },
};
