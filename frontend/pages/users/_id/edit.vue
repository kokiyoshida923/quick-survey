<template>
  <v-row no-gutters>
    <v-col
      v-if="isUsersEditPath($route.path)"
      class="mx-auto"
      cols="12"
      sm="10"
      md="8"
      lg="6"
      xl="4"
    >
      <v-card class="py-4" outlined>
        <v-card-title>
          <div
            class="mx-auto grey--text text--darken-4 text-h6 font-weight-bold"
          >
            アカウント設定
          </div>
        </v-card-title>

        <v-divider class="mx-4 my-4"></v-divider>

        <ErrorMessages
          v-if="Object.keys(updateUserErrors).length !== 0"
          class="py-6"
          v-bind:error-messages="updateUserErrors"
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
              v-bind:prepend-icon="userEditIcon.name.mdiAccountCircle"
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
              v-bind:prepend-icon="userEditIcon.email.mdiEmail"
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
              rules="userPassword|confirmed:@passwordConfirmation"
            >
              <v-text-field
                v-model="user.password"
                v-bind:class="[$vuetify.breakpoint.smAndDown ? 'my-3' : 'my-5']"
                v-bind:error-messages="errorHandler(errors, 'password')"
                v-bind:append-icon="
                  showUserPassword
                    ? userEditIcon.eye.mdiEye
                    : userEditIcon.eyeOff.mdiEyeOff
                "
                v-bind:type="showUserPassword ? 'text' : 'password'"
                v-bind:prepend-icon="userEditIcon.password.mdiLock"
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
              vid="passwordConfirmation"
            >
              <v-text-field
                v-model="user.password_confirmation"
                v-bind:class="[$vuetify.breakpoint.smAndDown ? 'my-3' : 'my-5']"
                v-bind:error-messages="
                  errorHandler(errors, 'passwordConfirmation')
                "
                v-bind:append-icon="
                  showUserPasswordConfirmation
                    ? userEditIcon.eye.mdiEye
                    : userEditIcon.eyeOff.mdiEyeOff
                "
                v-bind:type="showUserPasswordConfirmation ? 'text' : 'password'"
                v-bind:prepend-icon="
                  userEditIcon.password_confirmation.mdiLockCheck
                "
                label="パスワード(確認用)"
                color="cyan darken-3"
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
              v-bind:ripple="false"
              color="cyan darken-3"
              block
              depressed
              v-on:click="updateUser()"
            >
              更新する
            </v-btn>
          </v-card-actions>
        </v-card-text>
      </v-card>
    </v-col>
    <NuxtChild
      v-on:assign-updated-user="$emit('assign-updated-user', $event)"
    />
  </v-row>
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
  middleware: async function (context) {
    try {
      await context.$axios.get('/api/v1/users/' + context.params.id + '/edit')
    } catch (e) {
      context.redirect('/')
      if (e.response.statusText === 'Forbidden') {
        context.store.dispatch('message/flashMessage', {
          isAlert: true,
          alertType: 'error',
          alertMessage: e.response.data.message,
        })
      } else {
        context.store.dispatch('message/flashMessage', {
          isAlert: true,
          alertType: 'warning',
          alertMessage: 'サーバーとの通信にエラーが発生しています',
        })
      }
    }
  },
  asyncData: async function (context) {
    const response = await context.$axios.$get(
      '/api/v1/users/' + context.params.id + '/edit'
    )
    return {
      user: response.user,
    }
  },
  data: function () {
    return {
      userEditIcon: {
        name: { mdiAccountCircle: mdiAccountCircle },
        email: { mdiEmail: mdiEmail },
        password: { mdiLock: mdiLock },
        password_confirmation: { mdiLockCheck: mdiLockCheck },
        eye: { madEye: mdiEye },
        eyeOff: { mdiEyeOff: mdiEyeOff },
      },
      showNameError: false,
      showEmailError: false,
      showPasswordError: false,
      showPasswordConfirmationError: false,
      showUserPassword: false,
      showUserPasswordConfirmation: false,
      updateUserErrors: {},
    }
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
    updateUser: async function () {
      try {
        const response = await this.$axios.$patch(
          '/api/v1/users/' + this.user.id,
          {
            user: {
              name: this.user.name,
              email: this.user.email,
              password: this.user.password,
              password_confirmation: this.user.password_confirmation,
            },
          }
        )
        if (response.user) {
          this.$store.dispatch('message/flashMessage', {
            isAlert: true,
            alertType: 'success',
            alertMessage: 'ユーザー更新に成功しました',
          })
          this.$emit('assign-updated-user', response.user)
          this.$router.push('/users/' + response.user.id)
        } else {
          this.$store.dispatch('message/flashMessage', {
            isAlert: true,
            alertType: 'error',
            alertMessage: 'ユーザー更新に失敗しました',
          })
          this.updateUserErrors = response.errors
        }
      } catch (e) {
        this.$store.dispatch('message/flashMessage', {
          isAlert: true,
          alertType: 'warning',
          alertMessage: 'サーバーとの通信にエラーが発生しています',
        })
      }
    },
    isUsersEditPath: function (path) {
      if (path === '/users/' + this.user.id + '/edit') {
        return true
      } else {
        return false
      }
    },
  },
}
</script>
