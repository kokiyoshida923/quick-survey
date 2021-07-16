module.exports = {
  root: true,
  env: {
    browser: true,
    node: true,
  },
  parserOptions: {
    parser: 'babel-eslint',
  },
  extends: [
    '@nuxtjs',
    'plugin:prettier/recommended',
    'plugin:nuxt/recommended',
  ],
  plugins: [],
  // add your custom rules here
  rules: {
    'object-shorthand': ['error', 'never'],
    'vue/v-bind-style': ['error', 'longform'],
    'vue/v-on-style': ['error', 'longform'],
    'vue/v-slot-style': [
      'error',
      {
        named: 'longform',
      },
    ],
  },
}
