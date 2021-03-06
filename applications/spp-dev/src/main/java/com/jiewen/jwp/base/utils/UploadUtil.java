package com.jiewen.jwp.base.utils;

import java.io.File;
import java.io.FileFilter;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.MalformedURLException;
import java.nio.channels.FileChannel;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadBase;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.RequestContext;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.fileupload.servlet.ServletRequestContext;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.multipart.commons.CommonsMultipartResolver;
import org.springframework.web.servlet.mvc.method.annotation.MvcUriComponentsBuilder;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.jiewen.commons.ServiceException;
import com.jiewen.commons.util.DateTimeUtil;
import com.jiewen.jwp.base.config.Global;
import com.jiewen.jwp.common.FileUtils;
import com.jiewen.modules.upload.entity.FileResult;
import com.jiewen.modules.upload.web.UploaderController;

/**
 * 上传辅助类 与Spring.multipartResolver冲突.
 * 
 */
public final class UploadUtil {

	private UploadUtil() {
	}

	private static final Logger logger = LoggerFactory.getLogger(UploadUtil.class);

	/** 上传文件缓存大小限制 */
	private static int fileSizeThreshold = 1024 * 1024 * 1;

	/** 上传文件临时目录 */
	private static final String UPLOADFILEDIR = "/WEB-INF/upload/";

	/** 上传文件配置目录 */
	public static final String UPLOADERPATH = Global.getConfig("uploaderPath");

	/** 获取所有文本域 */
	public static final List<?> getFileItemList(HttpServletRequest request, File saveDir) throws FileUploadException {
		if (!saveDir.isDirectory()) {
			saveDir.mkdir();
		}
		List<?> fileItems = null;
		RequestContext requestContext = new ServletRequestContext(request);
		if (FileUploadBase.isMultipartContent(requestContext)) {
			DiskFileItemFactory factory = new DiskFileItemFactory();
			factory.setRepository(saveDir);
			factory.setSizeThreshold(fileSizeThreshold);
			ServletFileUpload upload = new ServletFileUpload(factory);
			fileItems = upload.parseRequest(request);
		}
		return fileItems;
	}

	/** 获取文本域 */
	public static final FileItem[] getFileItem(HttpServletRequest request, File saveDir, String... fieldName)
			throws FileUploadException {
		if (fieldName == null || saveDir == null) {
			return new FileItem[0];
		}
		List<?> fileItemList = getFileItemList(request, saveDir);
		FileItem fileItem = null;
		FileItem[] fileItems = new FileItem[fieldName.length];
		for (int i = 0; i < fieldName.length; i++) {
			if (fileItemList == null) {
				return fileItems;
			}
			for (Iterator<?> iterator = fileItemList.iterator(); iterator.hasNext();) {
				fileItem = (FileItem) iterator.next();
				// 根据名字获得文本域

				if (fieldName[i] != null && fieldName[i].equals(fileItem.getFieldName())) {
					fileItems[i] = fileItem;
					break;
				}
			}
		}
		return fileItems;
	}

	/** 上传文件处理(支持批量) */
	public static List<String> uploadFile(HttpServletRequest request) {
		CommonsMultipartResolver multipartResolver = new CommonsMultipartResolver(
				request.getSession().getServletContext());
		List<String> filePaths = Lists.newArrayList();
		if (multipartResolver.isMultipart(request)) {
			MultipartHttpServletRequest multiRequest = (MultipartHttpServletRequest) request;
			String pathDir = getUploadDir(request);
			File dirFile = new File(pathDir);
			if (!dirFile.isDirectory()) {
				dirFile.mkdirs();
			}
			for (Iterator<String> iterator = multiRequest.getFileNames(); iterator.hasNext();) {
				String key = iterator.next();
				MultipartFile multipartFile = multiRequest.getFile(key);
				if (multipartFile != null) {
					String fileName = multipartFile.getOriginalFilename();
					if (StringUtils.isBlank(fileName)) {
						return Collections.emptyList();
					}
					String filePath = pathDir + fileName;
					File file = new File(filePath);
					if (!file.setWritable(true, false)) {
						logger.error(fileName + "保存失败");
					}

					try {
						multipartFile.transferTo(file);
						filePaths.add(filePath);
					} catch (Exception e) {
						logger.error(fileName + "保存失败", e);
					}
				}
			}
		}
		return filePaths;
	}

	/** 获取上传文件临时目录 */
	public static String getUploadDir(HttpServletRequest request) {
		return request.getServletContext().getRealPath(UPLOADFILEDIR) + File.separator;
	}

