<template>
    <div style="height: 100%">
        <!-- 面包屑 -->
        <el-breadcrumb separator-class="el-icon-arrow-right" style="margin-bottom: 10px">
            <el-breadcrumb-item :to="{ path: '/welcome' }">首页</el-breadcrumb-item>
            <el-breadcrumb-item>查询成功请求信息</el-breadcrumb-item>
        </el-breadcrumb>
        <!-- 信息主体 -->
        <h2>中介费用明细表</h2>
        <el-card>
            <div class="selectTimeblock">
                <el-date-picker
                    v-model="value"
                    type="daterange"
                    range-separator="至"
                    start-placeholder="开始日期"
                    end-placeholder="结束日期"
                    value-format="yyyy-MM-dd">
                </el-date-picker>
                <el-button type="primary" @click="checkFee('byDate')" :disabled="!value">查询</el-button>
                <el-select v-model="city" placeholder="请选择查询城市" >
                    <!-- 动态获取城市类型下拉列表 -->
                    <el-option
                        v-for="item in cityOption"
                        :key="item.cityId"
                        :label="item.cityName"
                        :value="item.cityName"
                    >
                    </el-option>
                </el-select>
                <el-button type="primary" @click="checkFee('byLocation')" :disabled="!value || this.city == ''">指定城市查询</el-button>
            </div>
            <el-table :data="tableData" :header-cell-style="{'text-align':'center'}" 
                      :cell-style="{'text-align':'center'}" border>
                <el-table-column prop="date" label="时间" width="150"></el-table-column>
                <el-table-column prop="type" label="类型" width="100"></el-table-column>
                <el-table-column prop="fee" label="中介费用" sortable width="150"></el-table-column>
                <el-table-column prop="count" label="成交单数" sortable width="150"></el-table-column>
                <el-table-column prop="zone" label="地区" width="100"></el-table-column>
            </el-table>
        </el-card>
        <div id="chart_example">
        </div>
        <div id="chartCnt_example">
        </div>
    </div>
</template>

