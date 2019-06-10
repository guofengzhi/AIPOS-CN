package com.jiewen.modules.upload.web;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.IOUtils;
import org.apache.commons.lang3.StringEscapeUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.google.common.net.HttpHeaders;
import com.jiewen.base.core.web.Result;
import com.jiewen.jwp.base.utils.IdGen;
import com.jiewen.jwp.base.utils.UploadUtil;
import com.jiewen.jwp.base.web.BaseController;
import com.jiewen.jwp.common.DateUtils;
import com.jiewen.jwp.common.FileUtils;
import com.jiewen.modules.upload.entity.FileResult;
import com.jiewen.modules.upload.entity.SysFile;
import com.jiewen.modules.upload.service.UploaderService;

@Controller
@RequestMapping("${adminPath}/file")
public class UploaderController extends BaseController {

    // previewFileIconSettings
    protected static Map<String, String> fileIconMap = new HashMap<>();

    @Autowired
    private UploaderService uploaderService;

    static {
        fileIconMap.put("doc", "<i class='fa fa-file-word-o text-primary'></i>");
        fileIconMap.put("docx", "<i class='fa fa-file-word-o text-primary'></i>");
        fileIconMap.put("xls", "<i class='fa fa-file-excel-o text-success'></i>");
        fileIconMap.put("xlsx", "<i class='fa fa-file-excel-o text-success'></i>");
        fileIconMap.put("ppt", "<i class='fa fa-file-powerpoint-o text-danger'></i>");
        fileIconMap.put("pptx", "<i class='fa fa-file-powerpoint-o text-danger'></i>");
        fileIconMap.put("jpg", "<i class='fa fa-file-photo-o text-warning'></i>");
        fileIconMap.put("pdf", "<i class='fa fa-file-pdf-o text-danger'></i>");
        fileIconMap.put("zip", "<i class='fa fa-file-archive-o text-muted'></i>");
        fileIconMap.put("rar", "<i class='fa fa-file-archive-o text-muted'></i>");
        fileIconMap.put("default", "<i class='fa fa-file-o'></i>");
    }

    /**
     * 跳转到通用文件上传窗口
     * 
     * @return
     */
    @RequestMapping(value = "/uploader", method = RequestMethod.GET)
    public String uploader(String config, HttpServletRequest request) {
        request.setAttribute("config", StringEscapeUtils.unescapeHtml4(config));
        return "base/file/file_uploader";
    }

    /**
     * 通用文件上传接口，存储到固定地址，以后存储到文件服务器地址
     */
    @RequestMapping(value = "/uploadFile", method = RequestMethod.POST)
    @ResponseBody
    public SysFile uploadFile(@RequestParam(value = "file", required = false) MultipartFile file,
            HttpServletRequest request, HttpServletResponse response) {
        return new SysFile();
    }

