<template>
    <div style="height: 100%">
        <!-- 面包屑 -->
        <el-breadcrumb separator-class="el-icon-arrow-right" style="margin-bottom: 10px">
            <el-breadcrumb-item :to="{ path: '/welcome' }">首页</el-breadcrumb-item>
            <el-breadcrumb-item>令主</el-breadcrumb-item>
            <el-breadcrumb-item>所有已经发布召集令信息</el-breadcrumb-item>
        </el-breadcrumb>
        <!-- 信息主体 -->
        <h2>召集令信息</h2>
        <el-card>
            <el-table :data="tableData" :header-cell-style="{'text-align':'center'}" 
                      :cell-style="{'text-align':'center'}" 
                      v-loading="loading" border>
                <el-table-column prop="id" label="召集令标识" width="100">
                </el-table-column>
                <el-table-column prop="userId" label="发布者ID" width="80">
                </el-table-column>
                <el-table-column prop="typeName" label="召集令类型" width="120">
                </el-table-column>
                <el-table-column prop="name" label="召集令名称" width="120">
                </el-table-column>
                <el-table-column prop="description" label="召集令描述" width="200">
                </el-table-column>
                <el-table-column prop="people" label="已召集人数" width="100">
                </el-table-column>
                <el-table-column prop="peopleCount" label="召集人数" width="80">
                </el-table-column>
                <el-table-column prop="endTime" label="召集结束时间" width="180">
                </el-table-column>
                <el-table-column label="描述照片" width="100">
                    <template slot-scope='scope'>
                        <el-button type="primary" icon="el-icon-picture" @click="showPic(scope.row.id)"></el-button>
                    </template>
                </el-table-column>
                <el-table-column prop="createTime" label="发布时间" width="180">
                </el-table-column>
                <el-table-column prop="modifyTime" label="修改时间" width="180">
                </el-table-column>
                <el-table-column prop="stateName" label="召集令状态" width="100">
                </el-table-column>
                <el-table-column label="操作" width="180">
                    <template slot-scope='scope'>
                        <el-button type="primary" :disabled="scope.row.people != 0 || !dateControlFunc(scope.row.endTime)" @click="addEditVisable(scope.row.id)">编辑</el-button>
                        <el-button type="danger" :disabled="scope.row.people != 0" @click="addDeleteVisable(scope.row.id)">删除</el-button>
                    </template>
                </el-table-column>
                <el-table-column label="申请列表" width="100">
                    <template slot-scope='scope'>
                        <!-- <el-badge :is-dot="newRequest[scope.row.id]" style="margin-top: 5px"> -->
                        <el-badge :value="newRequest[scope.row.id]" :max="10" :hidden="!newRequest[scope.row.id]" style="margin-top: 9px; margin-right: 2px;">
                            <el-button type="info" icon="el-icon-menu" size="min" @click="addRequestVisable(scope.row.id)" ></el-button>
                        </el-badge>
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
                <el-button type="primary" @click="addConvene()" size="medium" style="margin: 5px; float: right">添加召集令</el-button>
                <el-button type="primary" @click="myClick()" size="medium" style="margin: 5px;" v-if="flush" v-clickDown>刷新页面</el-button>
            </div>
        </el-card>

        <!-- 修改界面对话框 -->
        <el-dialog title="修改召集令信息" :visible.sync="editVisable" width="50%">
            <el-form label-width="120px" style="margin:10px 20px 10px 10px" >
                <el-form-item label="召集令id">
                    <el-input v-model="call.id" disabled></el-input>
                </el-form-item>
                <el-form-item label="召集令类型">
                    <el-select v-model="call.typeName" placeholder="请选择召集令类型">
                    <el-option
                        v-for="item in callTypeOption"
                        :key="item.callTypeId"
                        :label="item.callTypeName"
                        :value="item.callTypeName"
                    >
                    </el-option>
                </el-select>
                </el-form-item>
                <el-form-item label="召集令名称">
                    <el-input v-model="call.name"></el-input>
                </el-form-item>
                <el-form-item label="召集令描述">
                    <el-input v-model="call.description"></el-input>
                </el-form-item>
                <el-form-item label="召集人数">
                    <el-input v-model="call.peopleCount"></el-input>
                </el-form-item>
                <el-form-item label="描述照片">
                    
                    <el-upload
                        :action="getImageUrl()"
                        list-type="picture-card"
                        :limit="3"
                        :on-exceed="handleExceed"
                        :on-preview="handlePictureCardPreview"
                        :on-success="handleSuccess"
                        :on-error="handleFail"
                        :auto-upload="true"
                        :file-list="fileList"
                        accept=".png, .jpg, .jpeg, .gif"
                        ref="upload">
                        <i slot="default" class="el-icon-plus"></i>
                        <div slot="file" slot-scope="{file}">
                        <img class="el-upload-list__item-thumbnail" :src="file.url" alt="" >
                            <span class="el-upload-list__item-actions">
                                <span class="el-upload-list__item-preview" @click="handlePictureCardPreview(file)" >
                                    <i class="el-icon-zoom-in"></i>
                                </span>
                                <span class="el-upload-list__item-delete" @click="handleRemove(file)" >
                                    <i class="el-icon-delete"></i>
                                </span>
                            </span>
                        </div>
                    </el-upload>
                    <el-dialog :visible.sync="previewVisible">
                        <img width="100%" :src="preImageUrl" alt="">
                    </el-dialog>
                </el-form-item>
                <el-form-item label="召集结束日期" required>
                    <el-col :span="11">
                        <el-form-item >
                            <el-date-picker value-format="yyyy-MM-dd HH:mm:ss" type="datetime" :picker-options="expireTimeOption" placeholder="选择日期" v-model="call.endTime" style="width: 100%;"></el-date-picker>
                        </el-form-item>
                    </el-col>
                </el-form-item>
            </el-form>
            <span slot="footer" class="dialog-footer">
                <el-button @click="notEdit()">取 消</el-button>
                <el-button type="primary" @click="edit()">确 定</el-button>
            </span>
        </el-dialog>

        <el-dialog title="申请信息列表" :visible.sync="requestVisable" width="77%">
            <el-table :data="requestData" :header-cell-style="{'text-align':'center'}" 
                      :cell-style="{'text-align':'center'}" border>
                <el-table-column prop="id" label="请求标识" width="100"></el-table-column>
                <el-table-column prop="callId" label="召集令ID" width="100"></el-table-column>
                <!-- 这里是不是需要加一个请求者姓名什么的 -->
                <el-table-column prop="userId" label="请求者ID" width="100"></el-table-column>
                <el-table-column prop="description" label="请求描述" width="250"></el-table-column>
                <el-table-column prop="createTime" label="创建请求时间" width="180"></el-table-column>
                <el-table-column prop="modifyTime" label="修改请求时间" width="180"></el-table-column>
                <el-table-column prop="state" label="状态" width="100"></el-table-column>
                <el-table-column label="操作" width="300">
                    <template slot-scope='scope'> 
                        <el-button type="danger" :disabled="scope.row.state != '待处理'" @click="agreeRequest(scope.row.id, scope.row.callId)">同意</el-button>
                        <el-button type="danger" :disabled="scope.row.state != '待处理'" @click="rejectRequest(scope.row.id, scope.row.callId)">拒绝</el-button>
                        <el-button type="primary" @click="checkInfo(scope.row.userId)">请求者信息</el-button>
                    </template>
                </el-table-column>
            </el-table>
        </el-dialog>

        <!-- 展示个人信息 -->
        <el-dialog title="请求者信息" :visible.sync="infoVisable" width="50%">
            <table style="width: 100%" class="myTable">
                <tr v-for="item in userInfo">
                    <td class="column" v-if="item">{{ item[0] }}</td>
                    <td class="column" v-if="item">{{ item[1] }}</td>
                </tr>
            </table>
        </el-dialog>

        <!-- 展示图片 -->
        <el-dialog title="召集令相关图片" :visible.sync="picVisable">
            <!-- <el-image v-show="havePic"
                style="width: 100px; height: 100px"
                :src="srcInitUrl" 
                :preview-src-list="srcList">
            </el-image> -->
            <el-image v-show="havePic" v-for="url in srcList" :key="url" :src="url" lazy></el-image>
            <span v-show="!havePic">暂无照片</span>
        </el-dialog>
        <el-dialog title="提示信息" :visible.sync="helpVisable" center width="30%">
            <h2 style="text-align: center;">刷新成功</h2>
        </el-dialog>
    </div>
