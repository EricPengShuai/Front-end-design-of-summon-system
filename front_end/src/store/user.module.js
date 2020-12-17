const api = 'http://127.0.0.1:9998/'

const axios = require('axios');

import { Message } from "element-ui";

export default {
    namespaced: true,
    state: {
        id: '',
        username: 'test',
        password: '',
        userType: '',
        name: '',
        documentTypeName: '',
        documentNumber: '',
        phoneNumber: '',
        level: 1,
        introduce: '',
        cityName: '',
        createTime: '',
        modifyTime: ''
    },
    getters: {
        get_id(state) {
            return state.id
        },
        get_username(state) {
            return state.username
        },
        get_password(state) {
            return state.password
        },
        get_userType(state) {
            if (state.userType == false) {
                return '系统管理员'
            } else {
                return '普通用户'
            }
        },
        get_name(state) {
            return state.name
        }
    },
    mutations: {
        set_username(state, payload) {
            state.username = payload
            console.log('set_username')
        },
        set_password(state, payload) {
            state.password = payload
            console.log('set_password')
        },
        set_phone(state, payload) {
            state.phoneNumber = payload
            console.log('set_phone')
        },
        set_introduce(state, payload) {
            state.introduce = payload
            console.log('set_introduce')
        },
        set_userInfo(state, userInfo) {
            state.id = userInfo.id,
            state.username = userInfo.username,
            state.password = userInfo.password,
            state.userType = userInfo.userType,
            state.name = userInfo.name,
            state.documentTypeName = userInfo.documentTypeName,
            state.documentNumber = userInfo.documentNumber,
            state.phoneNumber = userInfo.phoneNumber,
            state.level = userInfo.level,
            state.introduce = userInfo.introduce,
            state.cityName = userInfo.cityName,
            state.createTime = userInfo.createTime,
            state.modifyTime = userInfo.modifyTime
            console.log('set_userInfo', userInfo)
        }
    },
    actions: {
        // 修改用户信息
        modify({ state }) {
            // post配置
            var config = {
                method: 'post',
                url: '/user/modifyMessage',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': window.sessionStorage.getItem('token')
                },
                data: JSON.stringify({id: state.id, phoneNumber: state.phoneNumber, introduce: state.introduce, password: state.password}),
            }
            axios(config)
            .then((rep) => {
                console.log('modify', rep.data)
                if (rep.data.code == 200) {
                    Message({
                        showClose: true,
                        type: 'success',
                        message: '修改成功!'
                    })
                } else {
                    Message({
                        showClose: true,
                        type: 'info',
                        message: '无法完成修改!'
                    })
                }
            })
            .catch((error) => {
                console.error(error)
                Message({
                    showClose: true,
                    type: 'warning',
                    message: '请求错误!'
                })
            })
        }
    }
}