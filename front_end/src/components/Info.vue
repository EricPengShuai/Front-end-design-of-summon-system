<template>
	<div>
		<!-- 面包屑 -->
		<el-breadcrumb separator-class="el-icon-arrow-right" style="margin-bottom: 10px">
			<el-breadcrumb-item :to="{ path: '/welcome' }">首页</el-breadcrumb-item>
			<el-breadcrumb-item>个人信息</el-breadcrumb-item>
		</el-breadcrumb>
		<!-- 展示和修改信息主体 -->
		<h2>Information</h2>
		<el-main class="main">
            <el-form label-width="100px" >
            <el-form-item label="用户id">
                <el-input v-model=this.$store.state.user.id disabled></el-input>
            </el-form-item>
            <el-form-item label="用户名">
                <el-input v-model=this.$store.state.user.username disabled></el-input>
            </el-form-item>
            <el-form-item label="密码">
                <el-input v-model='password' :disabled=!this.flag_revise></el-input>
            </el-form-item>
            <el-form-item label="用户类型">
                <el-input v-model=this.userType disabled></el-input>
            </el-form-item>
            <el-form-item label="用户姓名">
                <el-input v-model=this.$store.state.user.name disabled></el-input>
            </el-form-item>
            <el-form-item label="证件类型">
                <el-input v-model=this.$store.state.user.documentTypeName disabled></el-input>
            </el-form-item>
            <el-form-item label="证件号码">
                <el-input v-model=this.$store.state.user.documentNumber disabled></el-input>
            </el-form-item>
            <el-form-item label="手机号码">
                <el-input v-model='phoneNumber' :disabled=!this.flag_revise></el-input>
            </el-form-item>
            <el-form-item label="用户级别">
                <el-input v-model=this.$store.state.user.level disabled></el-input>
            </el-form-item>
            <el-form-item label="用户简介">
                <el-input type="textarea" v-model='introduce' :disabled=!this.flag_revise></el-input>
            </el-form-item>
            <el-form-item label="城市">
                <el-input v-model=this.$store.state.user.cityName disabled></el-input>
            </el-form-item>
            <el-form-item label="创建时间">
                <el-input v-model=this.$store.state.user.createTime disabled></el-input>
            </el-form-item>
            <el-form-item label="修改时间">
                <el-input v-model=this.$store.state.user.modifyTime disabled></el-input>
            </el-form-item>
            <el-form-item>
                <el-button type="primary" @click="revise()" :disabled=this.flag_revise>修改</el-button>
                <el-button type="warning" @click="commit()" :disabled=!this.flag_revise>确认</el-button>
            </el-form-item>
            </el-form>
			<h5>注：只能修改用户密码、手机号、用户简介等信息</h5>
		</el-main>
	</div>
</template>

<script>
import { mapState } from 'vuex'
export default {
	data() {
		return {
            flag_revise: false,
            userType: this.$store.getters['user/get_userType'],
		}
	},
	computed: {
		// ...mapState('user', ['password', 'phoneNumber', 'introduce']),
		password: {
            get() {
                return this.$store.state.user.password
            },
            set(val) {
                this.$store.commit('user/set_password', val)
            }
		},
		phoneNumber: {
            get() {
                return this.$store.state.user.phoneNumber
            },
            set(val) {
                this.$store.commit('user/set_phone', val)
            }
		},
		introduce: {
            get() {
                return this.$store.state.user.introduce
            },
            set(val) {
                this.$store.commit('user/set_introduce', val)
            }
		}
	},
	methods: {
		revise() {
		    this.flag_revise = true
		},
		commit() {
            this.$confirm('是否修改相关信息?', '提示', {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'warning',
                center: true
            })
            .then(() => {
                this.$store.dispatch('user/modify')
                this.flag_revise = false
            });
        }
	}
}
</script>

<style lang="less" scoped>
div>h2 {
	text-align: center;
}
div > .el-main > h5 {
  	margin-left: 30px;
}
</style>