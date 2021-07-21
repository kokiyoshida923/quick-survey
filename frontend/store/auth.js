export const state = () => ({
  isAuthenticated: null,
  authUser: {},
})

export const mutations = {
  setIsAuthenticated: function (state, isAuthenticated) {
    state.isAuthenticated = isAuthenticated
  },
  setAuthUser: function (state, authUser) {
    state.authUser = authUser
  },
}
