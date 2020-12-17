import Vue from 'vue'
import VueRouter from 'vue-router'
import Login from '../components/Login.vue'
import Home from '../components/Home.vue'
import Register from '../components/Register.vue'
import Info from '../components/Info.vue'
import Welcome from '../components/Welcome.vue'

import Convene from '../components/release_convene/Convene.vue'
import Myconvene from '../components/release_convene/Myconvene.vue'
// const myconvene = () => import("../components/release_convene/Myconvene.vue");

import Accept from '../components/accept_convene/Accept.vue'
import AcceptList from '../components/accept_convene/AcceptList.vue'

import CheckConvene from '../components/CheckConvene.vue'
import CheckInfo from '../components/CheckInfo.vue'
import CheckAccept from '../components/CheckAccept.vue'
import CheckFee from '../components/CheckFee.vue'

Vue.use(VueRouter)

const router = new VueRouter({
    // mode: 'hash',
    routes: [
        { path: '/', redirect: '/login' },
        { path: '/login', component: Login },
        {
        path: '/home', 
        component: Home, 
        redirect: '/welcome',
        children: 
        [
            { path: '/welcome', component: Welcome },
            { path: '/info', component: Info },
            
            { path: '/convene', component: Convene },
            { path: '/myconvene', component: Myconvene },

            { path: '/accept', component: Accept },
            { path: '/acceptlist', component: AcceptList },
            
            { path: '/checkinfo', component: CheckInfo },
            { path: '/checkconvene', component: CheckConvene },
            { path: '/checkaccept', component: CheckAccept },
            { path: '/checkfee', component: CheckFee },
        ]
        },
        { path: '/register', component: Register }
    ]
})

router.beforeEach((to, from, next) => {
    // to 将要访问的路径
    // from 从哪个路径跳转而来
    // next 是一个函数，表示放行
    // next() 放行  next('/login') 强制跳转
    if (to.path == '/login' || to.path == '/register') {
        return next()
    } else {
        // 获取token
        const tokenStr = window.sessionStorage.getItem('token')
        if (!tokenStr) {
            // 如果没有登陆就强制跳转到登录界面
            return next('/login')
        } else {
            next()
        }
    }
})

export default router
