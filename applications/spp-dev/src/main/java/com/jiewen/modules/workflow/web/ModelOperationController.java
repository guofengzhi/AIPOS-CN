
package com.jiewen.modules.workflow.web;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.zip.ZipInputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.ws.WebServiceException;

import org.activiti.bpmn.converter.BpmnXMLConverter;
import org.activiti.bpmn.model.BpmnModel;
import org.activiti.editor.constants.ModelDataJsonConstants;
import org.activiti.editor.language.json.converter.BpmnJsonConverter;
import org.activiti.engine.RepositoryService;
import org.activiti.engine.impl.persistence.entity.ModelEntity;
import org.activiti.engine.repository.Deployment;
import org.activiti.engine.repository.DeploymentBuilder;
import org.activiti.engine.repository.Model;
import org.activiti.engine.repository.ProcessDefinition;
import org.apache.commons.io.IOUtils;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.github.pagehelper.PageInfo;
import com.jiewen.commons.util.FileUtil;
import com.jiewen.commons.util.ZipUtil;
import com.jiewen.jwp.base.web.BaseController;
import com.jiewen.jwp.base.web.ParamResult;
import com.jiewen.jwp.base.web.Result;
import com.jiewen.jwp.base.web.ResultGenerator;
import com.jiewen.jwp.common.FileUtils;
import com.jiewen.jwp.common.StringUtils;
import com.jiewen.modules.workflow.entity.ModelVo;
import com.jiewen.modules.workflow.service.RepositoryPageService;

/**
 *
 * 工作流模型Controller
 *
 * @author Pang.M 2018年1月15日
 *
 */

@Controller
@RequestMapping(value = "/workflow")
public class ModelOperationController extends BaseController {

    public static final String VALID = "valid";

    @Autowired
    private RepositoryPageService repositoryPageService;

    @Autowired
    private RepositoryService repositoryService;

    @Autowired
    ObjectMapper objectMapper;

    @Value("${http.uploader.path}")
    private String dirPath;

    @RequestMapping(value = "/modeler/{modelId}", method = RequestMethod.GET)
    public String modeler(@PathVariable("modelId") String modelId,
                          HttpServletRequest request) {

        request.setAttribute("modelId", modelId);
        return "modules/workflow/modeler";
    }

    // 流程定义列表
    @RequestMapping(value = "/model/list", method = RequestMethod.GET)
    public String list() {

        return "modules/workflow/model_list";
    }

    @RequiresPermissions("workflow:model:view")
    @RequestMapping(value = "/model/findList")
    public @ResponseBody Map<String, Object> findList(String reqObj) {
        ModelVo model = new ParamResult<ModelVo>(reqObj).getEntity(ModelVo.class);
        PageInfo<Model> pageInfo = repositoryPageService.getModelList(model);
        return resultMap(model, pageInfo);
    }

    @ModelAttribute
    public ModelVo get(@RequestParam(required = false) String id) {

        ModelVo vo = new ModelVo();
        if (!StringUtils.isEmpty(id)) {
            ModelEntity model = (ModelEntity) repositoryService.getModel(id);
            BeanUtils.copyProperties(model, vo);
            try {
                ObjectNode metaInfo = (ObjectNode) objectMapper
                        .readTree(model.getMetaInfo());
                vo.setId(model.getId());
                String description = metaInfo
                        .get(ModelDataJsonConstants.MODEL_DESCRIPTION).toString();
                description = description.equals("null") ? null
                        : description.replaceAll("\"", "");
                vo.setDescription(description);
            } catch (Exception e) {
                logger.error("Error get model id=" + id, e);
                throw new WebServiceException("Error get model id=" + id, e);
            }
        }

        return vo;
    }

