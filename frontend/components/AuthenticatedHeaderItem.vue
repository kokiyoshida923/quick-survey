<template>
  <v-card class="grey darken-4" flat>
    <v-menu
      v-if="Object.keys(authUser).length !== 0"
      style="z-index: 20"
      offset-y
    >
      <template v-slot:activator="{ on }">
        <v-hover v-slot="{ hover }">
          <v-avatar
            v-if="!($store.state.nodeEnv === 'production')"
            v-bind:class="[
              authUser.avatar.url === '/images/fallback/default.png'
                ? 'grey lighten-2'
                : 'blue-grey lighten-2',
              { 'on-hover': hover },
            ]"
            size="36"
            style="cursor: pointer"
            v-on="on"
          >
            <v-img
              v-bind:src="
                `${$config.axios.browserBaseURL}` + authUser.avatar.url
              "
              v-bind:style="
                authUser.avatar.url === '/images/fallback/default.png'
                  ? { 'max-width': '90%', 'max-height': '90%' }
                  : ''
              "
            ></v-img>
          </v-avatar>
        </v-hover>
      </template>
      <v-list class="mt-1" dense nav>
        <v-list-item
          v-for="authenticatedHeaderItemList in authenticatedHeaderItemLists"
          v-bind:key="authenticatedHeaderItemList.name"
          v-bind:to="authenticatedHeaderItemList.link"
          exact
        >
          <v-list-item-icon>
            <v-icon v-text="authenticatedHeaderItemList.icon"></v-icon>
          </v-list-item-icon>
          <v-list-item-content>
            <v-list-item-title
              v-text="authenticatedHeaderItemList.title"
            ></v-list-item-title>
            <v-list-item-subtitle
              class="text-caption"
              v-text="authenticatedHeaderItemList.subtitle"
            ></v-list-item-subtitle>
          </v-list-item-content>
        </v-list-item>
        <v-divider class="my-3"></v-divider>
        <v-list-item v-on:click="logoutUser()">
          <v-list-item-icon>
            <v-icon v-text="authenticatedHeaderLogout.icon"></v-icon>
          </v-list-item-icon>
          <v-list-item-content>
            <v-list-item-title
              v-text="authenticatedHeaderLogout.title"
            ></v-list-item-title>
          </v-list-item-content>
        </v-list-item>
      </v-list>
    </v-menu>
  </v-card>
</template>

<script>
export default {
  data: function () {
    return {
      authenticatedHeaderLogout: {
        title: 'ログアウト',
        icon: 'mdi-logout',
      },
    }
  },
  computed: {
    authUser: function () {
      return this.$store.state.auth.authUser
    },
    authenticatedHeaderItemLists: function () {
      return [
        {
          title: this.$store.state.auth.authUser.name,
          subtitle: '自分のページへ移動',
          link: '/users/' + this.$store.state.auth.authUser.id,
          icon: 'mdi-account',
        },
        {
          title: 'アカウント設定',
          link: '/users/' + this.$store.state.auth.authUser.id + '/edit',
          icon: 'mdi-account-edit',
        },
        {
          title: 'アバター設定',
          link: '/users/' + this.$store.state.auth.authUser.id + '/edit/avatar',
          icon: 'mdi-image',
        },
      ]
    },
  },
  methods: {
    logoutUser: async function () {
      try {
        await this.$axios.$delete('/api/v1/logout')
        this.$store.dispatch('message/flashMessage', {
          isAlert: true,
          alertType: 'success',
          alertMessage: 'ログアウトに成功しました',
        })
        this.$router.push('/')
      } catch (e) {
        this.$store.dispatch('message/flashMessage', {
          isAlert: true,
          alertType: 'warning',
          alertMessage: 'サーバーとの通信にエラーが発生しています',
        })
      }
    },
  },
}
</script>

<style scoped>
.on-hover {
  opacity: 0.8;
}
</style>
