<template>
    <el-container class="container">
        <el-header class="header">注册界面</el-header>
        
        <el-main class="main">
        <el-form :model="registerForm" :rules="registerRules" ref="registerFormRef" label-width="100px" class="demo-registerForm" >
            <el-form-item label="用户名" prop="username">
                <el-input v-model="registerForm.username"></el-input>
            </el-form-item>
            <el-form-item label="密码" prop="password">
                <el-input v-model="registerForm.password"></el-input>
            </el-form-item>
            <el-form-item label="用户类型" prop="userType">
            <el-select v-model="registerForm.userType" placeholder="请选择用户类型" >
                <el-option label="系统管理员" value="false" :disabled="true"></el-option>
                <el-option label="普通用户" value="true"></el-option>
            </el-select>
            </el-form-item>
            <el-form-item label="用户姓名" prop="name">
                <el-input v-model="registerForm.name"></el-input>
            </el-form-item>
            <el-form-item label="证件类型" prop="documentTypeId">
                <el-select v-model="registerForm.documentTypeId" placeholder="请选择证件类型" >
                    <!-- 动态获取证件类型下拉列表 :key好像没有很大作用？-->
                    <el-option
                        v-for="item in documentTypeOption"
                        :key="item.documentTypeId"
                        :label="item.documentTypeName"
                        :value="item.documentTypeId"
                    >
                    </el-option>
                </el-select>
            </el-form-item>
            <el-form-item label="证件号码" prop="documentNumber">
                <el-input v-model="registerForm.documentNumber"></el-input>
            </el-form-item>
            <el-form-item label="手机号码" prop="phoneNumber">
                <el-input v-model="registerForm.phoneNumber"></el-input>
            </el-form-item>
            <el-form-item label="用户简介" prop="introduce">
                <el-input type="textarea" v-model="registerForm.introduce"></el-input>
            </el-form-item>
            <el-form-item label="城市" prop="cityId">
                <el-select v-model="registerForm.cityId" placeholder="请选择您的城市" >
                    <!-- 动态获取城市类型下拉列表 -->
                    <el-option
                        v-for="item in cityOption"
                        :key="item.cityId"
                        :label="item.cityName"
                        :value="item.cityId"
                    >
                    </el-option>
                </el-select>
            </el-form-item>
            <!-- 提交按钮 -->
            <el-form-item>
                <el-button type="primary" @click="submitForm('registerForm')">立即注册</el-button>
                <el-button @click="resetForm('registerForm')">重置</el-button>
            </el-form-item>
        </el-form>
        </el-main>
    </el-container>
</template>

