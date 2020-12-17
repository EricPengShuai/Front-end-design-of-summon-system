<template>
    <div style="height: 100%">
        <!-- 面包屑 -->
        <el-breadcrumb separator-class="el-icon-arrow-right" style="margin-bottom: 10px">
            <el-breadcrumb-item :to="{ path: '/welcome' }">首页</el-breadcrumb-item>
            <el-breadcrumb-item>查询用户信息</el-breadcrumb-item>
        </el-breadcrumb>
        <!-- 信息主体 -->
        <el-card class="box-card">
            <el-input v-model="inputId" clearable placeholder="查询指定ID用户" style="width: fit-content"></el-input>
            <el-input v-model="inputName" clearable placeholder="查询模糊名称用户" style="margin-left: 5px; width: fit-content;"></el-input>
            <el-select v-model="inputLevel" style="margin-left: 5px; width: fit-content" clearable placeholder="查询指定等级用户">
                <el-option
                    v-for="item in levelOptions"
                    :key="item.value"
                    :label="item.label"
                    :value="item.value">
                    <span style="float: left">{{ item.label }}</span>
                    <span style="float: right; color: #8492a6; font-size: 13px">{{ item.value }}</span>
                </el-option>
            </el-select>
            <!-- <el-input v-model="inputLevel" clearable placeholder="查询指定等级用户" style="margin-left: 5px; width: fit-content"></el-input> -->
            
            <el-button @click="showAll()" type="info" plain >显示所有用户</el-button>
            <el-button @click="check()" type="info" plain style="margin-right: 10px;">查询所选用户</el-button>
            <el-table :data="tableData" border
                :header-cell-style="{'text-align':'center'}" :cell-style="{'text-align':'center'}">
                <el-table-column prop="id" label="用户标识" width="100">
                </el-table-column>
                <el-table-column prop="username" label="用户名" width="100">
                </el-table-column>
                <el-table-column prop="password" label="密码" width="100">
                </el-table-column>
                <el-table-column prop="userType" label="用户类型" width="100">
                </el-table-column>
                <el-table-column prop="name" label="用户姓名" width="100">
                </el-table-column>
                <el-table-column prop="documentTypeName" label="证件类型" width="100">
                </el-table-column>
                <el-table-column prop="documentNumber" label="证件号码" width="180">
                </el-table-column>
                <el-table-column prop="phoneNumber" label="手机号码" width="150">
                </el-table-column>
                <el-table-column prop="level" label="用户级别" width="100">
                </el-table-column>
                <el-table-column prop="introduce" label="用户简介" width="200">
                </el-table-column>
                <el-table-column prop="cityName" label="城市" width="100">
                </el-table-column>
                <el-table-column prop="createTime" label="注册时间" width="170">
                </el-table-column>
                <el-table-column prop="modifyTime" label="修改时间" width="170">
                </el-table-column>
            </el-table>
            <div class="block" v-show="isPageShow" style="margin-top: 10px">
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
        <p>注：用户级别对应关系是：钻石 0 | 重要 1 | 一般 2</p>
    </div>
</template>

<script>
export default {
    data() {
        return {
            levelOptions: [
                {'label': '钻石', 'value': '0'},
                {'label': '重要', 'value': '1'},
                {'label': '一般', 'value': '2'}
            ],
            inputId: '',
            inputName: '',
            inputLevel: '',
            isPageShow: true,
            page: 1,    // 数据页数
            rows: 10,    // 每页行数
            total: 0,   // 数据总数
            tableData: [],
        }
    },
    created() {
        this.getUserList()
    },
    methods: {
        getUserList() {
            var that = this
            this.$http.get(`/user/pageFindAll/${this.page}/${this.rows}`, {
                headers: { 
                    'Authorization': window.sessionStorage.getItem('token')
                },
            })
            .then(function(response) {
                console.log('checkInfo_getUserIdList', response.data.data);
                for(var i = 0; i < response.data.data.records.length; i ++) {
                    if(response.data.data.records[i]['userType'] == false) {
                        response.data.data.records[i]['userType'] = '系统管理员'
                    } else {
                        response.data.data.records[i]['userType'] = '普通用户'
                    }
                }
                that.total = response.data.data.total
                that.tableData = response.data.data.records
            })
            .catch(function(error) {
                console.error(error)
                return that.$message({showClose: true, message:'请求错误', type: 'error'})
            })
            return false
        },
        showAll() {
            this.isPageShow = true
            this.inputId = this.inputName = this.inputLevel = ''
            this.getUserList()
        },
        check() {
            if (this.inputId == '' && this.inputName == '' && this.inputLevel == '') {
                return this.$message({ showClose: true, message:'至少输入一个查询条件', type: 'warning' })
            }
            this.isPageShow = false
            var data = {
                            "id": this.inputId, 
                            "username": this.inputName, 
                            "level": this.inputLevel, 
                            "page": this.page,
                            "rows": this.rows,
                        }
            var config = {
                method: 'post',
                url: '/user/getByQuery',
                headers: { 
                    'Authorization': 'qwqw', 
                    'Content-Type': 'application/json'
                },
                data : JSON.stringify(data)
            };
            console.log("条件查询", data)
            var that = this

            this.$http(config)
            .then(function(response) {
                console.log('checkInfo', response.data)
                if (response.data.code == '400') {
                    that.isPageShow = true
                    return that.$message({showClose: true, message:response.data.message})
                }
                for(var i = 0; i < response.data.data.records.length; i ++) {
                    if(response.data.data.records[i]['userType'] == false) {
                        response.data.data.records[i]['userType'] = '系统管理员'
                    } else {
                        response.data.data.records[i]['userType'] = '普通用户'
                    }
                }
                that.total = response.data.data.total
                that.tableData = response.data.data.records
            })
            .catch(function(error) {
                console.error(error)
                return that.$message({showClose: true, message:'请求错误', type: 'error'})
            })
        },
        // 监听最新的pageSize
        handleSizeChange(newSize) {
            console.log(`每页 ${newSize} 条`)
            this.rows = newSize
            this.getUserList()
        },
        // 监听页码值的改变
        handleCurrentChange(newPage) {
            console.log(`当前页: ${newPage}`)
            this.page = newPage
            this.getUserList()
        },
    }
}
</script>

<style lang="less" scoped>
div {
    .el-button {
        float: right;
    }
    .el-table {
        width: 100%;
        margin: 10px 0px
    }
}
</style>