package com.jiewen.jwp.base.utils;

import java.awt.Image;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.RandomAccessFile;
import java.util.List;

import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.codec.digest.DigestUtils;
import org.apache.commons.io.IOUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.google.common.collect.Lists;
import com.jiewen.commons.util.IOUtil;
import com.jiewen.jwp.common.Encodes;
import com.jiewen.jwp.common.StringUtils;

public class FileUtils extends org.apache.commons.io.FileUtils {
	private static Logger logger = LoggerFactory.getLogger(FileUtils.class);

	public static boolean copyFile(String srcFileName, String descFileName) {
		return copyFileCover(srcFileName, descFileName, false);
	}

	public static boolean copyFileCover(String srcFileName, String descFileName, boolean coverlay) {
		File srcFile = new File(srcFileName);
		if (!srcFile.exists()) {
			logger.debug("复制文件失败，源文件 " + srcFileName + " 不存在!");
			return false;
		}
		if (!srcFile.isFile()) {
			logger.debug("复制文件失败，" + srcFileName + " 不是一个文件!");
			return false;
		}
		File descFile = new File(descFileName);
		if (descFile.exists()) {
			if (coverlay) {
				logger.debug("目标文件已存在，准备删除!");
				if (!delFile(descFileName)) {
					logger.debug("删除目标文件 " + descFileName + " 失败!");
					return false;
				}
			} else {
				logger.debug("复制文件失败，目标文件 " + descFileName + " 已存在!");
				return false;
			}
		} else if (!descFile.getParentFile().exists()) {
			logger.debug("目标文件所在的目录不存在，创建目录!");
			if (!descFile.getParentFile().mkdirs()) {
				logger.debug("创建目标文件所在的目录失败!");
				return false;
			}
		}
		int readByte = 0;
		InputStream ins = null;
		OutputStream outs = null;
		try {
			ins = new FileInputStream(srcFile);

			outs = new FileOutputStream(descFile);
			byte[] buf = new byte[1024];
			while ((readByte = ins.read(buf)) != -1) {
				outs.write(buf, 0, readByte);
			}
			logger.debug("复制单个文件 " + srcFileName + " 到" + descFileName + "成功!");
			return true;
		} catch (Exception e) {
			boolean bool;
			logger.debug("复制文件失败：" + e.getMessage());
			return false;
		} finally {
			IOUtil.closeQuietly(outs);
			IOUtil.closeQuietly(ins);
		}
	}

	public static boolean copyDirectory(String srcDirName, String descDirName) {
		return copyDirectoryCover(srcDirName, descDirName, false);
	}

	public static boolean copyDirectoryCover(String srcDirName, String descDirName, boolean coverlay) {
		File srcDir = new File(srcDirName);
		if (!srcDir.exists()) {
			logger.debug("复制目录失败，源目录 " + srcDirName + " 不存在!");
			return false;
		}
		if (!srcDir.isDirectory()) {
			logger.debug("复制目录失败，" + srcDirName + " 不是一个目录!");
			return false;
		}
		String descDirNames = descDirName;
		if (!descDirNames.endsWith(File.separator)) {
			descDirNames = descDirNames + File.separator;
		}
		File descDir = new File(descDirNames);
		if (descDir.exists()) {
			if (coverlay) {
				logger.debug("目标目录已存在，准备删除!");
				if (!delFile(descDirNames)) {
					logger.debug("删除目录 " + descDirNames + " 失败!");
					return false;
				}
			} else {
				logger.debug("目标目录复制失败，目标目录 " + descDirNames + " 已存在!");
				return false;
			}
		} else {
			logger.debug("目标目录不存在，准备创建!");
			if (!descDir.mkdirs()) {
				logger.debug("创建目标目录失败!");
				return false;
			}
		}
		boolean isCopySuccess = true;

		File[] files = srcDir.listFiles();
		for (int i = 0; i < files.length; i++) {
			if (files[i].isFile()) {
				isCopySuccess = copyFile(files[i].getAbsolutePath(), descDirName + files[i].getName());
				if (!isCopySuccess) {
					break;
				}
			} else if (files[i].isDirectory()) {
				isCopySuccess = copyDirectory(files[i].getAbsolutePath(), descDirName + files[i].getName());
				if (!isCopySuccess) {
					break;
				}
			}
		}
		if (!isCopySuccess) {
			logger.debug("复制目录 " + srcDirName + " 到 " + descDirName + " 失败!");
			return false;
		}
		logger.debug("复制目录 " + srcDirName + " 到 " + descDirName + " 成功!");
		return true;
	}

