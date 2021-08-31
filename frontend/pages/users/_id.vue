<template>
  <v-container v-bind:fluid="isUsersShowPath($route.path) ? true : false">
    <v-row v-if="isUsersShowPath($route.path)">
      <v-col cols="12">
        <v-card>
          <v-card-title class="d-flex flex-column justify-center">
            <v-avatar
              v-if="!(nodeEnv === 'production')"
              v-bind:class="[
                user.avatar.url === '/images/fallback/default.png'
                  ? 'grey lighten-2'
                  : 'blue-grey lighten-2',
              ]"
              size="128"
            >
              <v-img
                v-bind:src="`${$config.axios.browserBaseURL}` + user.avatar.url"
                v-bind:style="
                  user.avatar.url === '/images/fallback/default.png'
                    ? { 'max-width': '90%', 'max-height': '90%' }
                    : ''
                "
              ></v-img>
            </v-avatar>
            <v-card-text class="text-center">
              {{ user.name }}
            </v-card-text>
          </v-card-title>
        </v-card>
      </v-col>
    </v-row>
    <NuxtChild v-on:assign-updated-user="assignUpdatedUser($event)" />
  </v-container>
</template>

<script>
export default {
  asyncData: async function (context) {
    const response = await context.$axios.$get(
      '/api/v1/users/' + context.params.id
    )
    return {
      user: response.user,
    }
  },
  computed: {
    nodeEnv: function () {
      return this.$store.state.nodeEnv
    },
  },
  methods: {
    assignUpdatedUser: function (updatedUser) {
      this.user = updatedUser
    },
    isUsersShowPath: function (path) {
      if (path === '/users/' + this.user.id) {
        return true
      } else {
        return false
      }
    },
  },
}
</script>
