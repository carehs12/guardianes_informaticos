// · Import apps and components
import schedulesEdit from "./views/edit.vue";
import schedulesShow from "./views/show.vue";

const routes = [
  {
    path: "/",
    redirect: "/schedules",
  },
  {
    path: "/schedules/",
    component: schedulesShow,
  },
  {
    path: "/schedules/:id/edit",
    component: schedulesEdit,
  },
];

export default routes;
