<template>
    <div style="height: 100%">
        <!-- 面包屑 -->
        <el-breadcrumb separator-class="el-icon-arrow-right" style="margin-bottom: 10px">
            <el-breadcrumb-item :to="{ path: '/welcome' }">首页</el-breadcrumb-item>
            <el-breadcrumb-item>查询接令请求信息</el-breadcrumb-item>
        </el-breadcrumb>
        <!-- 信息主体 -->
        <h2>接令请求信息表</h2>
        <el-card>
            <el-table :data="tableData" :header-cell-style="{'text-align':'center'}" 
                      :cell-style="{'text-align':'center'}" border>
                <el-table-column prop="id" label="请求标识" width="100"></el-table-column>
                <el-table-column prop="callId" label="请求召集令标识" width="150"></el-table-column>
                <el-table-column prop="callName" label="召集令名字" width="150"></el-table-column>
                <el-table-column prop="userId" label="请求者ID" width="100"></el-table-column>
                <el-table-column prop="description" label="请求描述" ></el-table-column>
                <el-table-column prop="createTime" label="创建请求时间" width="180"></el-table-column>
                <el-table-column prop="modifyTime" label="修改请求时间" width="180"></el-table-column>
                <el-table-column prop="state" label="状态" width="100"></el-table-column>
                <el-table-column label="查看请求用户信息" width="140">
                    <template slot-scope='scope'>
                        <el-button type="primary" icon="el-icon-user-solid" @click="checkRequester(scope.row.userId)"></el-button>
                    </template>
                </el-table-column>
            </el-table>
            <div class="card_foot">
                <div class="block" style="margin: 5px 0px; float: left;">
                    <el-pagination
                    @size-change="handleSizeChange"
                    @current-change="handleCurrentChange"
                    :current-page="page"
                    :page-sizes="[2, 5, 10, 15]"
                    :page-size="rows"
                    layout="total, sizes, prev, pager, next, jumper"
                    :total="total">
                    </el-pagination>
                </div>
            </div>
        </el-card>

        <!-- 基本信息 -->
        <el-dialog title="请求者基本信息" :visible.sync="infoVisable" width="50%">
            <table style="width: 100%" class="myTable">
                <tr v-for="item in userInfo">
                    <td class="column" v-if="item">{{ item[0] }}</td>
                    <td class="column" v-if="item">{{ item[1] }}</td>
                </tr>
            </table>
        </el-dialog>
    </div>
</template>

<script>
export default {
    data() {
        return {
            tableData: [],          // el-table数据
            page: 1,                // 数据页数
            rows: 10,               // 每页行数
            total: 0,               // 数据总数
            infoVisable: false,     // 查看召集令信息是否可见
            userInfo: [],           // 个人基本信息
        }
    },
    created() {
        this.init()
    },
    methods: {
        // 获取所有请求信息
        init() {
            var that = this
            this.$http.get('/request/pageFind/'+ this.page+'/'+ this.rows, {
                                headers: {
                                    'Authorization': window.sessionStorage.getItem('token')
                                }
                            })
            .then(function(response) {
                console.log('acceptList');
                for(var i = 0; i < response.data.data.records.length; i ++) {
                    switch (response.data.data.records[i]['state']) {
                        case 0:
                            response.data.data.records[i]['state'] = "待处理";
                            break;
                        case 1:
                            response.data.data.records[i]['state'] = "同意";
                            break;
                        case 2:
                            response.data.data.records[i]['state'] = "拒绝";
                            break;
                        case 3:
                            response.data.data.records[i]['state'] = "取消";
                            break;
                        case 4:
                            response.data.data.records[i]['state'] = "响应中";
                            break;
                        default:
                            break;
                    }
                }
                that.tableData = response.data.data.records
                that.total = response.data.data.total
            })
            .catch(function(error) {
                console.log(error)
                return that.$message({showClose: true, message:'请求错误', type: 'error'})
            })
        },
        // 查看请求者个人信息
        checkRequester(userId) {
            var that = this
            this.$http.get(`/user/getById/${userId}`,{
                                headers: {
                                    'Authorization': window.sessionStorage.getItem('token')
                                }
                            })
            .then(function(response) {
                console.log(response.data.data)
                that.userInfo = new Array(12)
                if (response.data.code == 200) {
                    Object.getOwnPropertyNames(response.data.data).forEach(function(key){
                        // console.log(key, '---', response.data.data[key])
                        switch(key) {
                            case 'id': that.userInfo[0] =['用户ID', response.data.data[key]]; break;
                            case 'username': that.userInfo[1] = ['用户名', response.data.data[key]]; break;
                            case 'password': that.userInfo[2] = ['用户密码', response.data.data[key]]; break;
                            case 'name': that.userInfo[3] = ['用户名称', response.data.data[key]]; break;
                            case 'documentTypeName': that.userInfo[4] = ['证件类型', response.data.data[key]]; break;
                            case 'documentNumber': that.userInfo[5] = ['证件号码', response.data.data[key]]; break;
                            case 'phoneNumber': that.userInfo[6] = ['手机号', response.data.data[key]]; break;
                            case 'level': that.userInfo[7] = ['用户级别', response.data.data[key]]; break;
                            case 'introduce': that.userInfo[8] = ['用户简介', response.data.data[key]]; break;
                            case 'cityName': that.userInfo[9] = ['所在城市', response.data.data[key]]; break;
                            case 'createTime': that.userInfo[10] = ['注册时间', response.data.data[key]]; break;
                            case 'modifyTime': that.userInfo[11] = ['修改时间', response.data.data[key]]; break;
                            default: break;
                        }
                    })
                    that.infoVisable = true
                } else {
                    that.$message({showClose: true, message: response.data.data, type: 'error'})
                }
            })
            .catch(function(error) {
                console.log(error);
                return that.$message({showClose: true, message:'请求错误', type: 'error'})
            })
        },
        // 监听最新的CheckAcceptPageSize
        handleSizeChange(newSize) {
            console.log(`每页 ${newSize} 条`)
            this.rows = newSize
            this.init()
        },
        // 监听页码值的改变
        handleCurrentChange(newPage) {
            console.log(`当前页: ${newPage}`)
            this.page = newPage
            this.init()
        },
    }
}
</script>

<style lang="less" scoped>
div {
    h2 {
        text-align: center;
    }
    .el-table {
        width: 100%;
        margin: 10px 0px
    }
}
</style>