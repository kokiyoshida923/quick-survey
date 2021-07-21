export default async function (context) {
  const response = await context.$axios.$get('/api/v1/verification')
  context.store.commit('auth/setIsAuthenticated', response.is_authenticated)
  if (response.auth_user) {
    context.store.commit('auth/setAuthUser', response.auth_user)
  }
}