</template>

<script>
import Axios from 'axios';
export default {
    data() {
        return {
            // 照片相关
            preImageUrl: '',
            previewVisible: false,
            fileList: [],
            baseUrl: 'http://localhost:9998/call/upload/',
            picVisable: false,
            srcInitUrl: '',
            srcList: [],
            disabled: false,
            havePic: true,

            tableData: [],  // el-table数据
            requestData: [],// 请求信息表格
            page: 1,        // 数据页数
            rows: 10,        // 每页行数
            total: 0,       // 数据总数
            editVisable: false,
            requestVisable: false,
            helpVisable: false,
            infoVisable: false,
            userInfo: [],
            loading: false,
            flush: true,
            // 修改召集令表单
            callTypeOption: [],
            call: {
                id: '',
                userId: '',
                typeName: '',
                name: '',
                description: '',
                peopleCount: '',
                introPicture: '',
                state: '',
                stateName: '',
                endTime: ''
            },
            expireTimeOption: {
                disabledDate(date) {
                    return date.getTime() <= Date.now();
                }
            },
            ids: [],        // 记录召集令的id
            newRequest: {}, // 记录某条召集令是否有新的请求
            timer: null,
        }
    },
    // 自动点击刷新按钮
    directives: {
        clickDown: {
            inserted(el) {
                el.click()
            }
        }
    },
    computed: {
        headers() {
           return{
                "Authorization": window.sessionStorage.getItem('token') // 直接从本地获取token就行
            }
        }
    },
    created() {
        this.init()
        console.log('created myConvene')
    },
    async mounted() {
        var axios = require('axios')
        // 获取所有的callIds，这个axios的异步特性真的害死我
        let response = await this.$http.get('call/pageFind/byUserId/1/20/'+this.$store.state.user.id, {
                            headers: {
                                'Authorization': window.sessionStorage.getItem('token')
                            }
                        })
        
        for(var i = 0; i < response.data.data.records.length; i ++) {
            var id = response.data.data.records[i]['id']
            if (this.ids.indexOf(id) == -1) {
                this.ids.push(id)
            }
        }
        
        this.helpNewRequest()
        console.log("mounted myConvene")
    },
    methods: {
        // 辅助刷新显示红点
        myClick() {
            // this.helpVisable = true
            this.loading = true
            console.log("自动触发")
            this.flush = false
            clearTimeout(this.timer);  //清除延迟执行 
            this.timer = setTimeout(()=>{   //设置延迟执行
                // this.helpVisable = false
                this.loading = false
            },500);
            /* clearTimeout(this.timer);  //清除延迟执行 
            this.timer = setTimeout(()=>{   //设置延迟执行
                this.helpVisable = true
                this.loading = false
            },1000); */
        },
        dateControlFunc(enddate) {
            function fix(num, length) { // 两位补0
                return ('' + num).length < length ? ((new Array(length + 1)).join('0') + num).slice(-length) : '' + num
            }
            var date = new Date()
            const year = date.getFullYear()
            const month = date.getMonth() + 1
            const day = date.getDate()
            const hour = date.getHours()
            const minutes = date.getMinutes()
            const second = date.getSeconds()
            const updateDate = year + '-' + fix(month, 2) + '-' + fix(day, 2) + ' ' + fix(hour, 2) + ':' + fix(minutes, 2) + ':' + fix(second, 2)
            // 获取现在时间个结束时间比较
            return enddate >= updateDate;
        },
        // 初始化表格信息
        init() {
            var that = this
            this.$http.get('call/pageFind/byUserId/'+ this.page+'/'+ this.rows+'/'+this.$store.state.user.id, {
                                headers: {
                                    'Authorization': window.sessionStorage.getItem('token')
                                }
                            })
            .then(function(response) {
                // console.log('convene_show', response.data.data);
                that.tableData = response.data.data.records
                that.total = response.data.data.total
            })
            .catch(function(error) {
                console.log(error)
                return that.$message({showClose: true, message:'请求错误', type: 'error'})
            })
        },
        // 点击修改召集令按钮显示组件
        addEditVisable(id) {
            var that = this
            // 获取召集令类型列表
            this.$http.get("/call/getCallType", {
                    headers: {
                        'Authorization': window.sessionStorage.getItem('token') 
                    }
            })
            .then(function(response) {
                if (response.data.code == 200) {
                    that.callTypeOption = response.data.data
                } else {
                    that.$message({showClose: true, message: response.data.message, type: 'warning'})
                }
            })
            .catch(function(error) {
                console.log(error)
                that.$message({showClose: true, message: "请求错误", type: 'error'})
            })

            // 获取这个召集令的基本信息
            this.$http.get(`/call/findById/${id}`,{
                                headers: {
                                    'Authorization': window.sessionStorage.getItem('token')
                                }
                            })
            .then(function(response) { 
                if (response.data.code == 200) {
                    that.call = response.data.data 
                    that.getImageList()  // 获取该召集令已经上传的图片
                    that.editVisable = true
                } else {
                    that.$message({showClose: true, message:'没有权限', type: 'error'})
                }
            })
            .catch(function(error) {
                console.error();
                return that.$message({showClose: true, message:'请求错误', type: 'error'})
            })
        },
        // 点击取消修改或者点击空白处提示信息
        notEdit() {
            this.editVisable = false
            this.$message({showClose: true, message:'取消修改'})
        },
        // 点击确定修改召集令按钮
        edit() {
            this.editVisable = false
            // console.log(this.call.endTime, 666)
            var data = JSON.stringify(this.call);
            var that = this
            var config = {
                method: 'post',
                url: '/call/modify',
                headers: { 
                    'Content-Type': 'application/json',
                    'Authorization': window.sessionStorage.getItem('token')
                },
                data : data
            };
            this.$http(config)
            .then(function (response) {
                if (response.data.code == 200) {
                    // that.$refs.upload.submit()
                    that.$message({showClose: true, message:'修改成功', type: 'success'})
                    that.init()
                } else {
                    that.$message({showClose: true, message:'修改失败', type: 'warning'})
                }
            })
            .catch(function (error) {
                console.error();
                return that.$message({showClose: true, message:'请求错误', type: 'error'})
            });
        },
        // 点击添加召集令按钮跳转页面
        addConvene() {
            this.$store.commit('call/set_activeNav', '/convene')
            this.$router.push('/convene')
        },
        // 点击删除按钮显示组件
        addDeleteVisable(id) {
            var that = this
            this.$confirm('是否删除此召集令?', '警告', {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'warning',
                center: true
            })
            .then(() => {
                console.log(id, 'makesure delete')
                var config = {
                    method: 'post',
                    url: '/call/delById/'+id,
                    headers: { 
                        'Content-Type': 'application/json',
                        'Authorization': window.sessionStorage.getItem('token')
                    },
                };
                this.$http(config)
                .then(function (response) {
                    if (response.data.code == 200) {
                        that.$message({ showClose: true, message: response.data.message, type: 'success' })
                        that.init()
                    } else {
                        that.$message({ showClose: true, message: response.data.message, type: 'warning' })
                    }
                })
                .catch(function (response) {
                    that.$message({ showClose: true, message: response.data.message, type: 'error' })
                })
            })
            .catch(() => {
                this.$message({ showClose: true,  message: '已取消删除', type: 'info' });
            });
        },
        async helpNewRequest() {
            // 判断是否有新的请求
            for (var id of this.ids) {
                var axios = require('axios')
                var response = await axios.get('/request/pageFind/byCall/1/20/'+id, {
                                    headers: {
                                        'Authorization': window.sessionStorage.getItem('token')
                                    }
                                })
                var flag = 0
                // this.newRequest[id] = false
                for(var i = 0; i < response.data.data.records.length; i ++) {
                    if (response.data.data.records[i]['state'] == 0) {
                        /* this.newRequest[id] = true
                        break */
                        ++ flag;
                    }
                }
                /* if (flag == 0) {
                    this.newRequest[id] = flag
                }  */
                this.newRequest[id] = flag
            }
            console.log('helpNewRequest()', this.ids, this.newRequest)
        },
        // 点击查看申请列表按钮
        addRequestVisable(id) {
            this.requestVisable = true
            var that = this
            this.$http.get('/request/pageFind/byCall/1/10/'+id, {
                                headers: {
                                    'Authorization': window.sessionStorage.getItem('token')
                                }
                            })
            .then(function(response) {
                if (response.data.code != 200) {
                    return that.$message({showClose: true, message: response.data.message, type: 'warning'})
                }
                // console.log(response.data.data.records[0]['state'])
                var flag = response.data.data.records.length
                for(var i = 0; i < response.data.data.records.length; i ++) {
                    switch (response.data.data.records[i]['state']) {
                        case 0:
                            response.data.data.records[i]['state'] = "待处理";
                            break;
                        case 1:
                            response.data.data.records[i]['state'] = "同意";
                            -- flag; break;
                        case 2:
                            response.data.data.records[i]['state'] = "拒绝";
                            -- flag; break;
                        case 3:
                            response.data.data.records[i]['state'] = "取消";
                            -- flag; break;
                        default:
                            break;
                    }
                }
                that.requestData = response.data.data.records
                // 如果申请列表中没有待处理的条目就 去掉红点/改变数值
                /* if (flag == 0) {
                    that.newRequest[id] = false
                }  */
                that.newRequest[id] = flag
            })
            .catch(function(error) {
                console.log(error)
                return that.$message({showClose: true, message:'请求错误', type: 'error'})
            })
        },
        // 同意请求之后
        agreeRequest(id, callId) {
            var axios = require('axios');
            var data = JSON.stringify({"id":id, "state":1});

            var config = {
                method: 'post',
                url: '/request/modifyState',
                headers: { 
                    'Authorization': window.sessionStorage.getItem('token'), 
                    'Content-Type': 'application/json'
                },
                data : data
            };

            var that = this
            axios(config)
            .then(function (response) {
                console.log(response.data)
                that.init() // 为了显示人数变化所以需要重新加载页面
                that.addRequestVisable(callId)
            })
            .catch(function (error) {
                console.log(error)
                return that.$message({showClose: true, message:'请求错误', type: 'error'})
            });
        },
        // 拒绝请求之后
        rejectRequest(id, callId) {
            var axios = require('axios');
            var data = JSON.stringify({"id":id,"state":2});

            var config = {
                method: 'post',
                url: '/request/modifyState',
                headers: { 
                    'Authorization': window.sessionStorage.getItem('token'), 
                    'Content-Type': 'application/json'
                },
                data : data
            };

            var that = this
            axios(config)
            .then(function (response) {
                console.log(response.data)
                // that.init()  // 拒绝之后没有人数变化
                that.addRequestVisable(callId)
            })
            .catch(function (error) {
                console.log(error)
                return that.$message({showClose: true, message:'请求错误', type: 'error'})
            });
        },
        // 监听最新的pageSize
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
        // 查看请求者个人信息
        checkInfo(userId) {
            var that = this
            this.$http.get(`/user/getById/${userId}`,{
                                headers: {
                                    'Authorization': window.sessionStorage.getItem('token')
                                }
                            })
            .then(function(response) {
                that.userInfo = new Array(7)
                if (response.data.code == 200) {
                    Object.getOwnPropertyNames(response.data.data).forEach(function(key){
                        // console.log(key, '---', response.data.data[key])
                        switch(key) {
                            case 'id': that.userInfo[0] =['用户ID', response.data.data[key]]; break;
                            case 'username': that.userInfo[1] = ['用户名', response.data.data[key]]; break;
                            case 'name': that.userInfo[2] = ['用户名称', response.data.data[key]]; break;
                            case 'phoneNumber': that.userInfo[3] = ['手机号', response.data.data[key]]; break;
                            case 'levelName': that.userInfo[4] = ['用户级别', response.data.data[key]]; break;
                            case 'introduce': that.userInfo[5] = ['用户简介', response.data.data[key]]; break;
                            case 'cityName': that.userInfo[6] = ['所在城市', response.data.data[key]]; break;
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
        // 获取已存在的图片
        getImageList() {
            var that = this
            this.$http.get('/call/getGraphByCallId/'+this.call.id, {
                headers: {
                    'Authorization': window.sessionStorage.getItem('token') 
                }
            }).then(function(response) {
                if(response.data.code != 200) {
                    return that.$message({showClose: true, message: response.data.message, type: 'warning'})
                }
                var data = response.data.data
                that.fileList = data
                // 'http://localhost:9998/'
                for(var i = 0; i < data.length; ++ i) {
                    that.fileList[i]['url'] = 'http://localhost:9998/' + data[i]['graphLocation']
                    // that.fileList[i]['name'] = 'http://localhost:9998/' + data[i]['graphLocation']
                }
                // console.log(that.fileList)
            }).catch(function(error) {
                console.log(error, '/call/getGraphByCallId/'+this.call.id)
                return that.$message({showClose: true, message: "请求错误", type: 'error'})
            }) 
        },
        // 上传图片地址
        getImageUrl() {
            var url = String(this.baseUrl + this.call.id);
            // console.log('getImageUrl', url)
            return url
        },
        // 处理照片相关
        showPic(id) {
            var that = this
            that.havePic = true
            this.$http.get('/call/getGraphByCallId/'+id, {
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
        handleExceed(file) {
            this.$message.warning(`当前限制选择 3 张图片`)
        },
        handleRemove(file) {
            console.log('removing', file.url)
            this.$confirm("确定移除所选图片？", '警告', {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'warning',
                center: true
            })
            .then(() => {
                console.log('同意删除')
                for(var i = 0; i < this.fileList.length; ++ i) {
                    if ( this.fileList[i].url == file.url) {
                        this.fileList.splice(i, 1)
                        break
                    }
                }
                var that = this
                var qs = require('qs');
                var data = qs.stringify({
                    'location': file.graphLocation
                    });
                var config = {
                    method: 'post',
                    url: '/call/delGraphByLocation',
                    headers: { 
                        'Authorization': window.sessionStorage.getItem('token'), 
                        'Content-Type': 'application/x-www-form-urlencoded'
                    },
                    data : data
                };
                this.$http(config)
                .then(function(response) {
                    if (response.data.code == 200) {
                        that.$message({showClose: true, message: response.data.message, type: 'success'})
                    } else {
                        that.$message({showClose: true, message: response.data.message, type: 'warning'})
                    }
                })
                .catch(function(error) {
                    console.log(error)
                    return that.$message({showClose: true, message: "请求错误", type: 'error'})
                })
            })
            .catch(() => {
                console('取消删除buging')
                return this.$message({showClose: true, message: "取消删除", type: 'info'})
            })
        },
        handlePictureCardPreview(file) {
            this.preImageUrl = file.url;
            this.previewVisible = true;
            console.log("preview", file.url)
        },
        handleSuccess(res, file) {
            console.log('success', res, file.url)
            this.fileList.push(res.data)
            this.fileList[this.fileList.length - 1]['url'] = 'http://localhost:9998/' + res.data['graphLocation']
            this.$message.success('上传图片成功！')
            console.log(this.fileList)
        },
        handleFail(res, file) {
            console.log('error', res, file.url)
            this.$message.warning('上传图片失败！')
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