<template>
    <div style="height: 100%">
        <!-- 面包屑 -->
        <el-breadcrumb separator-class="el-icon-arrow-right" style="margin-bottom: 10px">
            <el-breadcrumb-item :to="{ path: '/welcome' }">首页</el-breadcrumb-item>
            <el-breadcrumb-item>接令者</el-breadcrumb-item>
            <el-breadcrumb-item>所有已经发布的召集令信息</el-breadcrumb-item>
        </el-breadcrumb>
        <!-- 信息主体 -->
        <h2>申请接令</h2>
        <el-card >
            <div id="slectType">
                <span>选择类型</span>
                <el-select v-model="typeId" placeholder="默认展示全部召集令类型" @change="check($event)">
                    <el-option
                        v-for="item in callOption"
                        :key="item.callTypeId"
                        :label="item.callTypeName"
                        :value="item.callTypeId"
                    >
                    </el-option>
                </el-select>
            </div>
            <el-table :data="tableData" :header-cell-style="{'text-align':'center'}" 
                      :cell-style="{'text-align':'center'}" border>
                <el-table-column prop="id" label="召集令标识" width="100"></el-table-column>
                <el-table-column prop="userId" label="发布者ID" width="80"></el-table-column>
                <el-table-column prop="typeName" label="召集令类型" width="120"></el-table-column>
                <el-table-column prop="name" label="召集令名称"></el-table-column>
                <el-table-column prop="stateName" label="召集令状态" width="120"></el-table-column>
                <el-table-column prop="endTime" label="召集结束时间" width="200"></el-table-column>
                <el-table-column label="操作" width="200">
                    <template slot-scope='scope'>
                        <el-button type="primary" @click="checkInfo(scope.row.id)">查看</el-button> 
                        <el-button type="danger" :disabled="!compareTime(scope.row.endTime) || haveRequest[scope.row.id] || isSelf(scope.row.userId) || scope.row.stateName == '已完成'" @click="addRequest(scope.row.id)">申请</el-button>
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

        <!-- 展示召集令详细信息 -->
        <el-dialog title="召集令详情" :visible.sync="infoVisable" width="50%">
            <div>
                <span style="font-size: 20px; margin-right: 10px;">召集令图片</span>
                <el-button type="primary" @click="checkPic()" size="mini" style="margin-bottom: 5px;" icon="el-icon-picture"></el-button>
            </div>
           
            <table style="width: 100%" class="myTable">
                <tr v-for="item in call">
                    <td class="column">{{ item[0] }}</td>
                    <td class="column">{{ item[1] }}</td>
                </tr>
            </table>
            
        </el-dialog>
        <!-- 发起请求 -->
        <el-dialog title="填写请求信息" :visible.sync="requestVisable" width="50%">
            <el-form label-width="120px" style="margin:10px 20px 10px 10px" >
                <el-form-item label="召集令ID">
                    <el-input v-model="request.callId" disabled></el-input>
                </el-form-item>
                <el-form-item label="请求者ID">
                    <el-input v-model="request.userId" disabled></el-input>
                </el-form-item>
                <el-form-item label="请求描述">
                    <el-input type="textarea" v-model="request.description" required></el-input>
                </el-form-item>
            </el-form>
            <span slot="footer" class="dialog-footer">
                <el-button @click="notRequest()">取 消</el-button>
                <el-button type="primary" @click="Request()">确 定</el-button>
            </span>
        </el-dialog>

        <!-- 展示图片 -->
        <el-dialog title="召集令相关图片" :visible.sync="picVisable">
            <el-image v-show="havePic" v-for="url in srcList" :key="url" :src="url" lazy></el-image>
            <span v-show="!havePic">暂无照片</span>
        </el-dialog>
    </div>
</template>

