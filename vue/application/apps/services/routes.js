// · Import apps and components
import servicesIndex from "./views/index.vue";
import servicesEdit from "./views/edit.vue";
import servicesNew from "./views/new.vue";

const routes = [
  {
    path: "/services",
    component: servicesIndex,
  },
  {
    path: "/services/new",
    component: servicesNew,
  },
  {
    path: "/services/:id/edit",
    component: servicesEdit,
  },
];

export default routes;