	public static boolean delFile(String fileName) {
		File file = new File(fileName);
		if (!file.exists()) {
			logger.debug(fileName + " 文件不存在!");
			return true;
		}
		if (file.isFile()) {
			return deleteFile(fileName);
		}
		return deleteDirectory(fileName);
	}

	public static boolean deleteFile(String fileName) {
		File file = new File(fileName);
		if ((file.exists()) && (file.isFile())) {
			if (file.delete()) {
				logger.debug("删除文件 " + fileName + " 成功!");
				return true;
			}
			logger.debug("删除文件 " + fileName + " 失败!");
			return false;
		}
		logger.debug(fileName + " 文件不存在!");
		return true;
	}

	public static boolean deleteDirectory(String dirName) {
		String dirNames = dirName;
		if (!dirNames.endsWith(File.separator)) {
			dirNames = dirNames + File.separator;
		}
		File dirFile = new File(dirNames);
		if ((!dirFile.exists()) || (!dirFile.isDirectory())) {
			logger.debug(dirNames + " 目录不存在!");
			return true;
		}
		boolean isDeleteSuccess = true;

		File[] files = dirFile.listFiles();
		for (int i = 0; i < files.length; i++) {
			if (files[i].isFile()) {
				isDeleteSuccess = deleteFile(files[i].getAbsolutePath());
				if (!isDeleteSuccess) {
					break;
				}
			} else if (files[i].isDirectory()) {
				isDeleteSuccess = deleteDirectory(files[i].getAbsolutePath());
				if (!isDeleteSuccess) {
					break;
				}
			}
		}
		if (!isDeleteSuccess) {
			logger.debug("删除目录失败!");
			return false;
		}
		if (dirFile.delete()) {
			logger.debug("删除目录 " + dirName + " 成功!");
			return true;
		}
		logger.debug("删除目录 " + dirName + " 失败!");
		return false;
	}

	public static boolean createFile(String descFileName) {
		File file = new File(descFileName);
		if (file.exists()) {
			logger.debug("文件 " + descFileName + " 已存在!");
			return false;
		}
		if (descFileName.endsWith(File.separator)) {
			logger.debug(descFileName + " 为目录，不能创建目录!");
			return false;
		}
		if (!file.getParentFile().exists()) {
			if (!file.getParentFile().mkdirs()) {
				logger.debug("创建文件所在的目录失败!");
				return false;
			}
		}
		try {
			if (file.createNewFile()) {
				logger.debug(descFileName + " 文件创建成功!");
				return true;
			}
			logger.debug(descFileName + " 文件创建失败!");
			return false;
		} catch (Exception e) {
			logger.debug(descFileName + " 文件创建失败!" + e.getMessage());
		}
		return false;
	}

	public static boolean createDirectory(String descDirName) {
		String descDirNames = descDirName;
		if (!descDirNames.endsWith(File.separator)) {
			descDirNames = descDirNames + File.separator;
		}
		File descDir = new File(descDirNames);
		if (descDir.exists()) {
			logger.debug("目录 " + descDirNames + " 已存在!");
			return false;
		}
		if (descDir.mkdirs()) {
			logger.debug("目录 " + descDirNames + " 创建成功!");
			return true;
		}
		logger.debug("目录 " + descDirNames + " 创建失败!");
		return false;
	}

