package com.jiewen.constant;

/**
 * 项目常量
 */
public final class ProjectConstant {
    public static final String BASE_PACKAGE = "com.jiewen"; // 项目基础包名称，根据自己公司的项目修改

    public static final String MODEL_PACKAGE = BASE_PACKAGE + ".ota.model"; // Model所在包
    
    public static final String MAPPER_PACKAGE = BASE_PACKAGE + ".ota.dao"; // Mapper所在包
    
    public static final String SERVICE_PACKAGE = BASE_PACKAGE + ".ota.service"; // Service所在包
    
    public static final String SERVICE_IMPL_PACKAGE = SERVICE_PACKAGE + ".impl"; // ServiceImpl所在包
    
    public static final String CONTROLLER_PACKAGE = BASE_PACKAGE + ".ota.web"; // Controller所在包

    public static final String MAPPER_INTERFACE_REFERENCE = BASE_PACKAGE + ".base.core.Mapper"; // Mapper插件基础接口的完全限定名

    
    private ProjectConstant(){}
}
