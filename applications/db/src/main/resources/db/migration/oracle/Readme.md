##### 程序运行之前推荐提前创建用户jwposp和表空间jwposp,操作流程如下：

* 将下列创建表空间和用户SQL代码以足够权限的用户身份运行（可以修改密码为其他）
* 之后运行com.jiewen.db.Application.java即可

CREATE USER jwp
  IDENTIFIED BY "jwp"
  TEMPORARY TABLESPACE temp
  PROFILE default;

GRANT CONNECT TO jwp;
GRANT RESOURCE TO jwp;

GRANT UNLIMITED TABLESPACE TO jwposp;
GRANT CREATE VIEW TO jwposp;