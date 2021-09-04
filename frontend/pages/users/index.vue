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
            <v-card-text class="text-left pb-0">
              {{ user.name }}
            </v-card-text>
          </div>
        </v-card>
        <div v-infinite-scroll="infiniteHandler"></div>
        <template v-if="loadingFlag">
          <v-progress-circular
            class="text-center"
            color="grey darken-1"
            indeterminate
            size="25"
            width="3"
          ></v-progress-circular>
        </template>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
export default {
  directives: {
    'infinite-scroll': {
      inserted: function (el, binding) {
        const f = function (event) {
          if (binding.value(event, el)) {
            window.removeEventListener('scroll', f)
          }
        }
        window.addEventListener('scroll', f)
      },
    },
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
      start: 0,
      end: 20,
      bottomPoint: null,
      loadingFlag: false,
    }
  },
  computed: {
    nodeEnv: function () {
      return this.$store.state.nodeEnv
    },
  },
  mounted: function () {
    this.getUsers().then(() => {
      const bodyHeight = document.body.clientHeight
      const windowHeight = window.innerHeight
      this.bottomPoint = bodyHeight - windowHeight
    })
  },
  methods: {
    infiniteHandler: function (event, el) {
      if (this.end === this.fetchedUsers.length) return true

      if (window.pageYOffset === this.bottomPoint) {
        this.getUsers().then(() => {
          const bodyHeight = document.body.clientHeight
          const windowHeight = window.innerHeight
          this.bottomPoint = bodyHeight - windowHeight
        })
      }
    },
    getUsers: function () {
      return new Promise((resolve) => {
        this.loadingFlag = true

        setTimeout(() => {
          if (this.fetchedUsers.length - this.end > 0) {
            for (let i = this.start; i < this.end; i++) {
              this.users.push(this.fetchedUsers[i])
            }
            this.start = this.start + 20
            this.end = this.end + 20
            resolve()
          } else {
            this.end = this.fetchedUsers.length
            for (let i = this.start; i < this.end; i++) {
              this.users.push(this.fetchedUsers[i])
            }
            resolve()
          }
          this.loadingFlag = false
        }, 1500)
      })
    },
  },
}
</script>
