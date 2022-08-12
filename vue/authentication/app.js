// Vue base
import Vue from "vue";
import { BootstrapVue } from "bootstrap-vue";
import VueRouter from "vue-router";

// Plugins for Bus comunication and  HTTP requests
import pluginHttp from "../plugins/http";
import pluginBus from "../plugins/bus";

// Layout components
import componentLayoutFooter from "../components/layout/footer.vue";
import componentLayoutNotification from "../components/layout/notification.vue";

// Applications
import appSessionNew from "./apps/session/new.vue";
import appPasswordNew from "./apps/password/new.vue";
import appPasswordEdit from "./apps/password/edit.vue";

Vue.use(VueRouter);
Vue.use(pluginHttp);
Vue.use(pluginBus);
Vue.use(BootstrapVue);

var appRouter = new VueRouter({
  routes: [
    {
      path: "/",
      redirect: "/login",
    },
    {
      path: "/login",
      component: appSessionNew,
    },
    {
      path: "/password/new",
      component: appPasswordNew,
    },
    {
      path: "/password",
      redirect: "/password/new",
    },
    {
      path: "/password/edit",
      component: appPasswordEdit,
    },
  ],
});

// Mounting the vue app
let app = new Vue({
  router: appRouter,
  components: {
    "component-layout-notification": componentLayoutNotification,
    "component-layout-footer": componentLayoutFooter,
  },
});
app.$mount("#app");
