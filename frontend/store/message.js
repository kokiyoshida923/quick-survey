export const state = () => ({
  isAlert: false,
  alertType: null,
  alertMessage: null,
})

export const mutations = {
  toggleAlertBoolean: function (state, isAlert) {
    state.isAlert = isAlert
  },
  confirmAlertType: function (state, alertType) {
    state.alertType = alertType
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
