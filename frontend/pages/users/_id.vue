<template>
  <v-container fluid>
    <v-row>
      <v-col cols="12">
        <v-card>
          <v-card-title class="d-flex flex-column justify-center">
            <v-avatar
              v-if="!($store.state.nodeEnv === 'production')"
              v-bind:class="[
                user.avatar.url === '/images/fallback/default.png'
                  ? 'grey lighten-2'
                  : 'blue-grey lighten-2',
              ]"
              size="128"
            >
              <v-img
                v-bind:src="`${$config.axios.browserBaseURL}` + user.avatar.url"
                max-height="90%"
                max-width="90%"
              ></v-img>
            </v-avatar>
            <v-card-text class="text-center">
              {{ user.name }}
            </v-card-text>
          </v-card-title>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
export default {
  asyncData: async function (context) {
    const response = await context.$axios.$get(
      `${context.$config.axios.browserBaseURL}/api/v1/users/${context.params.id}`
    )
    return {
      user: response.user,
    }
  },
}
</script>