	public static String getContentType(String returnFileName) {
		String contentType = "application/octet-stream";
		if (returnFileName.lastIndexOf(".") < 0) {
			return contentType;
		}
		returnFileName = returnFileName.toLowerCase();
		returnFileName = returnFileName.substring(returnFileName.lastIndexOf(".") + 1);
		if ((returnFileName.equals("html")) || (returnFileName.equals("htm")) || (returnFileName.equals("shtml"))) {
			contentType = "text/html";
		} else if (returnFileName.equals("apk")) {
			contentType = "application/vnd.android.package-archive";
		} else if (returnFileName.equals("sis")) {
			contentType = "application/vnd.symbian.install";
		} else if (returnFileName.equals("sisx")) {
			contentType = "application/vnd.symbian.install";
		} else if (returnFileName.equals("exe")) {
			contentType = "application/x-msdownload";
		} else if (returnFileName.equals("msi")) {
			contentType = "application/x-msdownload";
		} else if (returnFileName.equals("css")) {
			contentType = "text/css";
		} else if (returnFileName.equals("xml")) {
			contentType = "text/xml";
		} else if (returnFileName.equals("gif")) {
			contentType = "image/gif";
		} else if ((returnFileName.equals("jpeg")) || (returnFileName.equals("jpg"))) {
			contentType = "image/jpeg";
		} else if (returnFileName.equals("js")) {
			contentType = "application/x-javascript";
		} else if (returnFileName.equals("atom")) {
			contentType = "application/atom+xml";
		} else if (returnFileName.equals("rss")) {
			contentType = "application/rss+xml";
		} else if (returnFileName.equals("mml")) {
			contentType = "text/mathml";
		} else if (returnFileName.equals("txt")) {
			contentType = "text/plain";
		} else if (returnFileName.equals("jad")) {
			contentType = "text/vnd.sun.j2me.app-descriptor";
		} else if (returnFileName.equals("wml")) {
			contentType = "text/vnd.wap.wml";
		} else if (returnFileName.equals("htc")) {
			contentType = "text/x-component";
		} else if (returnFileName.equals("png")) {
			contentType = "image/png";
		} else if ((returnFileName.equals("tif")) || (returnFileName.equals("tiff"))) {
			contentType = "image/tiff";
		} else if (returnFileName.equals("wbmp")) {
			contentType = "image/vnd.wap.wbmp";
		} else if (returnFileName.equals("ico")) {
			contentType = "image/x-icon";
		} else if (returnFileName.equals("jng")) {
			contentType = "image/x-jng";
		} else if (returnFileName.equals("bmp")) {
			contentType = "image/x-ms-bmp";
		} else if (returnFileName.equals("svg")) {
			contentType = "image/svg+xml";
		} else if ((returnFileName.equals("jar")) || (returnFileName.equals("var")) || (returnFileName.equals("ear"))) {
			contentType = "application/java-archive";
		} else if (returnFileName.equals("doc")) {
			contentType = "application/msword";
		} else if (returnFileName.equals("pdf")) {
			contentType = "application/pdf";
		} else if (returnFileName.equals("rtf")) {
			contentType = "application/rtf";
		} else if (returnFileName.equals("xls")) {
			contentType = "application/vnd.ms-excel";
		} else if (returnFileName.equals("ppt")) {
			contentType = "application/vnd.ms-powerpoint";
		} else if (returnFileName.equals("7z")) {
			contentType = "application/x-7z-compressed";
		} else if (returnFileName.equals("rar")) {
			contentType = "application/x-rar-compressed";
		} else if (returnFileName.equals("swf")) {
			contentType = "application/x-shockwave-flash";
		} else if (returnFileName.equals("rpm")) {
			contentType = "application/x-redhat-package-manager";
		} else if ((returnFileName.equals("der")) || (returnFileName.equals("pem")) || (returnFileName.equals("crt"))) {
			contentType = "application/x-x509-ca-cert";
		} else if (returnFileName.equals("xhtml")) {
			contentType = "application/xhtml+xml";
		} else if (returnFileName.equals("zip")) {
			contentType = "application/zip";
		} else if ((returnFileName.equals("mid")) || (returnFileName.equals("midi"))
				|| (returnFileName.equals("kar"))) {
			contentType = "audio/midi";
		} else if (returnFileName.equals("mp3")) {
			contentType = "audio/mpeg";
		} else if (returnFileName.equals("ogg")) {
			contentType = "audio/ogg";
		} else if (returnFileName.equals("m4a")) {
			contentType = "audio/x-m4a";
		} else if (returnFileName.equals("ra")) {
			contentType = "audio/x-realaudio";
		} else if ((returnFileName.equals("3gpp")) || (returnFileName.equals("3gp"))) {
			contentType = "video/3gpp";
		} else if (returnFileName.equals("mp4")) {
			contentType = "video/mp4";
		} else if ((returnFileName.equals("mpeg")) || (returnFileName.equals("mpg"))) {
			contentType = "video/mpeg";
		} else if (returnFileName.equals("mov")) {
			contentType = "video/quicktime";
		} else if (returnFileName.equals("flv")) {
			contentType = "video/x-flv";
		} else if (returnFileName.equals("m4v")) {
			contentType = "video/x-m4v";
		} else if (returnFileName.equals("mng")) {
			contentType = "video/x-mng";
		} else if ((returnFileName.equals("asx")) || (returnFileName.equals("asf"))) {
			contentType = "video/x-ms-asf";
		} else if (returnFileName.equals("wmv")) {
			contentType = "video/x-ms-wmv";
		} else if (returnFileName.equals("avi")) {
			contentType = "video/x-msvideo";
		}
		return contentType;
	}

