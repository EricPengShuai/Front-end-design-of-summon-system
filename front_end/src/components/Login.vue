<template>
    <div class="login_container">
        <div class="login_box">
        <!-- 头像区域 -->
        <div class="avatar_box">
            <img src="../assets/logo.png" alt="" />
        </div>
        <!-- 登录表单区域 -->
        <el-form
            ref="loginFormRef"
            class="login_form"
            label-width="0px"
            :model="loginForm"
            :rules="loginFormRules"
        >
            <el-form-item prop="username">
            <el-input
                v-model="loginForm.username"
                prefix-icon="el-icon-user-solid"
            ></el-input>
            </el-form-item>
            <el-form-item prop="password">
            <el-input
                v-model="loginForm.password"
                type="password"
                prefix-icon="el-icon-lock"
            ></el-input>
            </el-form-item>
            <el-form-item class="btns">
                <el-button type="primary" @click="register()" style="margin-right: 28px">注册</el-button>
                <el-button type="primary" @click="login('admin')">管理员登录</el-button>
                <el-button type="primary" @click="login('common')">用户登录</el-button>
                <el-button type="info" @click="resetLoginForm()">重置</el-button>
            </el-form-item>
        </el-form>
        </div>
    </div>
</template>

<script>
export default {
    data() {
        return {
        // 登录表单数据绑定对象
        loginForm: {
            username: '',
            password: '',
        },
        // 表单验证规则
        loginFormRules: {
            username: [
                { required: true, message: '请输入用户名', trigger: 'blur' },
            ],
            password: [
                { required: true, message: '请输入密码', trigger: 'blur' },
            ],
        },
        }
    },
    methods: {
        // 重置函数
        resetLoginForm() {
        console.log('重置函数：', 'resetLoginForm()')
        // 获取表单的引用对象，然后调取表单的重置函数
        this.$refs.loginFormRef.resetFields()
        },
        // 登录函数
        login(kind) {
            this.$refs.loginFormRef.validate(async (valid) => {
                // 如果不合规范直接警告
                if (!valid) return that.$message({showClose: true, message:'输入数据无效', type: 'warning'})
                // 如果合乎规范就post，注意构造方法
                var qs = require('qs')
                var data = qs.stringify(this.loginForm)
                if (kind == 'admin') {
                    var url = '/user/adminLogin'
                } else {
                    var url = '/user/login'
                }
                var config = {
                    method: 'post',
                    url: url,
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    data: data,
                }
                var that = this // 注意这里需要保存原来this
                this.$http(config)
                .then(function (response) {
                    // console.log(response.data, data, url)
                    if (response.data.code == '200') {
                        // 将登陆成功之后的token保存在sessionStorage中 --token只在当前网站打开期间生效,其他接口必须登陆之后才能访问
                        window.sessionStorage.setItem('token', response.data.data)
                        // 根据用户名查找用户信息
                        var conf = {
                                method: 'get',
                                url: '/user/getByUserName/'+that.loginForm.username,
                                headers: {
                                    'Authorization': window.sessionStorage.getItem('token')
                                },
                            }
                        var axios = require('axios');
                        axios(conf)
                        .then(function(response) {
                            // console.log(response.data)
                            if (response.data.code == 200) {
                                that.$router.push('/home')
                                // 调用方法
                                // console.log(response.data, that.loginForm)
                                that.$store.commit('user/set_userInfo', response.data.data)
                                return that.$message({ showClose: true, message: '登录成功', type: 'success' })
                            } else {
                                return that.$message({showClose: true, message: '登录失败', type: 'error'})
                            }
                        })
                        .catch(function(response) {
                            return that.$message({showClose: true, message:'请求错误', type: 'error'})
                        })
                    } else {
                        return that.$message({showClose: true, message: response.data.message, type: 'error'})
                    }
                    
                })
                .catch(function (error) {
                    console.log(error)
                    return that.$message({showClose: true, message:'请求错误', type: 'error'})
                })
            })
        },
        // 注册函数
        register() {
            this.$router.push('/register')
        },
    },
    }
</script>

<style lang="less" scoped>
// scoped 表示css只在本组件生效
.login_container {
  background-color: gray;
  height: 100%;
}
.login_box {
  width: 450px;
  height: 300px;
  background-color: white;
  border-radius: 3px;
  position: absolute;
  left: 50%;
  top: 50%;
  transform: translate(-50%, -50%);
}
.avatar_box {
  height: 130px;
  width: 130px;
  border-radius: 50%;
  border: 1px solid #eeeeee;
  padding: 10px;
  box-shadow: 0 0 10px #dddddd;
  box-sizing: content-box;
  //  居中显示
  transform: translateY(-40%);
  margin: auto;
  // 居中显示2
  /* position: absolute;
  left: 50%;
  transform: translate(-50%, -40%); */
  background-color: white;
  img {
    height: 100px;
    border-radius: 30%;
    padding: 10% 10% 10% 6%;
  }
}

// 表单位置显示
.login_form {
  padding: 0 20px;
  position: absolute;
  /* transform: translateY(-20%); */
  box-sizing: border-box;
  bottom: 0;
  width: 100%;
}
// 靠右显示
.btns {
  display: flex;
  justify-content: flex-end;
}
</style>
