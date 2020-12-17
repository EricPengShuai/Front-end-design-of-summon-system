/*
SQLyog Ultimate v12.09 (64 bit)
MySQL - 5.7.32 : Database - web-develop
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`web-develop` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `web-develop`;

/*Table structure for table `call_graph` */

DROP TABLE IF EXISTS `call_graph`;

CREATE TABLE `call_graph` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '仅当主键',
  `graph_location` varchar(255) NOT NULL,
  `call_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4;

/*Data for the table `call_graph` */

insert  into `call_graph`(`id`,`graph_location`,`call_id`) values (1,'图片地址1',12),(2,'图片地址2',12),(3,'图片地址3',13);

/*Table structure for table `call_request` */

DROP TABLE IF EXISTS `call_request`;

CREATE TABLE `call_request` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '请求标识',
  `call_id` bigint(20) DEFAULT NULL COMMENT '召集令标识',
  `user_id` bigint(20) DEFAULT NULL COMMENT '请求用户标识',
  `description` longtext COMMENT '请求描述',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `modify_time` datetime DEFAULT NULL COMMENT '修改时间',
  `state` int(11) DEFAULT NULL COMMENT '状态（0：待处理；1：同意；2：拒绝；3：取消）。',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

/*Data for the table `call_request` */

/*Table structure for table `call_succeed` */

DROP TABLE IF EXISTS `call_succeed`;

CREATE TABLE `call_succeed` (
  `request_id` bigint(20) DEFAULT NULL COMMENT '请求标识',
  `call_id` bigint(20) DEFAULT NULL COMMENT '召集令标识',
  `master_id` bigint(20) DEFAULT NULL COMMENT '令主用户标识',
  `user_id` bigint(20) DEFAULT NULL COMMENT '接令用户标识',
  `completed_time` datetime DEFAULT NULL COMMENT '达成日期',
  `call_fee` bigint(20) DEFAULT NULL COMMENT '令主支付中介费（召集人数*3 元）',
  `user_fee` bigint(20) DEFAULT NULL COMMENT '接令支付中介费（1 元）',
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

/*Data for the table `call_succeed` */

/*Table structure for table `call_type` */

DROP TABLE IF EXISTS `call_type`;

CREATE TABLE `call_type` (
  `call_type_id` bigint(20) NOT NULL COMMENT '召集令类型ID',
  `call_type_name` varchar(255) DEFAULT NULL COMMENT '召集令类型名称',
  PRIMARY KEY (`call_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

/*Data for the table `call_type` */

insert  into `call_type`(`call_type_id`,`call_type_name`) values (1,'技术交流'),(2,'学业探讨'),(3,'发斯蒂芬');

/*Table structure for table `calll` */

DROP TABLE IF EXISTS `calll`;

CREATE TABLE `calll` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '召集令标识',
  `user_id` bigint(20) DEFAULT NULL COMMENT '所属令主用户标识',
  `type_name` varchar(255) DEFAULT NULL COMMENT '召集令类型名称 （1 技术交流、2学业探讨、3社会实践、4公益志愿者、5游玩）',
  `type_id` bigint(20) NOT NULL COMMENT '召集令类型ID （1 技术交流、2学业探讨、3社会实践、4公益志愿者、5游玩）',
  `name` varchar(255) DEFAULT NULL COMMENT '召集令名称',
  `description` longtext COMMENT '召集令描述',
  `people_count` int(11) DEFAULT NULL COMMENT '召集人数',
  `end_time` datetime DEFAULT NULL COMMENT '召集结束日期',
  `intro_picture` varchar(255) DEFAULT NULL COMMENT '召集令介绍照片(url)',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `modify_time` datetime DEFAULT NULL COMMENT '修改时间',
  `state` int(11) DEFAULT NULL COMMENT '状态 已完成0、待响应1、已取消2、到期未达成3，响应中4',
  `people` int(11) DEFAULT NULL COMMENT '已召集人数',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4;

/*Data for the table `calll` */

