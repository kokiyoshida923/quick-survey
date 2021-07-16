<template>
  <v-app>
    <v-app-bar class="grey darken-4" app>
      <v-row no-gutters>
        <v-col
          class="grey--text text--lighten-4 font-weight-bold"
          v-bind:class="[
            $vuetify.breakpoint.smAndDown
              ? 'text-subtitle-2'
              : 'text-subtitle-1',
          ]"
          cols="12"
        >
          quick survey
        </v-col>
      </v-row>
    </v-app-bar>
    <v-main>
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