	public static String downFile(File file, HttpServletRequest request, HttpServletResponse response) {
		return downFile(file, request, response, null);
	}

	public static String downFile(File file, HttpServletRequest request, HttpServletResponse response,
			String fileName) {
		String error = null;
		if ((file != null) && (file.exists())) {
			if (file.isFile()) {
				if (file.length() <= 0L) {
					error = "该文件是一个空文件。";
				}
				if (!file.canRead()) {
					error = "该文件没有读取权限。";
				}
			} else {
				error = "该文件是一个文件夹。";
			}
		} else {
			error = "文件已丢失或不存在！";
		}
		if (error != null) {
			return error;
		}
		long fileLength = file.length();
		long pastLength = 0L;
		int rangeSwitch = 0;
		long toLength = 0L;
		long contentLength = 0L;
		String rangeBytes = "";
		RandomAccessFile raf = null;
		OutputStream os = null;
		OutputStream out = null;
		byte[] b = new byte[1024];
		if (request.getHeader("Range") != null) {
			response.setStatus(206);
			logger.debug("request.getHeader(\"Range\") = " + request.getHeader("Range"));
			rangeBytes = request.getHeader("Range").replaceAll("bytes=", "");
			if (rangeBytes.indexOf('-') == rangeBytes.length() - 1) {
				rangeSwitch = 1;
				rangeBytes = rangeBytes.substring(0, rangeBytes.indexOf('-'));
				pastLength = Long.parseLong(rangeBytes.trim());
				contentLength = fileLength - pastLength;
			} else {
				rangeSwitch = 2;
				String temp0 = rangeBytes.substring(0, rangeBytes.indexOf('-'));
				String temp2 = rangeBytes.substring(rangeBytes.indexOf('-') + 1, rangeBytes.length());
				pastLength = Long.parseLong(temp0.trim());

				toLength = Long.parseLong(temp2);

				contentLength = toLength - pastLength;
			}
		} else {
			contentLength = fileLength;
		}
		response.reset();
		if (pastLength != 0L) {
			response.setHeader("Accept-Ranges", "bytes");

			logger.debug("---------------不是从头开始进行下载！服务器即将开始断点续传...");
			switch (rangeSwitch) {
			case 1:
				String contentRange = "bytes " + new Long(pastLength).toString() + "-"
						+ new Long(fileLength - 1L).toString() + "/" + new Long(fileLength).toString();

				response.setHeader("Content-Range", contentRange);
				break;
			case 2:
				String contentRange1 = rangeBytes + "/" + new Long(fileLength).toString();
				response.setHeader("Content-Range", contentRange1);
				break;
			}
		} else {
			logger.debug("---------------是从头开始进行下载！");
		}
		try {
			response.addHeader("Content-Disposition", "attachment; filename=\""
					+ Encodes.urlEncode(StringUtils.isBlank(fileName) ? file.getName() : fileName) + "\"");

			response.setContentType(getContentType(file.getName()));

			response.addHeader("Content-Length", String.valueOf(contentLength));
			os = response.getOutputStream();
			out = new BufferedOutputStream(os);
			raf = new RandomAccessFile(file, "r");
			try {
				int n;
				switch (rangeSwitch) {
				case 0:
				case 1:
					raf.seek(pastLength);
					n = 0;
				case 2:
					while ((n = raf.read(b, 0, 1024)) != -1) {
						out.write(b, 0, n);
						continue;
					}
				}
				out.flush();
				logger.debug("---------------下载完成！");
			} catch (IOException ie) {
				logger.debug("提醒：向客户端传输时出现IO异常，但此异常是允许的，有可能客户端取消了下载，导致此异常，不用关心！");
			}
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		} finally {
			IOUtils.closeQuietly(out);
			IOUtils.closeQuietly(os);
			IOUtils.closeQuietly(raf);
		}
		return null;
	}

