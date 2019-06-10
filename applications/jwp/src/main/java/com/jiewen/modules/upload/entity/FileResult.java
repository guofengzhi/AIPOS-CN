package com.jiewen.modules.upload.entity;

import java.util.List;

public class FileResult {

    private String error;

    private List<Integer> errorkeys;

    private List<FileResult.PreviewConfig> initialPreviewConfig;

    private List<String> initialPreview;

    private String fileIds;

    public String getError() {
        return error;
    }

    public void setError(String error) {
        this.error = error;
    }

    public List<Integer> getErrorkeys() {
        return errorkeys;
    }

    public void setErrorkeys(List<Integer> errorkeys) {
        this.errorkeys = errorkeys;
    }

    public List<String> getInitialPreview() {
        return initialPreview;
    }

    public void setInitialPreview(List<String> initialPreview) {
        this.initialPreview = initialPreview;
    }

    public List<FileResult.PreviewConfig> getInitialPreviewConfig() {
        return initialPreviewConfig;
    }

    public void setInitialPreviewConfig(List<FileResult.PreviewConfig> initialPreviewConfig) {
        this.initialPreviewConfig = initialPreviewConfig;
    }

    public String getFileIds() {
        return fileIds;
    }

    public void setFileIds(String fileIds) {
        this.fileIds = fileIds;
    }

    public static class PreviewConfig {

        public String width;

        public String caption;

        public String key;

        public String url;

        public long size;

        public Extra extra;

        public String getWidth() {
            return width;
        }

        public void setWidth(String width) {
            this.width = width;
        }

        public String getCaption() {
            return caption;
        }

        public void setCaption(String caption) {
            this.caption = caption;
        }

        public String getKey() {
            return key;
        }

        public void setKey(String key) {
            this.key = key;
        }

        public String getUrl() {
            return url;
        }

        public void setUrl(String url) {
            this.url = url;
        }

        public long getSize() {
            return size;
        }

        public void setSize(long size) {
            this.size = size;
        }

        public Extra getExtra() {
            return extra;
        }

        public void setExtra(Extra extra) {
            this.extra = extra;
        }

        public static class Extra {

            public Extra(String id) {
                this.id = id;
            }

            public String id;

            public String getId() {
                return id;
            }

            public void setId(String id) {
                this.id = id;
            }
        }
    }

}