	/**
	 * 保存文件
	 * 
	 * @param request
	 */
	public static void uploadSaveFile(MultipartFile file, HttpServletRequest request) {
		CommonsMultipartResolver multipartResolver = new CommonsMultipartResolver(
				request.getSession().getServletContext());
		try {
			if (multipartResolver.isMultipart(request)) {
				MultipartHttpServletRequest multiRequest = (MultipartHttpServletRequest) request;

				String chunk = "";
				String md5 = "";
				for (Iterator<String> iterator = multiRequest.getFileNames(); iterator.hasNext();) {
					String key = iterator.next();
					MultipartFile multipartFile = multiRequest.getFile(key);

					if (multiRequest.getParameter("chunk") != null) {
						chunk = multiRequest.getParameter("chunk");
					}
					if (multiRequest.getParameter("fileMd5") != null) {
						md5 = multiRequest.getParameter("fileMd5");
					}
					// 分片文件夹
					String path = getUploadDir(request) + "romfile" + DateTimeUtil.getSystemDate() + File.separator
							+ "partFile" + File.separator + md5;
					File pathFile = new File(path);
					if (!pathFile.exists()) {
						pathFile.mkdirs();
					}
					File chunkFile = new File(
							path + File.separator + multipartFile.getOriginalFilename() + "_" + chunk + ".part");
					chunkFile.setWritable(true, false);
					// 在分片文件夹保存分片文件
					multipartFile.transferTo(chunkFile);

				}
			}
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			throw new ServiceException(e.getMessage());
		}
	}

	public static Map<String, Object> uploadMergeChunk(HttpServletRequest request) {
		try {
			Map<String, Object> result = new HashMap<>();
			String fileName = request.getParameter("fileName"); // 文件名称
			String manuNo = request.getParameter("manuNo");
			String md5 = request.getParameter("fileMd5");
			String pathDir = UPLOADERPATH + File.separator + manuNo + File.separator + fileName.split("_")[0]; // 文件最终位置
			String tempPath = getUploadDir(request) + "romfile" + DateTimeUtil.getSystemDate() + File.separator
					+ "partFile" + File.separator + md5; // 分片文件夹
			Path filePath = getUploadPath(pathDir);
			File pathFile = new File(tempPath);
			if (!pathFile.exists()) {
				pathFile.mkdirs();
			}
			// 最后
			// 读取目录里的所有文件
			File tempFile = new File(tempPath);
			File[] fileArray = tempFile.listFiles(new FileFilter() {
				// 排除目录只要文件
				@Override
				public boolean accept(File pathname) {
					if (pathname.isDirectory()) {
						return false;
					}
					return true;
				}
			});
			// 分片文件集合
			List<File> fileList = new ArrayList<>(Arrays.asList(fileArray));

			// 根据分片的最后数字正序排序
			Collections.sort(fileList, new Comparator<File>() {
				@Override
				public int compare(File o1, File o2) {
					String o1Name = o1.getName();
					int startIndex = o1Name.lastIndexOf('_');
					int endIndex = o1Name.lastIndexOf('.');
					String subString = StringUtils.isBlank(o1Name.substring(startIndex + 1, endIndex)) ? "0"
							: o1Name.substring(startIndex + 1, endIndex);
					String o2Name = o2.getName();
					int startIndex1 = o2Name.lastIndexOf('_');
					int endIndex1 = o2Name.lastIndexOf('.');
					String subString1 = StringUtils.isBlank(o2Name.substring(startIndex1 + 1, endIndex1)) ? "0"
							: o2Name.substring(startIndex1 + 1, endIndex1);
					if (Integer.parseInt(subString) < Integer.parseInt(subString1)) {
						return -1;
					}
					return 1;
				}
			});
			// 得到 destTempFile就是最终的文件
			File destTempFile = new File(filePath + File.separator + fileName);
			// 判断文件名为fileName是否已存在，如果存在则重新命名realFileName

			if (destTempFile.exists()) {
				if (StringUtils.equals(md5, FileUtils.md5Sum(filePath + File.separator + fileName))) {
					if (!destTempFile.delete()) {
						logger.error("{},文件删除失败!", destTempFile.getAbsolutePath());
					}
				} else {
					String suffix = FileUtils.getFileExtension(fileName);
					Random random = new Random();
					fileName = FileUtils.getFileNameWithoutExtension(fileName) + "_" + random.nextInt(99) + "."
							+ suffix;
					destTempFile = new File(filePath + File.separator + fileName);
				}

			}
			FileUtils.createFile(destTempFile.getAbsolutePath());
			// 输出流
			FileOutputStream fos = new FileOutputStream(destTempFile);
			FileChannel outChnnel = fos.getChannel();
			FileInputStream fis;
			// 合并分片文件
			FileChannel inChannel;
			for (File file : fileList) {
				logger.info(file.getAbsolutePath());
				fis = new FileInputStream(file);
				inChannel = fis.getChannel();
				inChannel.transferTo(0, inChannel.size(), outChnnel);
				inChannel.close();
				fis.close();
			}
			outChnnel.close();
			fos.close();
			// 删除临时目录中的分片文件
			FileUtils.deleteDirectory(pathFile.getAbsolutePath());
			result.put("fileSize", destTempFile.length());
			result.put("fileName", fileName);
			return result;
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw new ServiceException("合并文件失败");
		}
	}