<script>
import * as echarts from 'echarts'
export default {
    data() {
        return {
            value: [],          // 时间范围
            cityOption: [
                // {
                //     "cityId": 1,
                //     "cityName": "北京"
                // },
                // {
                //     "cityId": 2,
                //     "cityName": "上海"
                // }
            ],     // 城市选择
            city: '',           // 所选城市
            month: [],          // 超过30天改成统计月份

            tableData: [],          // el-table数据
            page: 1,                // 数据页数
            rows: 10,               // 每页行数
            total: 0,               // 数据总数

            option: {},
            optionCnt: {},
            // type: ['技术交流', '学业探讨', '社会实践', '公益志愿者', '游玩'],
            type: [],
            color: ['#85adad', '#FA6F53', '#99b3ff', '#ffff80', '#ffcc80'],
            series: [],
            seriesCnt: [],
            myChart: '',
            myChartCnt: '',
        }
    },
    created() {
        this.getCityList()
        var that = this
        this.$http.get("/call/getCallType", {
                headers: {
                    'Authorization': window.sessionStorage.getItem('token') 
                }
        })
        .then(function(response) {
            if (response.data.code == 200) {
                for(var i = 0; i < response.data.data.length; i++) {
                    that.type.push(response.data.data[i]['callTypeName'])
                }
            } else {
                that.$message({showClose: true, message: response.data.message, type: 'warning'})
            }
        })
        .catch(function(error) {
            console.log(error)
            that.$message({showClose: true, message: "请求召集令类型列表错误", type: 'error'})
        })
        
        this.value[0] = this.getDate(-3)
        this.value[1] = this.getDate(3)
        // 指定图表的配置项和数据
        for (var i = 0; i < 5; ++ i) {
            this.series[i] = {
                name: this.type[i],
                type: 'line',
                lineStyle: { color: this.color[i] }
            }
        }
        this.option = {
            title: {
                text: '所有城市中介费用随着时间变化折线图',
                x: 'center',
                y: 'top',
                textAlign: 'left',
                textStyle: {"fontSize": 18,"fontWeight": "bolder","color": "#333"} 
            },
            tooltip: {              //设置tip提示
                trigger: 'axis'
            },
            legend: {               
                data: this.type,     //设置区分（哪条线属于什么）和color对应
                bottom: '0'
            },
            color: this.color,      
            xAxis: {                //设置x轴
                boundaryGap: false,     //坐标轴两边不留白
                data: [],
                name: '日期',           //X轴 name
                nameTextStyle: {        //坐标轴名称的文字样式
                    color: '#FA6F53',
                    fontSize: 16,
                    padding: [0, 0, 0, 20]
                },
                axisLine: {             //坐标轴轴线相关设置。
                    lineStyle: {
                        color: '#FA6F53',
                    }
                },
                type: 'category'
            },
            yAxis: {
                name: '中介费',
                nameTextStyle: {
                    color: '#FA6F53',
                    fontSize: 16,
                    padding: [0, 0, 10, 0]
                },
                axisLine: {
                    lineStyle: {
                        color: '#FA6F53',
                    },
                    show: true,
                },
                type: 'value'
            },
            series: this.series
        },
        // 涉及到深拷贝和浅拷贝问题
        this.optionCnt = JSON.parse(JSON.stringify(this.option))
        this.optionCnt['yAxis']['name'] = '成交单数'
        this.optionCnt['title']['text'] = '所有城市成交单数随时间变化折线图'
    },
    async mounted() {
        this.myChart = echarts.init(document.getElementById('chart_example'));
        
        this.myChartCnt = echarts.init(document.getElementById('chartCnt_example'));

        this.checkFee('byDate')
        console.log('mounted', this.tableData)

        /* if (window.sessionStorage.getItem('option') != null) {
            this.option = JSON.parse(window.sessionStorage.getItem('option'))
        } */
        this.myChart.setOption(this.option);
        window.addEventListener('resize',function() {this.myChart.resize()});
        
        /* if (window.sessionStorage.getItem('optionCnt') != null) {
            this.optionCnt = JSON.parse(window.sessionStorage.getItem('optionCnt'))
        } */
        this.myChartCnt.setOption(this.optionCnt);
        // 建议加上以下这一行代码，不加的效果图如下（当浏览器窗口缩小的时候）。超过了div的界限（红色边框）
        window.addEventListener('resize',function() {this.myChartCnt.resize()});
    },
    methods: {
        // 获取当前前几天后者后几天日期
        getDate(day) {
            function doHandleMonth(month){
                var m = month;
                if(month.toString().length == 1){
                    m = "0" + month;
                }
                return m;
            }
            var today = new Date();
            var targetday_milliseconds=today.getTime() + 1000*60*60*24*day;
            today.setTime(targetday_milliseconds); //注意，这行是关键代码
            var tYear = today.getFullYear();
            var tMonth = today.getMonth();
            var tDate = today.getDate();
            tMonth = doHandleMonth(tMonth + 1);
            tDate = doHandleMonth(tDate);
            return tYear+"-"+tMonth+"-"+tDate;
        },
        async checkFee(flag) {
            function show(ymd) {
                console.log(ymd)
            }
            this.option['xAxis'].data = []
            this.optionCnt['xAxis'].data = []
            this.month.length = 0
            
            var i = 0;
            var start = new Date(this.value[0]);
            var end = new Date(this.value[1]);
            do {
                // show(start.getFullYear()+"-"+(start.getMonth()+1)+"-"+start.getDate());
                var m = start.getFullYear()+"-"+(start.getMonth()+1);
                if (this.month.indexOf(m) == -1) {
                    this.month.push(m)
                    console.log(start.getMonth())
                }
                this.option['xAxis'].data.push(start.getFullYear()+"-"+(start.getMonth()+1)+"-"+start.getDate())
                this.optionCnt['xAxis'].data.push(start.getFullYear()+"-"+(start.getMonth()+1)+"-"+start.getDate())
                ++ i;
                start.setDate(start.getDate()+1);
            } while(end >= start);

            
            console.log(flag+ ' checkFee() days', i, this.month)
            var that = this
            if (flag == 'byDate') {
                if (i <= 30) {
                    var response  = await this.$http.get(`/income/getIncomeByDayTimeByType/${this.value[0]}/${this.value[1]}`, {
                        headers: {
                            'Authorization': window.sessionStorage.getItem('token')
                        }
                    })
                } else {
                    this.option['xAxis'].data = this.month
                    this.optionCnt['xAxis'].data = this.month
                    var response  = await this.$http.get(`/income/getIncomeByMonthTimeByType/${this.month[0]}/${this.month[this.month.length - 1]}`, {
                        headers: {
                            'Authorization': window.sessionStorage.getItem('token')
                        }
                    })
                    console.log(this.month)
                }
                this.city = ''
                this.option['title']['text'] = '中介费用随时间变化折线图'
                this.optionCnt['title']['text'] = '成交单数随时间变化折线图'
            } else if (flag == 'byLocation') {
                if (i <= 30) {
                    var response  = await this.$http.get(`/income/getIncomeByDayTimeByLocation/${this.value[0]}/${this.value[1]}/${this.city}`, {
                        headers: {
                            'Authorization': window.sessionStorage.getItem('token')
                        }
                    })
                } else {
                    this.option['xAxis'].data = this.month
                    this.optionCnt['xAxis'].data = this.month
                    var response  = await this.$http.get(`/income/getIncomeByMonthTimeByLocation/${this.month[0]}/${this.month[this.month.length - 1]}/${this.city}`, {
                        headers: {
                            'Authorization': window.sessionStorage.getItem('token')
                        }
                    })
                }
                this.option['title']['text'] = this.city + '的中介费用随时间变化折线图'
                this.optionCnt['title']['text'] = this.city + '的成交单数随时间变化折线图'
            }
            
            if (response.data.code != 200) {
                return that.$message({showClose: true, message: response.data.message, type: 'warning'})
            } else {
                var res = response.data.data
                var days = res.length
                this.series = new Array(5)
                for (var i = 0; i < 5; ++ i) {
                    var data = new Array(days).fill(0)
                    this.series[i] = {
                        name: this.type[i],
                        data: data,
                        type: 'line',
                        lineStyle: { color: this.color[i] }
                    }
                    var dataCnt = new Array(days).fill(0)
                    this.seriesCnt[i] = {
                        name: this.type[i],
                        data: dataCnt,
                        type: 'line',
                        lineStyle: { color: this.color[i] }
                    }
                }
                this.tableData = []
                for(var i = 0; i < res.length; ++ i) {  // 第i天
                    var fee = 0
                    var cnt = 0
                    for(var j = 0; j < res[i].length; ++ j) {   // 是res[i][j]['name']类
                        var kind = this.type.indexOf(res[i][j]['name'])
                        this.series[kind]['data'][i] = res[i][j]['money']
                        fee += res[i][j]['money']
                        
                        var kind = this.type.indexOf(res[i][j]['name'])
                        this.seriesCnt[kind]['data'][i] = res[i][j]['count']
                        cnt += res[i][j]['count']
                    }
                    if (this.city == '') {
                        var zone = '所有城市'
                    } else {
                        var zone = this.city
                    }
                    this.tableData.push({
                        'date': this.option['xAxis'].data[i],
                        'type': '所有类型',
                        'fee': fee,
                        'count': cnt,
                        'zone': zone
                    })
                }
                console.log(this.tableData)
                this.option['series'] = this.series
                this.optionCnt['series'] = this.seriesCnt
                this.drawChart()
            }  
        },
        getCityList() {
            var that = this
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
            })
        },
        // echarts
        drawChart() {
            this.myChart.setOption(this.option);
            this.myChartCnt.setOption(this.optionCnt);

            /* window.sessionStorage.setItem('option', JSON.stringify(this.option))
            window.sessionStorage.setItem('optionCnt', JSON.stringify(this.optionCnt))
            window.sessionStorage.setItem('startTime', this.value[0])
            window.sessionStorage.setItem('endTime', this.value[1])
            window.sessionStorage.setItem('city', this.city) */
        }
    }
    
}
</script>

<style lang="less" scoped>
h2 {
    text-align: center;
    // padding: 30px;
    // font-size: 18px;
}

.selectTimeblock {
    margin-bottom: 10px;
    > .el-button {
        margin-left: 5px;
    }
    > .el-select {
        margin-left: 5px;
    }
}

.el-table {
    width: 650px;
}

#chart_example{
    width: 50%;
    height: 500px;
    // border: 1px solid red;
    margin: 0 auto;
    float: left;
    margin-top: 20px;
}

#chartCnt_example{
    width: 50%;
    height: 500px;
    // border: 1px solid red;
    margin: 0 auto;
    float: right;
    margin-top: 20px;
}
</style>