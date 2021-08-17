<template>
  <v-container>
    <v-row no-gutters>
      <v-col class="mx-auto" cols="12" sm="10" md="8" lg="6" xl="4">
        <v-card class="py-4" outlined>
          <v-card-title>
            <div
              class="mx-auto grey--text text--darken-4 text-h6 font-weight-bold"
            >
              quick surveyに登録する
            </div>
          </v-card-title>

          <v-divider class="mx-4 my-4"></v-divider>

          <ErrorMessages
            v-if="Object.keys(signupUserErrors).length !== 0"
            class="py-6"
            v-bind:error-messages="signupUserErrors"
          ></ErrorMessages>

          <v-card-text>
            <ValidationProvider
              v-slot="{ errors }"
              name="ユーザー名"
              rules="required|userName"
            >
              <v-text-field
                v-model="user.name"
                v-bind:class="[$vuetify.breakpoint.smAndDown ? 'my-3' : 'my-5']"
                v-bind:error-messages="errorHandler(errors, 'name')"
                v-bind:prepend-icon="signupIcon.name.mdiAccountCircle"
                label="ユーザー名"
                color="cyan darken-3"
                counter="20"
                v-on:focus="showNameError = false"
                v-on:blur="showNameError = true"
              ></v-text-field>
            </ValidationProvider>

            <ValidationProvider
              v-slot="{ errors }"
              name="メールアドレス"
              rules="required|userMailAddress"
            >
              <v-text-field
                v-model="user.email"
                v-bind:class="[$vuetify.breakpoint.smAndDown ? 'my-3' : 'my-5']"
                v-bind:error-messages="errorHandler(errors, 'email')"
                v-bind:prepend-icon="signupIcon.email.mdiEmail"
                label="メールアドレス"
                color="cyan darken-3"
                v-on:focus="showEmailError = false"
                v-on:blur="showEmailError = true"
              ></v-text-field>
            </ValidationProvider>

            <ValidationObserver>
              <ValidationProvider
                v-slot="{ errors }"
                name="パスワード"
                rules="required|userPassword|confirmed:@passwordConfirmation"
              >
                <v-text-field
                  v-model="user.password"
                  v-bind:class="[
                    $vuetify.breakpoint.smAndDown ? 'my-3' : 'my-5',
                  ]"
                  v-bind:error-messages="errorHandler(errors, 'password')"
                  v-bind:append-icon="
                    showUserPassword
                      ? signupIcon.eye.mdiEye
                      : signupIcon.eyeOff.mdiEyeOff
                  "
                  v-bind:type="showUserPassword ? 'text' : 'password'"
                  v-bind:prepend-icon="signupIcon.password.mdiLock"
                  label="パスワード"
                  color="cyan darken-3"
                  counter="32"
                  v-on:focus="showPasswordError = false"
                  v-on:blur="showPasswordError = true"
                  v-on:click:append="showUserPassword = !showUserPassword"
                ></v-text-field>
              </ValidationProvider>

              <ValidationProvider
                v-slot="{ errors }"
                name="パスワード(確認用)"
                rules="required"
                vid="passwordConfirmation"
              >
                <v-text-field
                  v-model="user.password_confirmation"
                  v-bind:class="[
                    $vuetify.breakpoint.smAndDown ? 'my-3' : 'my-5',
                  ]"
                  v-bind:error-messages="
                    errorHandler(errors, 'passwordConfirmation')
                  "
                  v-bind:append-icon="
                    showUserPasswordConfirmation
                      ? signupIcon.eye.mdiEye
                      : signupIcon.eyeOff.mdiEyeOff
                  "
                  v-bind:type="
                    showUserPasswordConfirmation ? 'text' : 'password'
                  "
                  label="パスワード(確認用)"
                  color="cyan darken-3"
                  v-bind:prepend-icon="
                    signupIcon.password_confirmation.mdiLockCheck
                  "
                  v-on:focus="showPasswordConfirmationError = false"
                  v-on:blur="showPasswordConfirmationError = true"
                  v-on:click:append="
                    showUserPasswordConfirmation = !showUserPasswordConfirmation
                  "
                ></v-text-field>
              </ValidationProvider>
            </ValidationObserver>

            <v-card-actions>
              <v-btn
                class="my-4 grey--text text--lighten-4 font-weight-bold"
                v-bind:loading="loading"
                v-bind:disabled="loading"
                v-bind:ripple="false"
                color="cyan darken-3"
                block
                depressed
                v-on:click="signupUser()"
              >
                登録する
              </v-btn>
            </v-card-actions>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import {
  mdiAccountCircle,
  mdiEmail,
  mdiLock,
  mdiLockCheck,
  mdiEye,
  mdiEyeOff,
} from '@mdi/js'

