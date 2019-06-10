package com.jiewen.modules.upload.web;

import com.google.common.net.HttpHeaders;
import com.jiewen.commons.util.IOUtil;
import com.jiewen.jwp.base.utils.IdGen;
import com.jiewen.jwp.base.utils.UploadUtil;
import com.jiewen.jwp.base.web.BaseController;
import com.jiewen.jwp.base.web.Result;
import com.jiewen.jwp.common.DateUtils;
import com.jiewen.jwp.common.FileUtils;
import com.jiewen.modules.upload.entity.FileResult;
import com.jiewen.modules.upload.entity.SysFile;
import com.jiewen.modules.upload.service.UploaderService;
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

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
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

@Controller
@RequestMapping("/file")
public class UploaderController extends BaseController {


    // previewFileIconSettings
    public static Map<String, String> fileIconMap = new HashMap<String, String>();
   
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
            @RequestParam(value = "file", required = false) MultipartFile[] files, HttpServletRequest request,
            HttpServletResponse response) throws IOException {

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
                    File dir = new File(dirPath + UploadUtil.UPLOADERPATH);
                    if (!dir.exists()) {
                        dir.mkdirs();
                    }
                    // 这样也可以上传同名文件了
                    String filePrefixFormat = "yyyyMMddHHmmssS";
                    String savedName = DateUtils.formatDate(new Date(), filePrefixFormat) + IdGen.uuidNumber()
                            + "_" + file.getOriginalFilename();
                    String filePath = dir.getAbsolutePath() + File.separator + savedName;
                    File serverFile = new File(filePath);
                    // 将文件写入到服务器
                    file.transferTo(serverFile);
                    SysFile sysFile = new SysFile();
                    sysFile.setFileName(file.getOriginalFilename());
                    sysFile.setSavedName(savedName);
                    sysFile.setFileSize(file.getSize());
                    sysFile.setFilePath(UploadUtil.UPLOADERPATH + File.separator + savedName);
                    uploaderService.save(sysFile);
                    fileList.add(sysFile);
                    logger.info("Server File Location=" + serverFile.getAbsolutePath());
                } catch (Exception e) {
                    logger.error(file.getOriginalFilename() + "上传发生异常，异常原因：" + e.getMessage());
                    arr.add(i);
                } finally {
                    IOUtil.closeQuietly(out);
                    IOUtil.closeQuietly(in);
                }
            } else {
                arr.add(i);
            }
        }

        if (!arr.isEmpty()) {
            msg.setError("文件上传失败！");
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
        FileUtils.delFile(dirPath + UploadUtil.UPLOADERPATH + File.separator + sysFile.getSavedName());
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
        String ext = fileName.substring(fileName.lastIndexOf(".") + 1);
        ;
        return fileIconMap.get(ext) == null ? fileIconMap.get("default").toString()
                : fileIconMap.get(ext).toString();
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

        String[] fileIdArr = fileIds.split(",");
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
            if (FileUtils.isImage(dirPath + UploadUtil.UPLOADERPATH + File.separator + sysFile.getSavedName())) {
                previews.add("<img src='." + sysFile.getFilePath().replace(File.separator, "/")
                        + "' class='file-preview-image kv-preview-data' "
                        + "style='width:auto;height:160px' alt='" + sysFile.getFileName() + " title='"
                        + sysFile.getFileName() + "''>");
            } else {
                previews.add(
                        "<div class='kv-preview-data file-preview-other-frame'><div class='file-preview-other'>"
                                + "<span class='file-other-icon'>" + getFileIcon(sysFile.getFileName())
                                + "</span></div></div>");
            }
            // 上传后预览配置
            FileResult.PreviewConfig previewConfig = new FileResult.PreviewConfig();
            previewConfig.setWidth("120px");
            previewConfig.setCaption(sysFile.getFileName());
            previewConfig.setKey(sysFile.getId());
            // previewConfig.setUrl(request.getContextPath()+"/file/delete");
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
        SysFile sysfile = uploaderService.get(id);
        InputStream is = null;
        OutputStream os = null;
        File file = null;
        try {
            // PrintWriter out = response.getWriter();
            if (sysfile != null) {
                file = new File(
                        request.getSession().getServletContext().getRealPath("/") + sysfile.getFilePath());
            }
            if (file != null && file.exists() && file.isFile()) {

                is = new FileInputStream(file);
                // 设置输出的格式
                os = response.getOutputStream();
                long filelength = file.length();
                response.setContentType("application/x-msdownload");
                response.setContentLength((int) filelength);
                response.addHeader("Content-Disposition",
                        "attachment; filename=\"" + new String(sysfile.getFileName().getBytes("GBK"), // 只有GBK才可以
                                "iso8859-1") + "\"");
                // 循环取出流中的数据
                byte[] b = new byte[4096];
                int len;
                while ((len = is.read(b)) > 0) {
                    os.write(b, 0, len);
                }
            } else {
                response.getWriter().println("<script>");
                response.getWriter().println(" modals.info('文件不存在!');");
                response.getWriter().println("</script>");
            }
        } catch (IOException e) {
            logger.error("文件下载错误：" + e.getMessage());
        } finally {
            IOUtil.closeQuietly(is);
            IOUtil.closeQuietly(os);
        }
    }

    @GetMapping("/{filename:.+}")
    @ResponseBody
    public ResponseEntity<Resource> serveFile(@PathVariable String filename) {
        String filename2 = filename.replace('$', File.separatorChar);
        Resource file = UploadUtil.loadFileAsResource(filename2);
        return ResponseEntity.ok().header(HttpHeaders.CONTENT_DISPOSITION,
                "attachment; filename=\"" + file.getFilename() + "\"").body(file);
    }
}
