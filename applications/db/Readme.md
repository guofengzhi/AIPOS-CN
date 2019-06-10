# 数据库版本管理

数据库通过SQL脚本并使用[Flyway](https://flywaydb.org/)进行版本管理，关于Flyway的工作原理和相关规范请参考Flyway官方网站 [https://flywaydb.org/](https://flywaydb.org/getstarted/how)。

spring-boot集成了flyway，spring-boot 应用如果包含了flyway的jar文件，启动时会自动扫描`db/migration` 目录下的数据库脚本并加载。

本project主要为了方便在IDE中查看或执行SQL脚本，实际应用发布时建议采用命令行版的flyway。

SQL脚本命名: `V{version}__{description}.sql` ，**除首字母外，文件名其他部分一律小写**。

SQL脚本版本号命名: `Major_Version_Number.Minor_Version_Number.Revision_Number.Sequence_Number` 。
`Major_Version_Number.Minor_Version_Number.Revision_Number`部分**与整个系统版本号保持一致**，`Sequence_Number`部分为当前版本多个脚本的顺序号，从0开始。

举例：
```
系统初始版本 1.0.0
V1.0.0.0__create_tables.sql
V1.0.0.1__init_data.sql

系统增加少量功能或修复BUG，系统版本变更为 1.0.1
V1.0.1.0__add_xxx_tables.sql

系统变更较大，系统版本号变更为 1.1.0
V1.1.0.0__add_xxx_tables.sql
V1.1.0.1__update_xxx_data.sql
V1.1.0.2__reset_xyz.SQL
... ...
```

