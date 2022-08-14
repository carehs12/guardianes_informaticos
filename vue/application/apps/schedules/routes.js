// · Import apps and components
import schedulesEdit from "./views/edit.vue";
import schedulesNew from "./views/new.vue";
import schedulesDashboard from "./views/dashboard.vue";

const routes = [
  {
    path: "/",
    redirect: "/schedules/dashboard",
  },
  {
    path: "/schedules/dashboard",
    component: schedulesDashboard,
  },
  {
    path: "/schedules/new",
    component: schedulesNew,
  },
  {
    path: "/schedules/:id/edit",
    component: schedulesEdit,
  },
];

export default routes;
