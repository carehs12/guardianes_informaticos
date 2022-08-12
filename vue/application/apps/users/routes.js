// · Import apps and components
import usersIndex from "./views/index.vue";
import usersEdit from "./views/edit.vue";
import usersShow from "./views/show.vue";
import usersNew from "./views/new.vue";

const routes = [
  {
    path: "/",
    redirect: "/users",
  },
  {
    path: "/users",
    component: usersIndex,
  },
  {
    path: "/users/new",
    component: usersNew,
  },
  {
    path: "/users/:id",
    component: usersShow,
  },
  {
    path: "/users/:id/edit",
    component: usersEdit,
  },
];

export default routes;
