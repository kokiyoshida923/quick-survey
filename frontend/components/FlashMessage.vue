<template>
  <v-row no-gutters>
    <v-col class="mx-auto" cols="11">
      <transition name="fade">
        <v-alert
          v-if="isAlert"
          class="mt-1 text-caption font-weight-bold"
          v-bind:type="alertType"
          dense
        >
          {{ alertMessage }}
        </v-alert>
      </transition>
    </v-col>
  </v-row>
</template>

<script>
export default {
  computed: {
    isAlert: function () {
      return this.$store.state.message.isAlert
    },
    alertType: function () {
      return this.$store.state.message.alertType
    },
    alertMessage: function () {
      return this.$store.state.message.alertMessage
    },
  },
}
</script>

<style scoped>
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.5s;
}
.fade-enter,
.fade-leave-to {
  opacity: 0;
}
.fade-enter-to,
.fade-leave {
  opacity: 1;
}
</style>
