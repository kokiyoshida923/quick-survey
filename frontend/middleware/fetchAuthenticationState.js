export default async function (context) {
  const response = await context.$axios.$get('/api/v1/verification')
  context.store.commit(
    'authentication/setIsAuthenticated',
    response.is_authenticated
  )
  if (response.auth_user) {
    context.store.commit('authentication/setAuthUser', response.auth_user)
  }
}
