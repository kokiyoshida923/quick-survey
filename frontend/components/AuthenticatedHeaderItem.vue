<template>
  <div class="d-flex justify-space-between align-center">
    <div>
      <v-card
        v-if="$vuetify.breakpoint.smAndDown"
        class="grey darken-4 mr-3"
        flat
      >
        <router-link to="/users" exact>
          <v-icon class="grey--text text--lighten-4">
            {{ authenticatedHeaderUsers.icon.mdiAccountBoxMultipleOutline }}
          </v-icon>
        </router-link>
      </v-card>
      <v-hover v-else v-slot="{ hover }">
        <v-card color="grey darken-4 mr-5" flat>
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
            to="/users"
            v-bind:style="hover ? { opacity: 0.8 } : {}"
            exact
          >
            全てのユーザーを見る
          </router-link>
        </v-card>
      </v-hover>
    </div>

    <v-card class="grey darken-4" flat>
      <v-menu
        v-if="Object.keys(authUser).length !== 0"
        style="z-index: 20"
        offset-y
      >
        <template v-slot:activator="{ on }">
          <v-hover v-slot="{ hover }">
            <v-avatar
              v-if="!(nodeEnv === 'production')"
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
          <v-list-item v-bind:to="'/users/' + authUser.id" exact>
            <v-list-item-icon>
              <v-icon>{{ authenticatedHeaderUser.icon.mdiAccount }}</v-icon>
            </v-list-item-icon>
            <v-list-item-content>
              <v-list-item-title>{{ authUser.name }}</v-list-item-title>
              <v-list-item-subtitle class="text-caption">
                自分のページへ移動
              </v-list-item-subtitle>
            </v-list-item-content>
          </v-list-item>
          <v-list-item v-bind:to="'/users/' + authUser.id + '/edit'" exact>
            <v-list-item-icon>
              <v-icon>
                {{ authenticatedHeaderUserEdit.icon.mdiAccountEdit }}
              </v-icon>
            </v-list-item-icon>
            <v-list-item-content>
              <v-list-item-title>アカウント設定</v-list-item-title>
            </v-list-item-content>
          </v-list-item>
          <v-list-item
            v-bind:to="'/users/' + authUser.id + '/edit/avatar'"
            exact
          >
            <v-list-item-icon>
              <v-icon>
                {{ authenticatedHeaderUserEditAvatar.icon.mdiImage }}
              </v-icon>
            </v-list-item-icon>
            <v-list-item-content>
              <v-list-item-title>アバター設定</v-list-item-title>
            </v-list-item-content>
          </v-list-item>
          <v-divider class="my-3"></v-divider>
          <v-list-item v-on:click="logoutUser()">
            <v-list-item-icon>
              <v-icon>{{ authenticatedHeaderLogout.icon.mdiLogout }}</v-icon>
            </v-list-item-icon>
            <v-list-item-content>
              <v-list-item-title>ログアウト</v-list-item-title>
            </v-list-item-content>
          </v-list-item>
        </v-list>
      </v-menu>
    </v-card>
  </div>
</template>

<script>
import {
  mdiAccount,
  mdiAccountBoxMultipleOutline,
  mdiAccountEdit,
  mdiImage,
  mdiLogout,
} from '@mdi/js'

export default {
  data: function () {
    return {
      authenticatedHeaderUsers: {
        icon: { mdiAccountBoxMultipleOutline: mdiAccountBoxMultipleOutline },
      },
      authenticatedHeaderUser: {
        icon: { mdiAccount: mdiAccount },
      },
      authenticatedHeaderUserEdit: {
        icon: { mdiAccountEdit: mdiAccountEdit },
      },
      authenticatedHeaderUserEditAvatar: {
        icon: { mdiImage: mdiImage },
      },
      authenticatedHeaderLogout: {
        icon: { mdiLogout: mdiLogout },
      },
    }
  },
  computed: {
    nodeEnv: function () {
      return this.$store.state.nodeEnv
    },
    authUser: function () {
      return this.$store.state.authentication.authUser
    },
  },
  methods: {
    logoutUser: async function () {
      try {
        await this.$axios.$delete('/api/v1/logout')
        this.destroyAuthentication()
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
    destroyAuthentication: function () {
      this.$store.commit('authentication/setIsAuthenticated', false)
      this.$store.commit('authentication/setAuthUser', {})
    },
  },
}
</script>

<style scoped>
.on-hover {
  opacity: 0.8;
}
</style>