import {
  extend,
  localize,
  ValidationObserver,
  ValidationProvider,
} from 'vee-validate'
import ja from 'vee-validate/dist/locale/ja'
import { required } from 'vee-validate/dist/rules'
localize('ja', ja)

extend('required', {
  ...required,
  message: '{_field_}を入力してください',
})
extend('userName', function (value) {
  return /^.{6,20}$/.test(value) || '{_field_}はで6~20文字で入力してください'
})
extend('userMailAddress', function (value) {
  if (value.match(/^.{1,255}$/) === null) {
    return '{_field_}は255文字以内で入力してください'
  } else {
    return (
      /^[\w+\-.]+@[a-z\d\-.]+\.[a-z]+$/.test(value) ||
      '{_field_}は正しくありません'
    )
  }
})
extend('userPassword', function (value) {
  return (
    /^[a-zA-Z0-9]{8,32}$/.test(value) ||
    '{_field_}は半角英数字で8~32文字で入力してください'
  )
})
extend('confirmed', {
  params: ['target'],
  validate: function (value, args) {
    return value === args.target
  },
  message: 'パスワードとパスワード(確認用)が一致しません',
})

export default {
  components: {
    ValidationObserver: ValidationObserver,
    ValidationProvider: ValidationProvider,
  },
  asyncData: async function (context) {
    const response = await context.$axios.$get('/api/v1/signup')
    return {
      user: response.user,
    }
  },
  data: function () {
    return {
      signupIcon: {
        name: { mdiAccountCircle: mdiAccountCircle },
        email: { mdiEmail: mdiEmail },
        password: { mdiLock: mdiLock },
        password_confirmation: { mdiLockCheck: mdiLockCheck },
        eye: { madEye: mdiEye },
        eyeOff: { mdiEyeOff: mdiEyeOff },
      },
      loading: false,
      loader: null,
      showNameError: false,
      showEmailError: false,
      showPasswordError: false,
      showPasswordConfirmationError: false,
      showUserPassword: false,
      showUserPasswordConfirmation: false,
      signupUserErrors: {},
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
        case 'name': {
          if (this.showNameError === true) {
            return errors
          }
          break
        }
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
        case 'passwordConfirmation': {
          if (this.showPasswordConfirmationError === true) {
            return errors
          }
          break
        }
      }
    },
    signupUser: async function () {
      try {
        const response = await this.$axios.$post('/api/v1/signup', {
          user: {
            name: this.user.name,
            email: this.user.email,
            password: this.user.password,
            password_confirmation: this.user.password_confirmation,
          },
        })
        if (response.user) {
          this.createAuthentication(response.user)
          this.$store.dispatch('message/flashMessage', {
            isAlert: true,
            alertType: 'success',
            alertMessage: 'ユーザー作成に成功しました',
          })
          this.$router.push('/users/' + response.user.id)
        } else {
          this.$store.dispatch('message/flashMessage', {
            isAlert: true,
            alertType: 'error',
            alertMessage: 'ユーザー作成に失敗しました',
          })
          this.signupUserErrors = response.errors
        }
      } catch (e) {
        this.$store.dispatch('message/flashMessage', {
          isAlert: true,
          alertType: 'warning',
          alertMessage: 'サーバーとの通信にエラーが発生しています',
        })
      }
    },
    createAuthentication: function (user) {
      this.$store.commit('authentication/setIsAuthenticated', true)
      this.$store.commit('authentication/setAuthUser', user)
    },
  },
}
</script>
