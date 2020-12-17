<template>
    <div style="height: 100%">
        <!-- 面包屑 -->
        <el-breadcrumb separator-class="el-icon-arrow-right" style="margin-bottom: 10px">
            <el-breadcrumb-item :to="{ path: '/welcome' }">首页</el-breadcrumb-item>
            <el-breadcrumb-item>查询所有召集令信息</el-breadcrumb-item>
        </el-breadcrumb>
        <!-- 信息主体 -->
        <h2>召集令信息表</h2>
        <el-card>
            <template>
                <el-select style="float: left; width: 25%" v-model="value" placeholder="请要查询的召集令类型">
                    <el-option
                        v-for="item in calls"
                        :key="item.callTypeId"
                        :label="item.callTypeName"
                        :value="item.callTypeId"
                    >
                    </el-option>
                </el-select>
                <el-input placeholder="请输入要查询的模糊名称" clearable prefix-icon="el-icon-search" v-model="input" style="width: 35%; margin-left:25px;"></el-input>
                <el-button type="primary" @click="check('check')" style="margin: 0px; float: right;">查询</el-button>
            </template>
            <el-table :data="tableData" 
                :header-cell-style="{'text-align':'center'}" :cell-style="{'text-align':'center'}" border>
                <el-table-column prop="id" label="召集令标识" width="100">
                </el-table-column>
                <el-table-column prop="userId" label="发布者ID" width="100">
                </el-table-column>
                <el-table-column prop="typeName" label="召集令类型" width="120">
                </el-table-column>
                <el-table-column prop="name" label="召集令名称" width="120">
                </el-table-column>
                <el-table-column prop="description" label="召集令描述" width="200">
                </el-table-column>
                <el-table-column prop="peopleCount" label="召集人数" width="120">
                </el-table-column>
                <el-table-column prop="endTime" label="召集结束时间" width="200">
                </el-table-column>
                <el-table-column prop="introPicture" label="描述照片" width="100">
                </el-table-column>
                <el-table-column prop="createTime" label="发布时间" width="200">
                </el-table-column>
                <el-table-column prop="modifyTime" label="修改时间" width="200">
                </el-table-column>
                <el-table-column prop="people" label="已召集人数" width="100">
                </el-table-column>
                <el-table-column prop="stateName" label="召集令状态" width="100">
                </el-table-column>
                <el-table-column label="查看令主信息" width="120">
                    <template slot-scope='scope'>
                        <el-button type="primary" @click="checkInfo(scope.row.userId)" icon="el-icon-user-solid"></el-button>
                    </template>
                </el-table-column>
            </el-table>
            <div class="block" style="margin-top: 10px">
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
        </el-card>
        <p>注：第一个下拉框可以选择查询类型，第二个输入框可以输入要查询的召集令模糊名称。</p>
        <!-- 展示令主信息 -->
        <el-dialog title="令主信息" :visible.sync="infoVisable" width="50%">
            <table style="width: 100%" class="myTable">
                <tr v-for="item in userInfo">
                    <td class="column" v-if="item">{{ item[0] }}</td>
                    <td class="column" v-if="item">{{ item[1] }}</td>
                </tr>
            </table>
        </el-dialog>
    </div>
</template>

<script>
export default {
    data() {
        return {
            input: '',
            tableData: [],
            infoVisable: false,     // 用户信息对话框可见性
            userInfo: [],           // 用户信息数组
            calls: [
                { callTypeId: '', callTypeName: '全部类别'}
            ],
            value: '',
            page: 1,
            rows: 10,
            total: 0,
            url: '',    // 每次访问的API接口地址
        }
    },
    created() {
        var that = this
        this.$http.get("/call/getCallType", {
                headers: {
                    'Authorization': window.sessionStorage.getItem('token') 
                }
        })
        .then(function(response) {
            if (response.data.code == 200) {
                that.calls = that.calls.concat(response.data.data)
            } else {
                that.$message({showClose: true, message: response.data.message, type: 'warning'})
            }
        })
        .catch(function(error) {
            console.log(error)
            that.$message({showClose: true, message: "请求错误", type: 'error'})
        })
        this.url = `/call/pageFind/${this.page}/${this.rows}`
        this.getConveneList(this.url, 'created()')
    },
    methods: {
        // 得到所有召集令分页信息
        getConveneList(url, kind) {
            var that = this
            this.$http.get(url, {
                headers: {
                    'Authorization': window.sessionStorage.getItem('token')
                }
            })
            .then(function(response) {
                // console.log(kind, 'checkConvene()');
                that.tableData = response.data.data.records
                that.total = response.data.data.total
            })
            .catch(function(error) {
                console.error(error)
                return that.$message({showClose: true, message:'请求错误', type: 'error'})
            })
        },
        // 查询类型变化
        check(type) {
            if (type == 'check') {
                this.page = 1
            }
            if(this.input != '' && this.value == '') {
                this.url = `/call/pageFind/byName/${this.page}/${this.rows}/${this.input}`
                this.getConveneList(this.url, '模糊名称查找')
            } else if (this.value != '' && this.input == '') {
                console.log(this.value)
                this.url = `/call/pageFind/byType/${this.page}/${this.rows}/${this.value}`
                this.getConveneList(this.url, '类型查找')
            } else if (this.input != '' && this.value != '') {
                this.url = `/call/pageFind/byTypeAndName/${this.page}/${this.rows}/${this.value}/${this.input}`
                this.getConveneList(this.url, '模糊名称和类型查找')
            } else {
                this.url = `/call/pageFind/${this.page}/${this.rows}`
                this.getConveneList(this.url, '所有分页数据')
            }
        },
        // 监听最新的pageSize
        handleSizeChange(newSize) {
            console.log(`每页 ${newSize} 条`)
            this.rows = newSize
            this.check('changeSize')
        },
        // 监听页码值的改变
        handleCurrentChange(newPage) {
            console.log(`当前页: ${newPage}`)
            this.page = newPage
            this.check('changeSize')
        },
        // 查看令主信息
        checkInfo(userId) {
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
                    that.$message({showClose: true, message: response.data.data, type: 'warning'})
                }
            })
            .catch(function(error) {
                console.log(error);
                return that.$message({showClose: true, message:'请求错误', type: 'error'})
            })
        }
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