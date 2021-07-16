<template>
  <v-container>
    <v-row>
      <v-col
        v-for="errorMessage in errorMessages"
        v-bind:key="errorMessage"
        class="mx-auto red lighten-4 grey--text text--darken-4 text-caption"
        cols="11"
      >
        {{ errorMessage }}
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
export default {
  props: {
    errorMessages: {
      type: Array,
      default: function () {
        return []
      },
    },
  },
}
</script>