	public static String path(String path) {
		String p = StringUtils.replace(path, "\\", "/");
		p = StringUtils.join(StringUtils.split(p, "/"), "/");
		if (!StringUtils.startsWithAny(p, new CharSequence[] { "/" })) {
			if (StringUtils.startsWithAny(path, new CharSequence[] { "\\", "/" })) {
				p = p + "/";
			}
		}
		if (!StringUtils.endsWithAny(p, new CharSequence[] { "/" })) {
			if (StringUtils.endsWithAny(path, new CharSequence[] { "\\", "/" })) {
				p = p + "/";
			}
		}
		if ((path != null) && (path.startsWith("/"))) {
			p = "/" + p;
		}
		return p;
	}

	public static List<String> findChildrenList(File dir, boolean searchDirs) {
		List<String> files = Lists.newArrayList();
		for (String subFiles : dir.list()) {
			File file = new File(dir + "/" + subFiles);
			if (((searchDirs) && (file.isDirectory())) || ((!searchDirs) && (!file.isDirectory()))) {
				files.add(file.getName());
			}
		}
		return files;
	}

	public static String getFileExtension(String fileName) {
		if ((fileName == null) || (fileName.lastIndexOf(".") == -1)
				|| (fileName.lastIndexOf(".") == fileName.length() - 1)) {
			return null;
		}
		return StringUtils.lowerCase(fileName.substring(fileName.lastIndexOf(".") + 1));
	}

	public static String getFileNameWithoutExtension(String fileName) {
		if ((fileName == null) || (fileName.lastIndexOf(".") == -1)) {
			return null;
		}
		return fileName.substring(0, fileName.lastIndexOf("."));
	}

	public static boolean isImage(String path) {
		File imageFile = new File(path);
		if (!imageFile.exists()) {
			return false;
		}
		Image img = null;
		try {
			img = ImageIO.read(imageFile);
			boolean bool1;
			if ((img == null) || (img.getWidth(null) <= 0) || (img.getHeight(null) <= 0)) {
				return false;
			}
			return true;
		} catch (Exception e) {
			return false;
		} finally {
			img = null;
		}
	}

	public static String md5Sum(String path) {
		String value = null;
		File file = new File(path);
		FileInputStream in = null;
		try {
			in = new FileInputStream(file);

			value = DigestUtils.md5Hex(in);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		} finally {
			IOUtil.closeQuietly(in);
		}
		return value;
	}
}
