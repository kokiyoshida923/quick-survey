import {
  mdiCheckCircle,
  mdiAlertOctagonOutline,
  mdiAlertOutline,
} from '@mdi/js'

export const state = function () {
  return {
    isAlert: false,
    alertIcon: {},
    alertColor: null,
    alertMessage: null,
  }
}

export const mutations = {
  toggleAlertBoolean: function (state, isAlert) {
    state.isAlert = isAlert
  },
  confirmAlertType: function (state, alertType) {
    switch (alertType) {
      case 'success':
        state.alertIcon = { mdiCheckCircle: mdiCheckCircle }
        state.alertColor = 'green'
        break
      case 'error':
        state.alertIcon = { mdiAlertOctagonOutline: mdiAlertOctagonOutline }
        state.alertColor = 'red accent-2'
        break
      case 'warning':
        state.alertIcon = { mdiAlertOutline: mdiAlertOutline }
        state.alertColor = 'orange darken-1'
        break
      default:
    }
  },
  insertAlertMessage: function (state, alertMessage) {
    state.alertMessage = alertMessage
  },
}

export const actions = {
  flashMessage: function (context, { isAlert, alertType, alertMessage }) {
    const message = 'サーバーとの通信にエラーが発生しています'
    context.commit('toggleAlertBoolean', isAlert)
    context.commit('confirmAlertType', alertType)
    context.commit('insertAlertMessage', alertMessage)
    if (!(alertMessage === message)) {
      setTimeout(function () {
        context.commit('toggleAlertBoolean', !isAlert)
      }, 3000)
    }
  },
}
