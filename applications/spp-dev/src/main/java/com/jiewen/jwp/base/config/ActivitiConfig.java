
package com.jiewen.jwp.base.config;

import org.activiti.engine.DynamicBpmnService;
import org.activiti.engine.FormService;
import org.activiti.engine.HistoryService;
import org.activiti.engine.IdentityService;
import org.activiti.engine.ManagementService;
import org.activiti.engine.ProcessEngine;
import org.activiti.engine.RepositoryService;
import org.activiti.engine.RuntimeService;
import org.activiti.engine.TaskService;
import org.activiti.spring.ProcessEngineFactoryBean;
import org.activiti.spring.SpringProcessEngineConfiguration;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.transaction.PlatformTransactionManager;

import com.alibaba.druid.pool.DruidDataSource;

/**
 * @author: wsj.
 * @createTime: 2018/1/22.
 */
@Configuration
public class ActivitiConfig {

    @Autowired
    public PlatformTransactionManager transactionManager;

    @Autowired
    public DruidDataSource druidDataSource;

    @Value("${jdbc.type}")
    private String dataBaseType;

    @Value("${activiti.databaseSchemaUpdate}")
    private String databaseSchemaUpdate;

    @Value("${activiti.isDbIdentityUsed}")
    private boolean isDbIdentityUsed;

    @Value("${activiti.activity-fontName}")
    private String activityFontName;

    @Value("${activiti.annotation-fontName}")
    private String annotationFontName;

    @Value("${activiti.label-fontName}")
    private String labelFontName;

    @Bean
    public SpringProcessEngineConfiguration getProcessEngineConfiguration() {

        SpringProcessEngineConfiguration config = new SpringProcessEngineConfiguration();
        config.setDataSource(druidDataSource);
        config.setTransactionManager(transactionManager);
        config.setDatabaseType(dataBaseType);
        config.setDatabaseSchemaUpdate(databaseSchemaUpdate);
        config.setDbIdentityUsed(isDbIdentityUsed);

        // 流程图字体
        config.setActivityFontName(activityFontName);
        config.setAnnotationFontName(annotationFontName);
        config.setLabelFontName(labelFontName);
        return config;
    }

    @Bean
    public ProcessEngineFactoryBean processEngine() {

        ProcessEngineFactoryBean processEngineFactoryBean = new ProcessEngineFactoryBean();
        processEngineFactoryBean.setProcessEngineConfiguration(getProcessEngineConfiguration());
        return processEngineFactoryBean;
    }

    @Bean
    public RepositoryService repositoryService(ProcessEngine processEngine) {

        return processEngine.getRepositoryService();
    }

    @Bean
    public RuntimeService runtimeService(ProcessEngine processEngine) {

        return processEngine.getRuntimeService();
    }

    @Bean
    public TaskService taskService(ProcessEngine processEngine) {

        return processEngine.getTaskService();
    }

    @Bean
    public HistoryService historyService(ProcessEngine processEngine) {

        return processEngine.getHistoryService();
    }

    @Bean
    public FormService formService(ProcessEngine processEngine) {

        return processEngine.getFormService();
    }

    @Bean
    public IdentityService identityService(ProcessEngine processEngine) {

        return processEngine.getIdentityService();
    }

    @Bean
    public ManagementService managementService(ProcessEngine processEngine) {

        return processEngine.getManagementService();
    }

    @Bean
    public DynamicBpmnService dynamicBpmnService(ProcessEngine processEngine) {

        return processEngine.getDynamicBpmnService();
    }

}