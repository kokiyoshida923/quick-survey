<template>
  <v-col class="mx-auto" cols="12" sm="10" md="8" lg="6" xl="4">
    <v-card class="py-4">
      <v-card-title>
        <div class="mx-auto grey--text text--darken-4 text-h6 font-weight-bold">
          アバター設定
        </div>
      </v-card-title>

      <v-card-title>
        <v-avatar
          v-if="!($store.state.nodeEnv === 'production')"
          v-bind:class="[
            user.avatar.url === '/images/fallback/default.png'
              ? 'grey lighten-2'
              : 'blue-grey lighten-2',
          ]"
          size="128"
          class="mx-auto"
        >
          <div v-show="fileLoading">
            <v-progress-circular size="25" width="2" indeterminate />
          </div>
          <img
            v-show="!fileLoading"
            id="preview"
            v-bind:src="$config.axios.browserBaseURL + user.avatar.url"
            v-bind:style="
              user.avatar.url === '/images/fallback/default.png' &&
              !hasPreviewed()
                ? { 'max-width': '90%', 'max-height': '90%' }
                : ''
            "
          />
        </v-avatar>
      </v-card-title>

      <ErrorMessages
        v-if="Object.keys(updateUserAvatarErrors).length !== 0"
        class="py-6"
        v-bind:error-messages="updateUserAvatarErrors"
      ></ErrorMessages>

      <v-card-text>
        <ValidationObserver ref="form">
          <form v-on:submit.prevent="updateUserAvatar()">
            <ValidationProvider
              v-slot="{ errors, validate }"
              name="画像"
              rules="image"
            >
              <v-file-input
                v-bind:error-messages="errors"
                label="ユーザー画像"
                color="cyan darken-3"
                dense
                show-size
                small-chips
                v-bind:prepend-icon="userEditAvatarIcon.avatar.mdiCamera"
                v-on:change="handleFileChange($event, validate)"
                v-on:click:clear="handleFileClear()"
              ></v-file-input>
            </ValidationProvider>
            <v-btn
              class="my-4 grey--text text--lighten-4 font-weight-bold"
              v-bind:loading="loading"
              v-bind:disabled="loading"
              v-bind:ripple="false"
              type="submit"
              color="cyan darken-3"
              block
              depressed
            >
              更新する
            </v-btn>
          </form>
        </ValidationObserver>
      </v-card-text>
    </v-card>
  </v-col>
</template>

<script>
import { mdiCamera } from '@mdi/js'

import {
  extend,
  localize,
  ValidationObserver,
  ValidationProvider,
} from 'vee-validate'
import ja from 'vee-validate/dist/locale/ja'
import { image } from 'vee-validate/dist/rules'
localize('ja', ja)

extend('image', {
  ...image,
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
      userEditAvatarIcon: {
        avatar: { mdiCamera: mdiCamera },
      },
      loading: false,
      loader: null,
      fileLoading: false,
      uploadFile: null,
      updateUserAvatarErrors: {},
    }
  },
  watch: {
    loader: function () {
      const l = this.loader
      this[l] = !this[l]
      this.loader = null
    },
  },
  methods: {
    handleFileChange: async function (file, validate) {
      if (file !== null && file !== undefined) {
        this.uploadFile = file
        const previewElement = document.getElementById('preview')
        const result = await validate(file)
        if (result.valid === true) {
          this.fileLoading = true
          const reader = new FileReader()
          reader.addEventListener('load', function () {
            previewElement.src = reader.result
          })
          reader.readAsDataURL(this.uploadFile)
          const that = this
          setTimeout(function () {
            that.fileLoading = false
          }, 500)
        } else if (result !== false) {
          previewElement.src =
            this.$config.axios.browserBaseURL + this.user.avatar.url
        }
      } else if (file === undefined) {
        this.handleFileClear()
      }
    },
    handleFileClear: function () {
      if (this.hasPreviewed()) {
        this.fileLoading = true
        const previewElement = document.getElementById('preview')
        previewElement.src =
          this.$config.axios.browserBaseURL + this.user.avatar.url
        const that = this
        setTimeout(function () {
          that.fileLoading = false
        }, 500)
      }
      this.uploadFile = null
      this.$nextTick(() => {
        this.$refs.form.reset()
      })
    },
    hasPreviewed: function () {
      if (this.uploadFile === null) return false
      const allowExts = ['jpg', 'jpeg', 'png', 'gif']
      const ext = this.getExt(this.uploadFile.name)
      return allowExts.includes(ext)
    },
    getExt: function (fileName) {
      const pos = fileName.lastIndexOf('.')
      if (pos === -1) return ''
      return fileName.slice(pos + 1)
    },
    updateUserAvatar: async function () {
      try {
        this.loader = 'loading'
        const formData = new FormData()
        formData.append('user[avatar]', this.uploadFile)
        const config = {
          headers: {
            'content-type': 'multipart/form-data',
          },
        }
        const response = await this.$axios.$patch(
          '/api/v1/users/' + this.user.id,
          formData,
          { config: config }
        )
        if (response.user) {
          this.$store.dispatch('message/flashMessage', {
            isAlert: true,
            alertType: 'success',
            alertMessage: 'ユーザーアバター更新に成功しました',
          })
          this.$emit('assign-updated-user', response.user)
          this.$router.push('/users/' + response.user.id)
        } else {
          const that = this
          this.$store.dispatch('message/flashMessage', {
            isAlert: true,
            alertType: 'error',
            alertMessage: 'ユーザーアバター更新に失敗しました',
          })
          this.updateUserAvatarErrors = response.errors
          setTimeout(function () {
            that.loading = false
          }, 1000)
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
