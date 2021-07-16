<template>
  <v-hover v-slot="{ hover }">
    <v-card
      v-bind:class="{ 'on-hover': hover }"
      color="grey lighten-4"
      outlined
    >
      <router-link
        class="
          d-block
          py-1
          grey
          darken-4
          grey--text
          text--lighten-4 text-caption
          font-weight-bold
          text-decoration-none
        "
        v-bind:class="[$vuetify.breakpoint.smAndDown ? 'px-1' : 'px-3']"
        v-bind:to="unauthenticatedHeaderItemLists[0].link"
        exact
      >
        {{ unauthenticatedHeaderItemLists[0].name }}
      </router-link>
    </v-card>
  </v-hover>
</template>

<script>
export default {
  data: function () {
    return {
      unauthenticatedHeaderItemLists: [{ name: '新規登録', link: '/signup' }],
    }
  },
}
</script>

<style scoped>
.on-hover {
  opacity: 0.8;
}
</style>
