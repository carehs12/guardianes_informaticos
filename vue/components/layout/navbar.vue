<script>
import navbarItem from "./navbar/item.vue";

export default {
  components: { navbarItem },
};
</script>
<template>
  <b-navbar toggleable="lg" type="dark" variant="primary">
    <b-navbar-brand href="/">{{
      "(T) Guardianes Informáticos"
    }}</b-navbar-brand>

    <b-navbar-toggle target="nav-collapse"></b-navbar-toggle>

    <b-collapse id="nav-collapse" is-nav>
      <b-navbar-nav>
        <navbar-item
          url="/users"
          icon="user"
          title="(T) Usuarios"
        ></navbar-item>
        <navbar-item
          url="/horarios"
          icon="list"
          title="(T) Horarios"
        ></navbar-item>
      </b-navbar-nav>

      <!-- Right aligned elements -->
      <b-navbar-nav class="ml-auto">
        <navbar-item
          url="/account"
          icon="user-cog"
          title="(T) Mi cuenta"
        ></navbar-item>
        <navbar-item
          url="/logout"
          icon="sign-out-alt"
          title="(T) Cerrar Sesión"
        ></navbar-item>
      </b-navbar-nav>
    </b-collapse>
  </b-navbar>
</template>
