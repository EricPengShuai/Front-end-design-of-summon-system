import Vue from 'vue'
import Vuex from 'vuex'
import user from './user.module.js'
import call from './call.module.js'

Vue.use(Vuex)

const store = new Vuex.Store({
    modules: {
        user,
        call
    }
})

export default store