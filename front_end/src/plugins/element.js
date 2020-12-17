import Vue from 'vue'
import {
	Button, Form, FormItem, Input, Message,
	Container, Header, Main, Select, Option,
	Aside, Menu, Row, Col, Submenu, MenuItem, 
	MenuItemGroup, MessageBox, Table, TableColumn,
    Breadcrumb, BreadcrumbItem, DatePicker,
    Card,Pagination, Dialog, Upload,
    Tooltip, Badge, Loading, Image
} from 'element-ui'

Vue.use(Button)
Vue.use(Form)
Vue.use(FormItem)
Vue.use(Input)
Vue.use(Container)
Vue.use(Header)
Vue.use(Main)
Vue.use(Select)
Vue.use(Option)
Vue.use(Aside)
Vue.use(Menu)
Vue.use(Submenu)
Vue.use(Row)
Vue.use(Col)
Vue.use(MenuItem)
Vue.use(MenuItemGroup)
Vue.use(Table)
Vue.use(TableColumn)
Vue.use(Breadcrumb)
Vue.use(BreadcrumbItem)
Vue.use(DatePicker)
Vue.use(Card)
Vue.use(Pagination)
Vue.use(Dialog)
Vue.use(Upload)
Vue.use(Tooltip)
Vue.use(Badge)
Vue.use(Image)
Vue.use(Loading)
Vue.prototype.$message = Message
Vue.prototype.$confirm = MessageBox.confirm