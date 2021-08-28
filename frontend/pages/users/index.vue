<template>
  <v-container>
    <v-row>
      <v-col class="mx-auto" cols="12" md="10" lg="8" xl="6">
        <v-card
          v-for="user in users"
          v-bind:key="user.id"
          class="my-4"
          elevation="4"
        >
          <div class="d-flex align-center">
            <v-card-title>
              <router-link v-bind:to="'/users/' + user.id" exact>
                <v-avatar
                  v-if="!(nodeEnv === 'production')"
                  v-bind:class="[
                    user.avatar.url === '/images/fallback/default.png'
                      ? 'grey lighten-2'
                      : 'blue-grey lighten-2',
                  ]"
                  size="64"
                >
                  <v-img
                    v-bind:src="$config.axios.browserBaseURL + user.avatar.url"
                    v-bind:style="
                      user.avatar.url === '/images/fallback/default.png'
                        ? { 'max-width': '90%', 'max-height': '90%' }
                        : ''
                    "
                  ></v-img>
                </v-avatar>
              </router-link>
            </v-card-title>
            <v-card-text class="pb-0">
              {{ user.name }}
            </v-card-text>
          </div>
        </v-card>
      </v-col>
    </v-row>
    <infinite-loading
      v-bind:distance="500"
      spinner="default"
      v-on:infinite="infiniteHandler"
    >
      <div slot="no-more" class="mt-5">これ以上結果がありません</div>
      <div slot="no-results" class="mt-5">結果がありません</div>
    </infinite-loading>
  </v-container>
</template>

<script>
import InfiniteLoading from 'vue-infinite-loading'

export default {
  components: {
    InfiniteLoading: InfiniteLoading,
  },
  middleware: async function (context) {
    try {
      await context.$axios.get('/api/v1/users')
    } catch (e) {
      context.redirect('/')
      if (e.response.statusText === 'Forbidden') {
        context.store.dispatch('message/flashMessage', {
          isAlert: true,
          alertType: 'error',
          alertMessage: e.response.data.message,
        })
      } else {
        context.store.dispatch('message/flashMessage', {
          isAlert: true,
          alertType: 'warning',
          alertMessage: 'サーバーとの通信にエラーが発生しています',
        })
      }
    }
  },
  asyncData: async function (context) {
    const response = await context.$axios.$get('/api/v1/users')
    return {
      fetchedUsers: response.users,
    }
  },
  data: function () {
    return {
      users: [],
    }
  },
  computed: {
    nodeEnv: function () {
      return this.$store.state.nodeEnv
    },
  },
  methods: {
    infiniteHandler: function ($state) {
      const that = this
      const topPosition = this.users.length
      let bottomPosition = this.users.length + 20

      if (this.fetchedUsers.length === this.users.length)
        return $state.complete()

      setTimeout(function () {
        if (that.fetchedUsers.length - bottomPosition > 0) {
          for (let i = topPosition; i < bottomPosition; i++) {
            that.users.push(that.fetchedUsers[i])
          }
          $state.loaded()
        } else {
          bottomPosition = that.fetchedUsers.length
          for (let i = topPosition; i < bottomPosition; i++) {
            that.users.push(that.fetchedUsers[i])
          }
          $state.loaded()
        }
      }, 1500)
    },
  },
}
</script>