    /**
     * 多文件上传，用于uploadAsync=false(同步多文件上传使用)
     * 
     * @param files
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/uploadMultipleFile", method = RequestMethod.POST)
    @ResponseBody
    public FileResult uploadMultipleFile(
            @RequestParam(value = "file", required = false) MultipartFile[] files,
            HttpServletRequest request, HttpServletResponse response) throws IOException {
        String fileUploadFail = messageSourceUtil.getMessage("modules.rom.file.upload.fail");

        FileResult msg = new FileResult();

        ArrayList<Integer> arr = new ArrayList<>();
        // 缓存当前的文件
        List<SysFile> fileList = new ArrayList<>();
        String dirPath = request.getSession().getServletContext().getRealPath("/");
        for (int i = 0; i < files.length; i++) {
            MultipartFile file = files[i];

            if (!file.isEmpty()) {
                InputStream in = null;
                OutputStream out = null;
                try {
                    File dir = new File(dirPath + UploadUtil.UPLOADPATH);
                    if (!dir.exists()) {
                        dir.mkdirs();
                    }
                    // 这样也可以上传同名文件了
                    String filePrefixFormat = "yyyyMMddHHmmssS";
                    String savedName = DateUtils.formatDate(new Date(), filePrefixFormat)
                            + IdGen.uuidNumber() + "_" + file.getOriginalFilename();
                    String filePath = dir.getAbsolutePath() + File.separator + savedName;
                    File serverFile = new File(filePath);
                    // 将文件写入到服务器
                    file.transferTo(serverFile);
                    SysFile sysFile = new SysFile();
                    sysFile.setFileName(file.getOriginalFilename());
                    sysFile.setSavedName(savedName);
                    sysFile.setFileSize(file.getSize());
                    sysFile.setFilePath(UploadUtil.UPLOADPATH + File.separator + savedName);
                    uploaderService.save(sysFile);
                    fileList.add(sysFile);
                    logger.info("Server File Location=" + serverFile.getAbsolutePath());
                } catch (Exception e) {
                    logger.error(
                            file.getOriginalFilename() + fileUploadFail + ":" + e.getMessage());
                    arr.add(i);
                } finally {
                    IOUtils.closeQuietly(out);
                    IOUtils.closeQuietly(in);
                }
            } else {
                arr.add(i);
            }
        }

        if (!arr.isEmpty()) {
            msg.setError(fileUploadFail);
            msg.setErrorkeys(arr);
        }
        FileResult preview = getPreivewSettings(fileList, request);
        msg.setInitialPreview(preview.getInitialPreview());
        msg.setInitialPreviewConfig(preview.getInitialPreviewConfig());
        msg.setFileIds(preview.getFileIds());
        return msg;
    }

    // 删除某一项文件
    @RequestMapping(value = "/delete", method = RequestMethod.POST)
    @ResponseBody
    public Result delete(String id, HttpServletRequest request) {
        SysFile sysFile = uploaderService.get(id);
        String dirPath = request.getSession().getServletContext().getRealPath("/");
        FileUtils
                .delFile(dirPath + UploadUtil.UPLOADPATH + File.separator + sysFile.getSavedName());
        uploaderService.delete(sysFile);
        return new Result();
    }

    /**
     * 获取字体图标map,base-file控件使用
     */
    @RequestMapping(value = "/icons", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, String> getIcons() {
        return fileIconMap;
    }

    /**
     * 根据文件名获取icon
     * 
     * @param fileName
     *            文件
     * @return
     */
    public String getFileIcon(String fileName) {
        String ext = fileName.substring(fileName.lastIndexOf('.') + 1);
        return fileIconMap.get(ext) == null ? fileIconMap.get("default") : fileIconMap.get(ext);
    }

    /**
     * 根据附件IDS 获取文件
     * 
     * @param fileIds
     * @param request
     * @return
     */
    @RequestMapping(value = "/getFiles", method = RequestMethod.POST)
    @ResponseBody
    public FileResult getFiles(String fileIds, HttpServletRequest request) {

        String[] fileIdArr = StringUtils.split(fileIds, ',');
        List<SysFile> fileList = uploaderService.findByArray(fileIdArr);
        return getPreivewSettings(fileList, request);
    }

    /**
     * 回填已有文件的缩略图
     * 
     * @param fileList
     *            文件列表
     * @param request
     * @return initialPreiview initialPreviewConfig fileIds
     */
    public FileResult getPreivewSettings(List<SysFile> fileList, HttpServletRequest request) {
        FileResult fileResult = new FileResult();
        List<String> previews = new ArrayList<>();
        List<FileResult.PreviewConfig> previewConfigs = new ArrayList<>();
        // 缓存当前的文件
        String dirPath = request.getSession().getServletContext().getRealPath("/");
        String[] fileArr = new String[fileList.size()];
        int index = 0;
        for (SysFile sysFile : fileList) {
            if (FileUtils.isImage(
                    dirPath + UploadUtil.UPLOADPATH + File.separator + sysFile.getSavedName())) {
                previews.add("<img src='." + sysFile.getFilePath().replace(File.separator, "/")
                        + "' class='file-preview-image kv-preview-data' "
                        + "style='width:auto;height:160px' alt='" + sysFile.getFileName()
                        + " title='" + sysFile.getFileName() + "''>");
            } else {
                previews.add(
                        "<div class='kv-preview-data file-preview-other-frame'><div class='file-preview-other'>"
                                + "<span class='file-other-icon'>"
                                + getFileIcon(sysFile.getFileName()) + "</span></div></div>");
            }
            // 上传后预览配置
            FileResult.PreviewConfig previewConfig = new FileResult.PreviewConfig();
            previewConfig.setWidth("120px");
            previewConfig.setCaption(sysFile.getFileName());
            previewConfig.setKey(sysFile.getId());
            previewConfig.setExtra(new FileResult.PreviewConfig.Extra(sysFile.getId()));
            previewConfig.setSize(sysFile.getFileSize());
            previewConfigs.add(previewConfig);
            fileArr[index++] = sysFile.getId();
        }
        fileResult.setInitialPreview(previews);
        fileResult.setInitialPreviewConfig(previewConfigs);
        fileResult.setFileIds(StringUtils.join(fileArr, ""));
        return fileResult;
    }

    @RequestMapping(value = "/download/{id}", method = RequestMethod.GET)
    public void downloadFile(@PathVariable("id") String id, HttpServletRequest request,
            HttpServletResponse response) throws IOException {
        String downloadFileFail = messageSourceUtil.getMessage("modules.rom.file.download.fail");
        String fileNotExist = messageSourceUtil.getMessage("modules.rom.file.not.exist");

        SysFile sysfile = uploaderService.get(id);

        File file = null;
        if (sysfile != null) {
            file = new File(request.getSession().getServletContext().getRealPath("/")
                    + sysfile.getFilePath());
        }
        if (file != null && file.exists() && file.isFile()) {
            try (InputStream is = new FileInputStream(file);
                    OutputStream os = response.getOutputStream()) {
                long filelength = file.length();
                response.setContentType("application/x-msdownload");
                response.setContentLength((int) filelength);
                response.addHeader("Content-Disposition",
                        "attachment; filename=\""
                                + new String(sysfile.getFileName().getBytes("GBK"), // 只有GBK才可以
                                        "iso8859-1")
                                + "\"");
                // 循环取出流中的数据
                byte[] b = new byte[4096];
                int len;
                while ((len = is.read(b)) > 0) {
                    os.write(b, 0, len);
                }
            } catch (IOException e) {
                logger.error(downloadFileFail + e.getMessage());
            }
        } else {
            response.getWriter().println("<script>");
            response.getWriter().println(" modals.info('" + fileNotExist + "');");
            response.getWriter().println("</script>");
        }
    }

    @GetMapping("/{filename:.+}")
    @ResponseBody
    public ResponseEntity<Resource> serveFile(@PathVariable String filename) {
        String filenameVal = filename.replace('$', File.separatorChar);
        Resource file = UploadUtil.loadFileAsResource(filenameVal);
        return ResponseEntity.ok().header(HttpHeaders.CONTENT_DISPOSITION,
                "attachment; filename=\"" + file.getFilename() + "\"").body(file);
    }
}
