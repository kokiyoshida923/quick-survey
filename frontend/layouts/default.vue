<template>
  <v-app>
    <v-app-bar class="grey darken-4" app>
      <v-row no-gutters>
        <v-col cols="12">
          <v-card
            class="d-flex justify-space-between align-center grey darken-4"
            flat
          >
            <div
              class="
                pa-0
                grey--text
                text--lighten-4
                font-weight-bold
                text-decoration-none
              "
              v-bind:class="[
                $vuetify.breakpoint.smAndDown
                  ? 'text-subtitle-2'
                  : 'text-subtitle-1',
              ]"
            >
              quick survey
            </div>
            <UnauthenticatedHeaderItem
              v-if="$store.state.auth.isAuthenticated === false"
            ></UnauthenticatedHeaderItem>
            <AuthenticatedHeaderItem v-else></AuthenticatedHeaderItem>
          </v-card>
        </v-col>
      </v-row>
    </v-app-bar>
    <v-main>
      <FlashMessage
        style="position: fixed; width: 100%; z-index: 10"
      ></FlashMessage>
      <nuxt />
    </v-main>
    <v-footer class="grey darken-4" app>
      <v-row no-gutters>
        <v-col
          class="grey--text text--lighten-4 font-weight-bold"
          v-bind:class="[
            $vuetify.breakpoint.smAndDown ? 'text-caption' : 'text-subtitle-2',
          ]"
          cols="12"
        >
          quick survey
        </v-col>
      </v-row>
    </v-footer>
  </v-app>
</template>
