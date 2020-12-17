<template>
  <!-- 头部区域 -->
    <el-container class="container">
        <el-header class="header" height="90px">
        <img src="../assets/logo.gif" />
        <span>召集令管理后台</span>
        <el-button type="info" @click="logout()">退出</el-button>
        </el-header>
        <!-- 左侧菜单区域 -->
        <el-container z-index="2">
        <el-aside class="aside" :width="isCollapse ? '64px' : '200px'">
            <el-row class="tac">
                <el-col :span="12">
                    <el-menu background-color="#545c64" text-color="#fff" active-text-color="#4da6ff" router :default-active="this.$store.state.call.activeNav" :default-openeds="opens" @open="handleOpen" :collapse="isCollapse" :collapse-transition="false">
                        <div class="collapse_div" @click="changeCollapse()">|||</div>
                        <el-submenu :index="'/Convener'" v-if="!isAdmin">
                            <template slot="title" >
                                <i class="el-icon-s-promotion"></i>
                                <span>令主</span>
                            </template>
                            <el-menu-item-group>
                                <el-menu-item :index="'/convene'" @click="saveNavState('/convene')">发布召集令</el-menu-item>
                                <el-menu-item :index="'/myconvene'" @click="saveNavState('/myconvene')">我的召集令</el-menu-item>
                            </el-menu-item-group>
                        </el-submenu>
                        <el-submenu :index="'/Accepter'" v-if="!isAdmin">
                            <template slot="title" >
                                <i class="el-icon-bangzhu"></i>
                                <span>接令者</span>
                            </template>
                            <el-menu-item-group>
                                <el-menu-item :index="'/accept'" @click="saveNavState('/accept')">所有召集令</el-menu-item>
                                <el-menu-item :index="'/acceptlist'" @click="saveNavState('/acceptlist')">我的接令列表</el-menu-item>
                            </el-menu-item-group>
                        </el-submenu>

                        <el-menu-item :index="'/info'" @click="saveNavState('/info')" v-if="!isAdmin">
                            <i class="el-icon-user"></i>
                            <span slot="title">个人信息</span>
                        </el-menu-item>
                        <el-menu-item :index="'/checkinfo'" @click="saveNavState('/checkinfo')" v-if="isAdmin">
                            <i class="el-icon-user-solid"></i>
                            <span slot="title">查询用户信息</span>
                        </el-menu-item>
                        <el-menu-item :index="'/checkconvene'" @click="saveNavState('/checkconvene')" v-if="isAdmin">
                            <i class="el-icon-s-promotion"></i>
                            <span slot="title">查询召集令信息</span>
                        </el-menu-item>
                        <el-menu-item :index="'/checkaccept'" @click="saveNavState('/checkaccept')" v-if="isAdmin">
                            <i class="el-icon-bangzhu"></i>
                            <span slot="title">查询接令请求信息</span>
                        </el-menu-item>
                        <el-menu-item :index="'/checkfee'" @click="saveNavState('/checkfee')" v-if="isAdmin">
                            <i class="el-icon-success"></i>
                            <span slot="title">查询中介费用信息</span>
                        </el-menu-item>
                    </el-menu>
                </el-col>
            </el-row>
        </el-aside>
        <!-- 右侧主要内容区域 -->
        <el-main class="main"> 
            <router-view></router-view>
        </el-main>
        </el-container>
    </el-container>
</template>

<script>
export default {
    data() {
        return {
            isAdmin: false,
            active: '',
            opens: [],
            isCollapse: false,
        }
    },
    created() {
        console.log("Home()")
        this.is_admin()
    },
    mounted() {
        this.active = window.sessionStorage.getItem('activeNav')
        this.$store.commit('call/set_activeNav', this.active)
        // 刷新之后如果本来已经打开子菜单的标签就设置opens保持打开
        var release = new Array('/myconvene', '/convene')
        var accept = new Array('/accept', '/acceptlist')
        if (release.indexOf(this.active) >= 0) {
            this.opens = ['/Convener']
        } else if (accept.indexOf(this.active) >= 0) {
            this.opens = ['/Accepter']
        } else {
            this.opens = []
        }
    },
    methods: {
        // 折叠效果
        changeCollapse() {
            this.isCollapse = !this.isCollapse
        },
        // 判断是否是管理员
        is_admin() {
            if (this.$store.state.user.password == 'admin') {
                this.isAdmin = true
            } else {
                this.isAdmin = false
            }
        },
        // 退出
        logout() {
            console.log('logout() window.sessionStorage.clear()')
            window.sessionStorage.clear()
            this.$router.push('/login')
        },
        // 保存高亮状态的存储
        saveNavState(activeNav) {
            window.sessionStorage.setItem('activeNav', activeNav)
            this.active = activeNav
            this.$store.commit('call/set_activeNav', this.active)
        },
        // 处理菜单打开
        handleOpen(key, keyPath) {
            if(key == '/Convener') {
                this.active = '/myconvene'
                this.$store.commit('call/set_activeNav', this.active)
                this.$router.push('/myconvene')
                window.sessionStorage.setItem('activeNav', this.active)
            } else {
                this.active = '/accept'
                this.$store.commit('call/set_activeNav', this.active)
                this.$router.push('/accept')
                window.sessionStorage.setItem('activeNav', this.active)
            }
        }
    },
}
</script>

<style lang="less" scoped>
.container {
    height: 100%;
}
.header {
    background-color: rgb(158, 156, 156);
    display: flex;
    padding: 0px;
    justify-content: space-between;
    img {
        width: 240px;
        height: 240px;
        transform: translate(-70px, -65px);
        // z-index: 1;
        mix-blend-mode: color-burn;
    }
    span {
        align-items: center;
        margin-left: 10px;
        transform: translate(90px, 30px);
        position: absolute;
        width: fit-content;
        height: fit-content;
        font-size: 20px;
    }
    .el-button {
        display: flex;
        align-items: center;
        margin: 20px;
    }
}
.aside {
    background-color: #545c64;
    > .el-row {
        height: 100%;
        > .el-col {
            width: 100%;
            height: 100%;
            > span {
                width: 100%;
                display: block;
                text-align: center;
                font-size: 20px;
            }
        }
    }
    .el-menu {
        border-right: none;
    }
}
.main {
    background-color: rgb(238, 236, 236);
}
.collapse_div {
    margin: 5px 0px;
    color: white;
    letter-spacing: 0.2em;
    cursor: pointer;
    text-align: center;
    line-height: 20px;
}
</style>