<script>
export default {
    data() {
        return {
        // 注册表单
        registerForm: {
            username: '',
            password: '',
            userType: '',
            name: '',
            documentTypeId: '',
            documentNumber: '',
            phoneNumber: '15577778888',
            level: 1,
            introduce: '',
            cityId: '',
        },
        documentTypeOption: [], // 证件类型列表
        cityOption: [],         // 城市列表
        // 表单规则
        registerRules: {
            username: [
                { required: true, message: '请输入用户名', trigger: 'blur' },
            ],
            password: [
                { required: true, message: '请输出密码', trigger: 'blur' },
                { validator: this.check_pwd, trigger: 'blur' },
            ],
            userType: [
                { required: true, message: '请选择用户类型', trigger: 'blur' },
            ],
            name: [
                { required: true, message: '请输入用户姓名', trigger: 'blur' }
            ],
            documentTypeId: [
                { required: true, message: '请选择证件类型', trigger: 'blur' },
            ],
            documentNumber: [
                { required: true, validator: this.check_cardType, trigger: 'blur' },
            ],
            phoneNumber: [
                { required: true, validator: this.check_phone, trigger: 'blur' },
            ],
            cityId: [
                { required: true, message: '请选择城市名称', trigger: 'blur' }
            ],
        },
        }
    },
    created() {
        /* 
        // 如果使用这个调用这个接口需要安装redis
        var that = this
        this.$http.get('/user/getDocuments')
        .then(function(response) {
            if (response.data.code == 200) {
                that.documentTypeOption = response.data.data
            } else {
                that.$message({showClose: true, message: response.data.message, type: 'warning'})
            }
        })
        .catch(function(response) {
            that.$message({showClose: true, message: "请求错误", type: 'error'})
        })
        this.$http.get('/user/getCitys')
        .then(function(response) {
            if (response.data.code == 200) {
                that.cityOption = response.data.data
            } else {
                that.$message({showClose: true, message: response.data.message, type: 'warning'})
            }
        })
        .catch(function(response) {
            that.$message({showClose: true, message: "请求错误", type: 'error'})
        }) */
        this.documentTypeOption = [
            {
              "documentTypeId": 1,
              "documentTypeName": "身份证"
            },
            {
              "documentTypeId": 2,
              "documentTypeName": "学生证"
            }
        ]
        this.cityOption = [
            {
              "cityId": 1,
              "cityName": "北京"
            },
            {
              "cityId": 2,
              "cityName": "上海"
            }
        ]
    },
    methods: {
        // 自定义校验规则，检查密码
        check_pwd(rule, value, callback) {
            // rule 对应使用bargainMoney自定义验证的 对象
            // value 对应使用bargainMoney自定义验证的 数值
            // callback 回调函数
            var regex = new RegExp(/\d/, 'g')
            if (String(value).length < 6) {
                return callback(new Error('长度不能小于6位'))
            } else if (String(value).match(regex) < 2) {
                return callback(new Error('必须含有两个数字'))
            } else if (
                /^[A-Z]+$/.test(String(value)) ||
                /^[a-z]+$/.test(String(value))
            ) {
                return callback(new Error('不能全是大写字符或小写字符'))
            } else {
                return callback()
            }
        },
        // 检查身份证号
        check_cardType(rule, value, callback) {
            const r = /\d{17}[\d|x]|\d{15}/
            const r1 = /^[0-9]*[1-9][0-9]*$/
            if (String(value).trim() == '') {
                return callback(new Error('请输入证件号码'))
            } else if (this.documentTypeId == '1' && !r.test(String(value))) {
                return callback(new Error('身份证号不合规则'))
            } else if (this.documentTypeId == '2' && !r1.test(String(value))) {
                return callback(new Error('学生证不合规则'))
            } else {
                return callback()
            }
        },
        // 检查手机号码
        check_phone(rule, value, callback) {
            const r = /0?(13|14|15|17|18)[0-9]{9}/
            if (String(value).trim() == '') {
                return callback(new Error('请输入手机号'))
            } else if (!r.test(String(value))) {
                return callback(new Error('手机号不合规则'))
            } else {
                return callback()
            }
        },

        submitForm(formName) {
            var that = this
            this.$refs.registerFormRef.validate((valid) => {
                if (!valid)
                return this.$message({
                    showClose: true,
                    message: '输入数据无效',
                    type: 'warning',
                })
                // post配置
                var config = {
                    method: 'post',
                    url: '/user/register',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    data: JSON.stringify(this.registerForm),
                }
                // 向服务器发起请求
                this.$http(config)
                .then(function (response) {
                    // console.log(response.data)
                    if (response.data.code == '200') {
                        that.$message({ showClose: true, message: '注册成功',type: 'success'})
                        that.$router.push('/login')
                    } else {
                        that.$message({showClose: true, message: response.data.message, type: 'error'})
                    }
                })
                .catch(function (error) {
                    console.log(error)
                    return that.$message({showClose: true, message:'请求错误', type: 'error'})
                })
            })
        },
        resetForm(formName) {
            this.$refs.registerFormRef.resetFields()
        },
    },
}
</script>

<style lang="less" scoped>
.container {
    height: 100%;
}
.header {
    text-align: center;
    font-size: 40px;
    background-color: darkgrey;
}
.main {
    height: 100%;
    width: 700px;
    margin: auto;
}
</style>