    // key的唯一性校验
    @RequestMapping(value = "/model/uniquekey", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Boolean> uniqueKey(String key, String id) {
        Map<String, Boolean> map = new HashMap<>();
        if (StringUtils.isEmpty(key)) {
            map.put(VALID, true);
        } else {
            List<Model> models = repositoryService.createModelQuery().modelKey(key)
                    .list();
            if (StringUtils.isEmpty(id) && models.isEmpty()) {
                map.put(VALID, true);
            } else {
                map.put(VALID, false);
                for (Model model : models) {
                    if (model.getId().equals(id)) {
                        map.put(VALID, true);
                        break;
                    }
                }
            }
        }
        return map;
    }

    /**
     * 获取所有模型
     *
     * @return
     */
    @RequestMapping(value = "/model/all", method = RequestMethod.POST)
    @ResponseBody
    public List<Model> modelList() {
        return repositoryService.createModelQuery().list();
    }

    /**
     * 删除模型
     *
     * @param id
     * @return
     */
    @RequestMapping(value = "/model/delete/{id}", method = RequestMethod.POST)
    @ResponseBody
    public Result deleteModel(@PathVariable("id") String id) {
        try {
            String deleteSuccess = messageSourceUtil
                    .getMessage("workflow.model.promt.del.success");
            repositoryService.deleteModel(id);
            return ResultGenerator.genSuccessResult(deleteSuccess);
        } catch (Exception e) {
            String deleteError = messageSourceUtil
                    .getMessage("workflow.model.delete.error.info");
            return ResultGenerator.genFailResult(deleteError);
        }
    }

    /**
     * 新建一个空模型
     *
     * @return
     * @throws UnsupportedEncodingException
     */
    @RequestMapping(value = "/model/new", method = RequestMethod.GET)
    public String newModel() throws UnsupportedEncodingException {
        // 初始化一个空模型
        org.activiti.engine.repository.Model model = repositoryService.newModel();

        // 设置一些默认信息
        String name = "new-process";
        String description = "";
        int revision = 1;
        String key = "process";

        ObjectNode modelNode = objectMapper.createObjectNode();
        modelNode.put(ModelDataJsonConstants.MODEL_NAME, name);
        modelNode.put(ModelDataJsonConstants.MODEL_DESCRIPTION, description);
        modelNode.put(ModelDataJsonConstants.MODEL_REVISION, revision);

        model.setName(name);
        model.setKey(key);
        model.setMetaInfo(modelNode.toString());

        repositoryService.saveModel(model);
        String id = model.getId();

        // 完善ModelEditorSource
        ObjectNode editorNode = objectMapper.createObjectNode();
        editorNode.put("id", "canvas");
        editorNode.put("resourceId", "canvas");
        ObjectNode stencilSetNode = objectMapper.createObjectNode();
        stencilSetNode.put("namespace", "http://b3mn.org/stencilset/bpmn2.0#");
        editorNode.set("stencilset", stencilSetNode);
        repositoryService.addModelEditorSource(id,
                editorNode.toString().getBytes("UTF-8"));
        return "redirect:/workflow/modeler/" + id;
    }

    @RequiresPermissions("workflow:define:view")
    @RequestMapping(value = "/model/edit", method = RequestMethod.GET)
    public String editorModel(ModelMap mod, ModelVo model) {
        mod.addAttribute("model", model);
        return "modules/workflow/model_edit";
    }

    @RequiresPermissions("workflow:model:edit")
    @RequestMapping(value = "/model/save", method = RequestMethod.POST)
    @ResponseBody
    public Result save(ModelVo vo) throws IOException {
        String moduleSave = messageSourceUtil.getMessage("workflow.model.promt.save");
        String success = messageSourceUtil.getMessage("workflow.model.promt.success");
        String modelId = vo.getId();
        ModelEntity model;
        if (StringUtils.isEmpty(modelId)) {
            // 新增
            model = (ModelEntity) repositoryService.newModel();

        } else {
            // 编辑
            model = (ModelEntity) repositoryService.getModel(modelId);
        }
        BeanUtils.copyProperties(vo, model, "revision");
        ObjectNode modelNode;
        if (!StringUtils.isEmpty(model.getMetaInfo())) {
            modelNode = (ObjectNode) objectMapper.readTree(model.getMetaInfo());
        } else {
            modelNode = objectMapper.createObjectNode();
            modelNode.put(ModelDataJsonConstants.MODEL_REVISION, model.getRevision());
        }
        modelNode.put(ModelDataJsonConstants.MODEL_NAME, vo.getName());
        modelNode.put(ModelDataJsonConstants.MODEL_DESCRIPTION, vo.getDescription());
        model.setMetaInfo(modelNode.toString());
        repositoryService.saveModel(model);
        modelId = model.getId();
        if (StringUtils.isEmpty(model.getEditorSourceValueId())) {
            ObjectNode editorNode = objectMapper.createObjectNode();
            editorNode.put("resourceId", modelId);
            ObjectNode stencilSetNode = objectMapper.createObjectNode();
            stencilSetNode.put("namespace", "http://b3mn.org/stencilset/bpmn2.0#");
            editorNode.set("stencilset", stencilSetNode);
            repositoryService.addModelEditorSource(modelId,
                    editorNode.toString().getBytes("utf-8"));
        }
        return ResultGenerator.genSuccessResult(moduleSave + model.getName() + success);
    }

    /**
     * 模型复制
     *
     * @param id
     * @return
     */
    @RequestMapping(value = "/model/copy/{id}", method = RequestMethod.POST)
    @ResponseBody
    public Result copyModal(@PathVariable("id") String id) throws IOException {
        ModelEntity newModel = (ModelEntity) repositoryService.newModel();
        ModelEntity model = (ModelEntity) repositoryService.getModel(id);
        BeanUtils.copyProperties(model, newModel, "id", "revision");
        ObjectNode modelNode;
        if (!StringUtils.isEmpty(model.getMetaInfo())) {
            modelNode = (ObjectNode) objectMapper.readTree(model.getMetaInfo());
            newModel.setMetaInfo(modelNode.toString());
        }
        newModel.setDeploymentId(null);
        newModel.setEditorSourceExtraValueId(null);
        newModel.setEditorSourceValueId(null);
        newModel.setName(model.getName()
                + messageSourceUtil.getMessage("workflow.model.counterpart"));
        repositoryService.saveModel(newModel);
        repositoryService.addModelEditorSource(newModel.getId(),
                repositoryService.getModelEditorSource(model.getId()));
        repositoryService.addModelEditorSourceExtra(newModel.getId(),
                repositoryService.getModelEditorSourceExtra(model.getId()));
        return ResultGenerator.genSuccessResult(
                messageSourceUtil.getMessage("workflow.model.copyflow"));
    }

    /**
     * 发布模型为流程定义
     *
     * @param id
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/model/deploy/{id}", method = RequestMethod.POST)
    @ResponseBody
    public Result deploy(@PathVariable("id") String id,
                         HttpServletRequest request) throws IOException {

        // 获取模型
        Model modelData = repositoryService.getModel(id);
        byte[] bytes = repositoryService.getModelEditorSource(modelData.getId());

        if (bytes == null) {
            return ResultGenerator.genFailResult(
                    messageSourceUtil.getMessage("workflow.model.release.fail.empty"));
        }

        JsonNode modelNode = objectMapper.readTree(bytes);

        BpmnModel model = new BpmnJsonConverter().convertToBpmnModel(modelNode);
        if (model.getProcesses().isEmpty()) {
            return ResultGenerator.genFailResult(
                    messageSourceUtil.getMessage("workflow.model.release.fail.not"));
        }
        try {
            // ----------------生成zip文件-------------------------
            Result xml = generateResource("xml", id, request);
            Result image = generateResource("image", id, request);
            if (xml.getData() == null || image.getData() == null) {
                return ResultGenerator.genFailResult(messageSourceUtil
                        .getMessage("workflow.model.release.flow.error"));
            }
            String basePath = request.getServletContext().getRealPath("/");
            String fileName = modelData.getKey() + ".bpmn20.model.zip";
            String zipFileName = dirPath + File.separator + fileName;
            File file = new File(basePath + File.separator + zipFileName);
            if (file.exists()) {
                FileUtils.deleteFile(file.getAbsolutePath());
            }
            String zipPath = file.getAbsolutePath();
            ZipUtil.zip(new File[] { new File(basePath + xml.getData().toString()),
                    new File(basePath + image.getData().toString()) }, file);
            ZipInputStream zipInputStream = new ZipInputStream(
                    new FileInputStream(zipPath));
            // ---------------------------------------------------
            // 发布流程
            DeploymentBuilder deploymentBuilder = repositoryService.createDeployment()
                    .name(modelData.getName()).category(modelData.getCategory())
                    .tenantId(modelData.getTenantId())
                    // 使用addZipInputStream后可以预防flow连线文字丢失的问题
                    .addZipInputStream(zipInputStream);

            List<JsonNode> forms = modelNode.findValues("formkeydefinition");
            for (JsonNode form : forms) {
                String formName = form.textValue();
                if (!StringUtils.isEmpty(formName)) {
                    InputStream stream = this.getClass().getClassLoader()
                            .getResourceAsStream(formName);
                    deploymentBuilder.addInputStream(formName, stream);
                }
            }
            Deployment deployment = deploymentBuilder.deploy();

            // 更新流程定义类别,替换掉页面的定义
            ProcessDefinition processDefinition = repositoryService
                    .createProcessDefinitionQuery().deploymentId(deployment.getId())
                    .singleResult();
            if (processDefinition != null) {
                repositoryService.setProcessDefinitionCategory(processDefinition.getId(),
                        deployment.getCategory());
            }

            modelData.setDeploymentId(deployment.getId());
            repositoryService.saveModel(modelData);
            return ResultGenerator.genSuccessResult(
                    messageSourceUtil.getMessage("workflow.model.deploy.success"));
        } catch (Exception ex) {
            return ResultGenerator.genFailResult(
                    messageSourceUtil.getMessage("workflow.model.deploy.fail"));
        }
    }

    /**
     * 导出model的xml文件
     */
    @RequestMapping(value = "/model/export/xml/{modelId}", method = RequestMethod.GET)
    public void exportXml(@PathVariable("modelId") String modelId,
                          HttpServletResponse response) {
        try {
            Model modelData = repositoryService.getModel(modelId);
            BpmnJsonConverter jsonConverter = new BpmnJsonConverter();
            JsonNode editorNode = objectMapper
                    .readTree(repositoryService.getModelEditorSource(modelData.getId()));
            BpmnModel bpmnModel = jsonConverter.convertToBpmnModel(editorNode);
            BpmnXMLConverter xmlConverter = new BpmnXMLConverter();
            // 没有xml
            if (bpmnModel.getProcesses().isEmpty()) {
                response.setCharacterEncoding("utf-8");
                String msg = messageSourceUtil
                        .getMessage("workflow.model.buildxml.error");
                response.getWriter()
                        .print("<script>modals.error('" + msg + "');</script>");
                response.flushBuffer();
                return;
            }
            byte[] bpmnBytes = xmlConverter.convertToXML(bpmnModel);

            ByteArrayInputStream in = new ByteArrayInputStream(bpmnBytes);
            IOUtils.copy(in, response.getOutputStream());
            String filename = bpmnModel.getMainProcess().getId() + ".bpmn20.model.xml";
            response.setHeader("Content-Disposition", "attachment; filename=" + filename);
            response.flushBuffer();
        } catch (Exception e) {
            String msg = messageSourceUtil.getMessage("workflow.model.export.error");
            logger.error(msg, modelId, e);
        }
    }

    /**
     * 导出model的png文件
     */
    @RequestMapping(value = "/model/export/image/{modelId}", method = RequestMethod.GET)
    public void exportPng(@PathVariable("modelId") String modelId,
                          HttpServletResponse response) {
        try {
            Model modelData = repositoryService.getModel(modelId);
            byte[] pngBytes = repositoryService
                    .getModelEditorSourceExtra(modelData.getId());

            ByteArrayInputStream in = new ByteArrayInputStream(pngBytes);
            IOUtils.copy(in, response.getOutputStream());
            String filename = modelData.getKey() + ".process.model.png";
            response.setHeader("Content-Disposition", "attachment; filename=" + filename);
            response.flushBuffer();
        } catch (Exception e) {
            String msg = messageSourceUtil.getMessage("workflow.model.exportpng.error");
            logger.error(msg, modelId, e);
        }
    }

    /**
     * 校验资源文件是否存在
     *
     * @param type
     *            xml image 类型
     * @param modelId
     *            模型id
     * @return
     * @throws IOException
     */
    @RequestMapping(value = "/model/exist/{type}/{modelId}", method = RequestMethod.POST)
    @ResponseBody
    public Result
           resourceExist(@PathVariable("type") String type,
                         @PathVariable("modelId") String modelId) throws IOException {
        Model modelData = repositoryService.getModel(modelId);
        if (type.equals("xml")) {
            BpmnJsonConverter jsonConverter = new BpmnJsonConverter();
            JsonNode editorNode = objectMapper
                    .readTree(repositoryService.getModelEditorSource(modelData.getId()));
            BpmnModel bpmnModel = jsonConverter.convertToBpmnModel(editorNode);
            return ResultGenerator.genSuccessResult(!bpmnModel.getProcesses().isEmpty());
        } else {
            byte[] pngBytes = repositoryService
                    .getModelEditorSourceExtra(modelData.getId());
            return ResultGenerator.genSuccessResult(pngBytes.length > 0);
        }
    }

    /**
     * 跳转到模型资源文件查看界面
     */

    @RequestMapping(value = "/model/show/{modelId}", method = RequestMethod.GET)
    public String showResoure(@PathVariable("modelId") String modelId,
                              HttpServletRequest request) {
        Result xml = generateResource("xml", modelId, request);
        Result image = generateResource("image", modelId, request);
        request.setAttribute("xml", xml.getData());
        request.setAttribute("image", image.getData());
        request.setAttribute("modelId", modelId);
        return "modules/workflow/model_show";
    }

    /**
     * 生成资源文件，并返回文件路径
     */
    @RequestMapping(value = "/model/generate/{type}/{modelId}",
            method = RequestMethod.POST)
    @ResponseBody
    public Result generateResource(@PathVariable("type") String type,
                                   @PathVariable("modelId") String modelId,
                                   HttpServletRequest request) {
        try {
            String resPath = request.getServletContext().getRealPath("/");
            Model model = repositoryService.getModel(modelId);
            if (type.equals("xml")) {
                Model modelData = repositoryService.getModel(modelId);
                BpmnJsonConverter jsonConverter = new BpmnJsonConverter();
                JsonNode editorNode = objectMapper.readTree(
                        repositoryService.getModelEditorSource(modelData.getId()));
                BpmnModel bpmnModel = jsonConverter.convertToBpmnModel(editorNode);
                BpmnXMLConverter xmlConverter = new BpmnXMLConverter();
                byte[] bpmnBytes = xmlConverter.convertToXML(bpmnModel);

                ByteArrayInputStream in = new ByteArrayInputStream(bpmnBytes);
                String fileName = model.getKey() + ".model.bpmn";
                String realPath = resPath + File.separator + dirPath + File.separator
                        + fileName;
                FileUtils.deleteFile(realPath);
                FileUtil.copyToFile(in, new File(realPath));
                String realName = (dirPath + File.separator + fileName).replaceAll("\\\\",
                        "/");
                return ResultGenerator
                        .genSuccessResult(messageSourceUtil
                                .getMessage("workflow.model.build.conf.success"))
                        .setData(realName);
            } else {
                byte[] pngBytes = repositoryService.getModelEditorSourceExtra(modelId);
                String fileName = model.getKey() + ".model.png";
                String realPath = resPath + File.separator + dirPath + File.separator
                        + fileName;
                FileUtils.deleteFile(realPath);
                ByteArrayInputStream in = new ByteArrayInputStream(pngBytes);
                File file = new File(realPath);
                FileUtil.copyToFile(in, file);
                String realName = (dirPath + File.separator + fileName).replaceAll("\\\\",
                        "/");
                return ResultGenerator
                        .genSuccessResult(messageSourceUtil
                                .getMessage("workflow.model.build.png.success"))
                        .setData(realName);
            }
        } catch (Exception e) {
            logger.error(messageSourceUtil.getMessage("workflow.model.build.conf.fail"),
                    modelId, e);
            return ResultGenerator.genFailResult(
                    messageSourceUtil.getMessage("workflow.model.build.file.fail"));
        }
    }

}