	/**
	 * app文件上传文件处理(支持批量)
	 * 
	 * @throws IOException
	 * 
	 * @throws Exception
	 */
	public static Map<String, String> uploadFile(MultipartFile multipartFile, String filepath) throws IOException {

		Map<String, String> fileNames = Maps.newHashMap();

		String pathDir = UPLOADERPATH + File.separator + filepath;
		Path filePath = getUploadPath(pathDir);
		if (Files.notExists(filePath)) {
			Files.createDirectories(filePath);
		}

		String pathKey = "apkFilePath";
		String localKey = "apkFile";
		if (multipartFile != null && !multipartFile.isEmpty()) {
			String name = multipartFile.getOriginalFilename();
			try {
				Files.copy(multipartFile.getInputStream(), filePath.resolve(name), StandardCopyOption.REPLACE_EXISTING);
				fileNames.put(pathKey, pathDir + File.separator + name);
				fileNames.put(localKey, filepath + File.separator + name);
			} catch (Exception e) {
				logger.error(name + "保存失败", e);
			}
		}
		return fileNames;
	}

	/**
	 * appLogo上传文件处理(支持批量)
	 * 
	 * @throws Exception
	 */
	public static String uploadLogoFile(HttpServletRequest request, MultipartFile multipartFile) throws Exception {
		String fileName = "";
		String pathDir = getUploadDir(request) + "appLogo";
		Path filePath = getUploadPath(pathDir);
		if (Files.notExists(filePath)) {
			Files.createDirectories(filePath);
		}

		if (multipartFile != null && !multipartFile.isEmpty()) {
			String name = multipartFile.getOriginalFilename();
			int point = name.indexOf('.');
			String suffix = name.substring(point, name.length());
			fileName = UUID.randomUUID().toString() + suffix;
			try {
				Files.copy(multipartFile.getInputStream(), filePath.resolve(fileName),
						StandardCopyOption.REPLACE_EXISTING);
			} catch (Exception e) {
				logger.error(name + "保存失败", e);
			}
		}
		return fileName;
	}

	private static Path getUploadPath(String uploadDir) {
		return Paths.get(uploadDir);
	}

	/**
	 * 回填已有文件的缩略图
	 * 
	 * @param fileList
	 *            文件列表
	 * @param request
	 * @return initialPreiview initialPreviewConfig fileIds
	 */
	public static FileResult getPreivewSettings(String url, HttpServletRequest request) {

		List<String> previews = new ArrayList<>();
		String fileName = "";
		// 缓存当前的文件
		// if (FileUtils.isImage(url)) {
		fileName = getFileName(url);
		previews.add("<img src='" + getUrl(url) + "?v=" + (new Date().getTime())
				+ "' class='file-preview-image kv-preview-data' " + "style='width:auto;height:160px' alt='" + fileName
				+ " title='" + fileName + "''>");
		// }
		// 上传后预览配置
		FileResult fileResult = new FileResult();
		FileResult.PreviewConfig previewConfig = new FileResult.PreviewConfig();
		previewConfig.setWidth("120px");
		previewConfig.setCaption(fileName);
		previewConfig.setKey(fileName);
		previewConfig.setExtra(new FileResult.PreviewConfig.Extra(fileName));
		List<FileResult.PreviewConfig> previewConfigs = new ArrayList<>();
		previewConfigs.add(previewConfig);
		fileResult.setInitialPreview(previews);
		fileResult.setInitialPreviewConfig(previewConfigs);
		return fileResult;
	}

	public static Resource loadFileAsResource(String path) {
		Path file = Paths.get(path);
		try {
			Resource resource = new UrlResource(file.toUri());
			if (resource.exists() || resource.isReadable()) {
				return resource;
			} else {
				throw new ServiceException("Could not read file: " + path);

			}
		} catch (MalformedURLException e) {
			logger.error(e.getMessage());
			throw new ServiceException("Could not read file: " + path, e);
		}
	}

	public static String getUrl(String path) {
		String path2 = path.replace(File.separatorChar, '$');
		String uri = MvcUriComponentsBuilder.fromMethodName(UploaderController.class, "serveFile", path2).build()
				.toString();
		return uri;
	}

	public static String getFileName(String path) {

		String fileName = path.substring(path.lastIndexOf(File.separator) + 1);
		return fileName;
	}

}