<script>
export default {
    data() {
        return {
            havePic: true,
            picVisable: false,
            srcInitUrl: '',
            srcList: [],
            callOption: [
                { callTypeId: '', callTypeName: '全部类别'}
            ],
            typeId: '',

            tableData: [],          // el-table数据
            page: 1,                // 数据页数
            rows: 10,                // 每页行数
            total: 0,               // 数据总数
            infoVisable: false,     // 详细信息是否可见
            requestVisable: false,  // 请求表单是否可见
            call: [],               // 详细信息数组 
            haveRequest: {},        // 判断是否已经请求，其实这个后端已经完成了
            request: {
                userId: '',
                callId: '',
                description: ''
            },
            url: '',
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
                that.callOption = that.callOption.concat(response.data.data)
            } else {
                that.$message({showClose: true, message: response.data.message, type: 'warning'})
            }
        })
        .catch(function(error) {
            console.log(error)
            that.$message({showClose: true, message: "请求召集令类型列表错误", type: 'error'})
        })
        this.url = `/call/pageFind/${this.page}/${this.rows}`
        this.getConveneList(this.url)
    },
    methods: {
        // 得到所有召集令分页信息
        getConveneList(url) {
            var that = this
            console.log(this.url)
            this.$http.get(url, {
                headers: {
                    'Authorization': window.sessionStorage.getItem('token')
                }
            })
            .then(function(response) {
                that.tableData = response.data.data.records
                that.total = response.data.data.total
            })
            .catch(function(error) {
                console.error(error)
                return that.$message({showClose: true, message:'请求召集令列表错误', type: 'error'})
            })
        },
        // 查询类型变化
        check(e) {
            // 这个很关键，如果this.page >= 2那页可能没有数据
            if (e != 'changeSize') {
                this.page = 1
            }
            if(this.typeId != '') {
                this.url = `/call/pageFind/byType/${this.page}/${this.rows}/${this.typeId}`
                this.getConveneList(this.url)
            } else {
                this.url = `/call/pageFind/${this.page}/${this.rows}`
                this.getConveneList(this.url)
            }
        },
        // 是否自己发布的召集令
        isSelf(id) {
            return id == this.$store.state.user.id
        },
        // 点击显示详细信息按钮展示信息
        checkInfo(id) {
            var that = this
            this.$http.get(`/call/findById/${id}`,{
                                headers: {
                                    'Authorization': window.sessionStorage.getItem('token')
                                }
                            })
            .then(function(response) {
                that.call = new Array(11)
                if (response.data.code == 200) {
                    Object.getOwnPropertyNames(response.data.data).forEach(function(key){
                        switch(key) {
                            case 'id': that.call[0] =['召集令标识', response.data.data[key]]; break;
                            case 'userId': that.call[1] = ['发布者ID', response.data.data[key]]; break;
                            case 'typeName': that.call[2] = ['召集令类型', response.data.data[key]]; break;
                            case 'name': that.call[3] = ['召集令名称', response.data.data[key]]; break;
                            case 'description': that.call[4] = ['召集令描述', response.data.data[key]]; break;
                            case 'people': that.call[5] = ['已召集人数', response.data.data[key]]; break;
                            case 'peopleCount': that.call[6] = ['召集令总人数', response.data.data[key]]; break;
                            case 'endTime': that.call[7] = ['召集结束时间', response.data.data[key]]; break;
                            case 'createTime': that.call[8] = ['召集令创建时间', response.data.data[key]]; break;
                            case 'modifyTime': that.call[9] = ['召集令修改时间', response.data.data[key]]; break;
                            case 'stateName': that.call[10] = ['召集令状态', response.data.data[key]]; break;
                            default: break;
                        }
                    })
                    that.infoVisable = true
                } else {
                    that.$message({showClose: true, message:'没有权限', type: 'error'})
                }
            })
            .catch(function(error) {
                console.error();
                return that.$message({showClose: true, message:'请求错误', type: 'error'})
            })
        },
        // 点击添加请求按钮显示对话框组件
        addRequest(callId) {
            this.requestVisable = true
            this.request.callId = callId
            this.request.userId = this.$store.state.user.id
            this.request.description = ''
        },
        // 点击取消请求或者点击空白处提示信息
        notRequest() {
            this.requestVisable = false
            this.$message({showClose: true, message: '取消请求'})
        },
        // 点击确定请求按钮
        Request() {
            this.requestVisable = false
            this.haveRequest[this.request.callId] = true
            var data = JSON.stringify(this.request);
            var that = this
            var config = {
                method: 'post',
                url: '/request/add',
                headers: { 
                    'Content-Type': 'application/json',
                    'Authorization': window.sessionStorage.getItem('token')
                },
                data : data
            };
            this.$http(config)
            .then(function (response) {
                if (response.data.code == 200) {
                    that.$message({showClose: true, message: response.data.message, type: 'success'})
                    // that.init()
                    console.log("request success！")
                } else {
                    that.$message({showClose: true, message: response.data.message, type: 'warning'})
                }
            })
            .catch(function (error) {
                console.error();
                return that.$message({showClose: true, message:'请求错误', type: 'error'})
            });
        },
        // 时间转换问题 将 2020-02-11T12:24:18.000+0000格式 换成 2020-02-11 12:24:18格式时间
        dateControlFunc(date) {
            function fix(num, length) { // 两位补0
                return ('' + num).length < length ? ((new Array(length + 1)).join('0') + num).slice(-length) : '' + num
            }
            const year = date.getFullYear()
            const month = date.getMonth() + 1
            const day = date.getDate()
            const hour = date.getHours()
            const minutes = date.getMinutes()
            const second = date.getSeconds()
            const updateDate = year + '-' + fix(month, 2) + '-' + fix(day, 2) + ' ' + fix(hour, 2) + ':' + fix(minutes, 2) + ':' + fix(second, 2)
            return updateDate
        },
        // 如果实时的话应该需要socketIO
        compareTime(enddate) {
            var now = this.dateControlFunc(new Date())  // 获取现在时间个结束时间比较
            return enddate >= now;
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
        checkPic() {
            var that = this
            that.havePic = true
            // console.log(this.call)
            this.$http.get('/call/getGraphByCallId/'+this.call[0][1], {
                headers: {
                    'Authorization': window.sessionStorage.getItem('token') 
                }
            }).then(function(response) {
                if(response.data.code != 200) {
                    return that.$message({showClose: true, message: response.data.message, type: 'warning'})
                }
                var data = response.data.data
                if (data.length == 0) {
                    that.havePic = false
                    that.picVisable = true
                    return
                }
                that.srcList = []
                for(var i = 0; i < data.length; ++ i) {
                    that.srcList.push('http://localhost:9998/' + data[i]['graphLocation'])
                }
                that.srcInitUrl = that.srcList[0]
                that.picVisable = true
            }).catch(function(error) {
                console.log(error, '/call/getGraphByCallId/'+this.call.id)
                return that.$message({showClose: true, message: "请求错误", type: 'error'})
            })
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
#slectType {
    > span {
        font-weight: bold;
        margin-right: 10px;
        font-size: 20px;
    }
    > el-select {
        margin: 0px 0px 10px 5px;
    }
}


</style>