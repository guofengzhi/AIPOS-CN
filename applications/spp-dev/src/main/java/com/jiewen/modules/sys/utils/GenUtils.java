package com.jiewen.modules.sys.utils;


import com.jiewen.jwp.base.utils.DateUtil;
import com.jiewen.modules.sys.entity.Columns;
import com.jiewen.modules.sys.domain.TableDO;

import org.apache.commons.configuration.Configuration;
import org.apache.commons.configuration.ConfigurationException;
import org.apache.commons.configuration.PropertiesConfiguration;
import org.apache.commons.io.IOUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.WordUtils;
import org.apache.velocity.Template;
import org.apache.velocity.VelocityContext;
import org.apache.velocity.app.Velocity;

import java.io.File;
import java.io.IOException;
import java.io.StringWriter;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

/**
 * 代码生成器   工具类
 */
public class GenUtils {


    public static List<String> getTemplates() {
    	
    	
    	List<String> templates = new ArrayList<String>();
    	
    	// 生成Mapper
    	templates.add("template/common/generator/Mapper.xml.vm");
    	
    	// 生成DAO模板
    	templates.add("template/common/generator/Dao.java.vm");
    	
    	// 生成service模板
    	templates.add("template/common/generator/Service.java.vm");
    	
    	// 生成controller
    	templates.add("template/common/generator/Controller.java.vm");
    	
    	// 生成对象实例
    	templates.add("template/common/generator/domain.java.vm");
    	
    	 // 生成listJsp
         templates.add("template/common/generator/list.jsp.vm");
         templates.add("template/common/generator/query.xml.vm");
    	
        return templates;
    }

    /**
     * 生成代码
     */


    public static void generatorCode(Map<String, String> table,
                                     List<Columns> columnsA, ZipOutputStream zip) {
        //配置信息
        Configuration config = getConfig();
        //表信息
        TableDO tableDO = new TableDO();
        tableDO.setTableName(table.get("tableName"));
        tableDO.setComments(table.get("tableComment"));
        //表名转换成Java类名
        String className = tableToJava(tableDO.getTableName(), 
        		config.getString("tablePrefix"), config.getString("autoRemovePre"));
        tableDO.setClassName(className);
        tableDO.setClassname(StringUtils.uncapitalize(className));

        //列信息
        List<Columns> columsList = new ArrayList<>();
        for (Columns column : columnsA) {
        	Columns columns = new Columns();
        	columns.setColumnName(column.getColumnName());
        	columns.setDataType(column.getDataType());
        	columns.setComments(column.getColumnComment());
        	columns.setExtra(column.getExtra());

            //列名转换成Java属性名
            String attrName = columnToJava(columns.getColumnName());
            columns.setAttrName(attrName);
            columns.setAttrname(StringUtils.uncapitalize(attrName));

            //列的数据类型，转换成Java类型
            String attrType = config.getString(columns.getDataType(), "unknowType");
            columns.setAttrType(attrType);

            //是否主键
            if ("PRI".equalsIgnoreCase(column.getColumnKey()) && tableDO.getPk() == null) {
                tableDO.setPk(columns);
            }

            columsList.add(columns);
        }
        tableDO.setColumns(columsList);

        //没主键，则第一个字段为主键
        if (tableDO.getPk() == null) {
            tableDO.setPk(tableDO.getColumns().get(0));
        }

        //设置velocity资源加载器
        Properties prop = new Properties();
        prop.put("file.resource.loader.class", "org.apache.velocity.runtime.resource.loader.ClasspathResourceLoader");
        Velocity.init(prop);

        //封装模板数据
        Map<String, Object> map = new HashMap<>(16);
        map.put("tableName", tableDO.getTableName());
        map.put("comments", tableDO.getComments());
        map.put("pk", tableDO.getPk());
        map.put("className", tableDO.getClassName());
        map.put("classname", tableDO.getClassname());
        map.put("pathName", config.getString("packPath").substring(config.getString("packPath").lastIndexOf(".") + 1));
        map.put("columns", tableDO.getColumns());
        map.put("package", config.getString("packPath"));
        map.put("author", config.getString("author"));
        map.put("email", config.getString("email"));
        map.put("datetime", DateUtil.format(new Date(), DateUtil.YYYY_MM_DD_HH_MM_SS));
        VelocityContext context = new VelocityContext(map);

        //获取模板列表
        List<String> templates = getTemplates();
        for (String template : templates) {
            //渲染模板
            StringWriter sw = new StringWriter();
            Template tpl = Velocity.getTemplate(template, "UTF-8");
            tpl.merge(context, sw);

            try {
                //添加到zip
                zip.putNextEntry(new ZipEntry(getFileName(template, tableDO.getClassname(), 
                		tableDO.getClassName(), 
                		config.getString("packPath").substring(config.getString("packPath").lastIndexOf(".") + 1))));
                IOUtils.write(sw.toString(), zip, "UTF-8");
                IOUtils.closeQuietly(sw);
                zip.closeEntry();
            } catch (IOException e) {
                throw new BDException("渲染模板失败，表名：" + tableDO.getTableName(), e);
            }
        }
    }


    /**
     * 列名转换成Java属性名
     */
    public static String columnToJava(String columnName) {
        return WordUtils.capitalizeFully(columnName, new char[]{'_'}).replace("_", "");
    }

    /**
     * 表名转换成Java类名
     */
    public static String tableToJava(String tableName1, String tablePrefix, String autoRemovePre) {
    	
    	String tableName=tableName1;
    	
        if ("true".equals(autoRemovePre)) {
            tableName = tableName.substring(tableName.indexOf("_") + 1);
        }
        if (StringUtils.isNotBlank(tablePrefix)) {
            tableName = tableName.replace(tablePrefix, "");
        }

        return columnToJava(tableName);
    }

    /**
     * 获取配置信息
     */
    public static Configuration getConfig() {
        try {
            return new PropertiesConfiguration("generator.properties");
        } catch (ConfigurationException e) {
            throw new BDException("获取配置文件失败，", e);
        }
    }

    /**
     * 获取文件名
     */
    public static String getFileName(String template, String classname, String className, String packageName) {
    	
        String packagePath = "main" + File.separator + "java" + File.separator;
        
        if (StringUtils.isNotBlank(packageName)) {
            packagePath += packageName.replace(".", File.separator) + File.separator;
        }

        if (template.contains("domain.java.vm")) {
            return packagePath + "domain" + File.separator + className + "DO.java";
        }

        if (template.contains("Dao.java.vm")) {
            return packagePath + "dao" + File.separator + className + "Dao.java";
        }


        if (template.contains("Service.java.vm")) {
            return packagePath + "service" + File.separator + className + "Service.java";
        }

        if (template.contains("Controller.java.vm")) {
            return packagePath + "web" + File.separator + className + "Controller.java";
        }

        if (template.contains("Mapper.xml.vm")) {
            return "main" + File.separator + "resources" + File.separator + "mybatis" + File.separator +
            		packageName + File.separator + className + "Mapper.xml";
        }

        if (template.contains("query.xml.vm")) {
            return "main" + File.separator + "resources" + File.separator + "query" +  
            File.separator + className + "Query.xml";
        }
        
        
        if (template.contains("list.jsp.vm")) {
            return "main" + File.separator + "resources" + File.separator + "templates" + File.separator
                    + packageName + File.separator + classname + File.separator + classname + ".jsp";
        }
       
        return null;
    }
}