insert  into `calll`(`id`,`user_id`,`type_name`,`type_id`,`name`,`description`,`people_count`,`end_time`,`intro_picture`,`create_time`,`modify_time`,`state`,`people`) values (12,8,'技术交流',1,'mzhaojiling-1','fsd',1,'2020-12-17 22:04:14',NULL,'2020-12-04 22:04:20','2020-12-04 22:04:20',1,0),(13,7,'社会实践',3,'435er2','uygu',3,'2020-12-31 00:00:00',NULL,'2020-12-04 22:05:37','2020-12-04 22:05:37',1,0),(14,70,'社会实践',3,'FSFSD','fsafsda',2,'2021-01-16 15:38:08',NULL,'2020-12-16 15:38:12','2020-12-05 15:38:16',1,0);

/*Table structure for table `city` */

DROP TABLE IF EXISTS `city`;

CREATE TABLE `city` (
  `city_id` int(20) NOT NULL COMMENT '城市ID',
  `city_name` varchar(255) NOT NULL COMMENT '城市名字',
  PRIMARY KEY (`city_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

/*Data for the table `city` */

insert  into `city`(`city_id`,`city_name`) values (1,'北京'),(2,'上海');

/*Table structure for table `document_type` */

DROP TABLE IF EXISTS `document_type`;

CREATE TABLE `document_type` (
  `document_type_id` varchar(255) NOT NULL COMMENT '证件类型ID',
  `document_type_name` varchar(255) NOT NULL COMMENT '证件类型名',
  PRIMARY KEY (`document_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

/*Data for the table `document_type` */

insert  into `document_type`(`document_type_id`,`document_type_name`) values ('1','身份证'),('2','学生证');

/*Table structure for table `intermediary_income` */

DROP TABLE IF EXISTS `intermediary_income`;

CREATE TABLE `intermediary_income` (
  `date` datetime DEFAULT NULL COMMENT '日期（YYYYMMDD）、',
  `location` varchar(255) DEFAULT NULL COMMENT '地域（省-市）',
  `call_type` int(11) DEFAULT NULL COMMENT '召集令类型',
  `count` int(11) DEFAULT NULL COMMENT '达成笔数',
  `money` bigint(20) DEFAULT NULL COMMENT '中介费收入金额',
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

/*Data for the table `intermediary_income` */

/*Table structure for table `user` */

DROP TABLE IF EXISTS `user`;

CREATE TABLE `user` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '用户标识',
  `username` varchar(255) DEFAULT NULL COMMENT '用户名',
  `password` varchar(255) DEFAULT NULL COMMENT '密码',
  `user_type` bit(1) DEFAULT NULL COMMENT '用户类型（系统管理员 0/普通用户 1）',
  `name` varchar(255) DEFAULT NULL COMMENT '用户姓名',
  `document_type_id` varchar(255) DEFAULT NULL COMMENT '证件类型',
  `document_number` varchar(255) DEFAULT NULL COMMENT '证件号码',
  `phone_number` varchar(255) DEFAULT NULL COMMENT '手机号码(11 位数字)',
  `level` int(11) DEFAULT NULL COMMENT '用户级别(钻石0 重要 1 一般 2)',
  `introduce` longtext COMMENT '用户简介',
  `city_id` int(255) DEFAULT NULL COMMENT '注册城市ID',
  `create_time` datetime DEFAULT NULL COMMENT '注册时间',
  `modify_time` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4;

/*Data for the table `user` */

insert  into `user`(`id`,`username`,`password`,`user_type`,`name`,`document_type_id`,`document_number`,`phone_number`,`level`,`introduce`,`city_id`,`create_time`,`modify_time`) values (1,'admin','admin','\0','范式','1','42342','435425',1,'hfghfdghfg',1,'2020-12-04 22:03:05','2020-12-04 22:03:07'),(7,'123','123123','','12fsd ','IdCard','12345123451234512','17855558888',1,'111',1,'2020-12-04 22:03:37','2020-12-04 22:03:37'),(8,'1234','123123','','psgdfg ','IdCard','12345123451234512','17855558888',1,'111',1,'2020-12-04 22:03:44','2020-12-04 22:03:44');

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
