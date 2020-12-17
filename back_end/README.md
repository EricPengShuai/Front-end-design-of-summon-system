## demo.jar    ——想知道后端怎么实现

- [x] Java后端用什么框架了吗 springBoost、Mybiast
- [x] 我想知道后端那个分页是怎么实现的，使用框架
- [x] 返回值`code`怎么对应的：自己随便定义的



## 前端问题记录

- [x] 一个困扰我很久的就是那个`z-index`，图片太大了

- [x] 那个`el-option`的`:key`是啥意思



## 后端问题记录

- [x] 获取所有召集令信息（除去自己）
- [x] 时间是不是需要加一个八小时
- [x] 那个添加重复请求之后不应该返回400吧
- [x] 这个请求者ID是自己的ID还是对方的ID
- [x] request部分也需要修改一下时间格式--没有拉取最新的吧
- [x] 等着后端加状态：响应中
- [x] 等着后端完善：召集人数满之后改一下call表状态
- [x] 查询自己所有已经接令的召集令信息；这个需要一个查询state=成功的接口
- [x] 成功召集令的条件查询：起止时间、地域条件

---

- 把中介费用表的数据给三个接口：
- [x] 返回所有数据（分不分页都可以
- [x] 根据起始时间和时间返回数据（不用分页那种了，直接返回所有的
- [x] 根据地域返回数据（不用分页那种了，直接返回所有的

---

- [x] 把管理员登录的token去掉
- [x] 那个web.sql中是callltype不是call_type
- [x] 那个根据用户id查找召集令   /call/pageFind/byUserId/{page}/{rows}/{userId} 有点小问题 找1 时候 10也会被返回
- [x] /request/pageFind/byCall/{page}/{rows}/{callId}  这个没有stateName
- [x] 上传图片不需要token，查看图片需要token
- [x] 图片地址：/Users/pengshuai/Documents/Web/web_develop/myRes/image
- [x] 不是吧，那个管理员登录和那个callltype我醉了



## 版本记录

- demo-0.0.1.jar	——最初cxk版本
- demo-0.0.2.jar    ——加入token版本
- demo-0.0.3.jar    ——加入响应之后版本
- demo-0.0.4.jar    ——修改时间和状态
- demo-0.0.5.jar    ——改一个byCall的bug
- demo-0.0.6.jar    ——增加接口

