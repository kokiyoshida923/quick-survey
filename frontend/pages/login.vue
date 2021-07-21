<template>
  <v-container>
    <v-row no-gutters>
      <v-col class="mx-auto" cols="12" sm="10" md="8" lg="6" xl="4">
        <v-card class="py-4" outlined>
          <v-card-title>
            <div
              class="mx-auto grey--text text--darken-4 text-h6 font-weight-bold"
            >
              quick surveyにログインする
            </div>
          </v-card-title>

          <v-divider class="mx-4 my-4"></v-divider>

          <ErrorMessages
            v-if="Object.keys(loginUserErrors).length !== 0"
            class="py-6"
            v-bind:error-messages="loginUserErrors"
          ></ErrorMessages>

          <v-card-text>
            <ValidationProvider
              v-slot="{ errors }"
              name="メールアドレス"
              rules="required|loginEmailAddress"
            >
              <v-text-field
                v-model="user.email"
                v-bind:class="[$vuetify.breakpoint.smAndDown ? 'my-3' : 'my-5']"
                v-bind:error-messages="errorHandler(errors, 'email')"
                label="メールアドレス"
                color="cyan darken-3"
                prepend-icon="mdi-email"
                v-on:focus="showEmailError = false"
                v-on:blur="showEmailError = true"
              ></v-text-field>
            </ValidationProvider>

            <ValidationProvider
              v-slot="{ errors }"
              name="パスワード"
              rules="required|loginPassword"
            >
              <v-text-field
                v-model="user.password"
                v-bind:class="[$vuetify.breakpoint.smAndDown ? 'my-3' : 'my-5']"
                v-bind:error-messages="errorHandler(errors, 'password')"
                v-bind:append-icon="
                  showLoginPassword ? 'mdi-eye' : 'mdi-eye-off'
                "
                v-bind:type="showLoginPassword ? 'text' : 'password'"
                label="パスワード"
                color="cyan darken-3"
                prepend-icon="mdi-lock"
                counter="32"
                v-on:focus="showPasswordError = false"
                v-on:blur="showPasswordError = true"
                v-on:click:append="showLoginPassword = !showLoginPassword"
              ></v-text-field>
            </ValidationProvider>

            <v-card-actions>
              <v-btn
                class="my-4 grey--text text--lighten-4 font-weight-bold"
                v-bind:loading="loading"
                v-bind:disabled="loading"
                v-bind:ripple="false"
                color="cyan darken-3"
                block
                depressed
                v-on:click="loginUser()"
              >
                ログインする
              </v-btn>
            </v-card-actions>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import { extend, localize, ValidationProvider } from 'vee-validate'
import ja from 'vee-validate/dist/locale/ja'
import { required } from 'vee-validate/dist/rules'
localize('ja', ja)

extend('required', {
  ...required,
  message: '{_field_}を入力してください',
})
extend('loginEmailAddress', function (value) {
  if (value.match(/^.{1,255}$/) === null) {
    return '{_field_}は255文字以内で入力してください'
  } else {
    return (
      /^[\w+\-.]+@[a-z\d\-.]+\.[a-z]+$/.test(value) ||
      '{_field_}は正しくありません'
    )
  }
})
extend('loginPassword', function (value) {
  return (
    /^[a-zA-Z0-9]{8,32}$/.test(value) ||
    '{_field_}は半角英数字で8~32文字で入力してください'
  )
})

export default {
  components: {
    ValidationProvider: ValidationProvider,
  },
  asyncData: async function (context) {
    const response = await context.$axios.$get('/api/v1/login')
    return {
      user: response.unauth_user,
    }
  },
  data: function () {
    return {
      loading: false,
      loader: null,
      showEmailError: false,
      showPasswordError: false,
      showLoginPassword: false,
      loginUserErrors: {},
    }
  },
  watch: {
    loader: function () {
      const l = this.loader
      this[l] = !this[l]

      const self = this
      setTimeout(function () {
        self[l] = false
      }, 1000)
      this.loader = null
    },
  },
  created: function () {
    this.loader = 'loading'
  },
  methods: {
    errorHandler: function (errors, label) {
      switch (label) {
        case 'email': {
          if (this.showEmailError === true) {
            return errors
          }
          break
        }
        case 'password': {
          if (this.showPasswordError === true) {
            return errors
          }
          break
        }
      }
    },
    loginUser: async function () {
      try {
        const response = await this.$axios.$post('/api/v1/login', {
          session: {
            email: this.user.email,
            password: this.user.password,
          },
        })
        if (response.auth_user) {
          this.$store.dispatch('message/flashMessage', {
            isAlert: true,
            alertType: 'success',
            alertMessage: 'ログインに成功しました',
          })
          this.$router.push('/users/' + response.auth_user.id)
        } else if (response.errors) {
          this.$store.dispatch('message/flashMessage', {
            isAlert: true,
            alertType: 'error',
            alertMessage: 'ログインに失敗しました',
          })
          this.loginUserErrors = response.errors
        }
      } catch (e) {
        this.$store.dispatch('message/flashMessage', {
          isAlert: true,
          alertType: 'warning',
          alertMessage: 'サーバーとの通信にエラーが発生しています',
        })
      }
    },
  },
}
</script>
