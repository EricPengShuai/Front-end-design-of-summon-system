import Vue from 'vue'
import App from './App.vue'
import router from './router'
import store from './store'
import './assets/global.css'
import './plugins/element.js'

import axios from 'axios'

// 全局路径
axios.defaults.baseURL = 'http://localhost:9998/'

/* axios.interceptors.request.use((config) => {
    console.log(config)
    // 为请求头对象添加token验证的Authorization字段
    config.header.Authorization = window.sessionStorage.getItem('token')
    return config
}) */

Vue.prototype.$http = axios
Vue.config.productionTip = false

new Vue({
  router,
  store,
  render: h => h(App)
}).$mount('#app')
