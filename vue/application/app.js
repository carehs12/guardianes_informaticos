// Vue base
import Vue from "vue";
import { BootstrapVue } from "bootstrap-vue";
import VueRouter from "vue-router";
import TextHighlight from 'vue-text-highlight';

// Plugins for Bus comunication and  HTTP requests
import pluginHttp from "../plugins/http";
import pluginBus from "../plugins/bus";

// Layout components
import componentLayoutFooter from "../components/layout/footer.vue";
import componentLayoutNotification from "../components/layout/notification.vue";
import componentLayoutNavbar from "../components/layout/navbar.vue";

// Application routes

import usersRoutes from './apps/users/routes.js'

Vue.use(VueRouter);
Vue.use(pluginHttp);
Vue.use(pluginBus);
Vue.use(BootstrapVue);
Vue.component('text-highlight', TextHighlight);

var appRouter = new VueRouter({
  routes: [].concat(usersRoutes)
});

// Mounting the vue app
let app = new Vue({
  router: appRouter,
  components: {
    "component-layout-navbar": componentLayoutNavbar,
    "component-layout-notification": componentLayoutNotification,
    "component-layout-footer": componentLayoutFooter,
  },
});
app.$mount("#app");
