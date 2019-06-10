package com.jiewen.modules.sys.entity;

import com.jiewen.jwp.base.entity.DataEntity;

/**
 * 文章Entity
 */
public class Essay extends DataEntity {

    private static final long serialVersionUID = 1L;
    
    private String content;
    
    private String keyWords; 
    
    private String title;

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public String getKeyWords() {
		return keyWords;
	}

	public void setKeyWords(String keyWords) {
		this.keyWords = keyWords;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}
    
}