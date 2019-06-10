package com.jiewen.jwp.base.query.domain;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.digester3.annotations.rules.ObjectCreate;
import org.apache.commons.digester3.annotations.rules.SetNext;

@ObjectCreate(pattern = "queryContext/query/beforeInit")
public class BeforeInit implements Serializable {
    /**
     * 
     */
    private static final long serialVersionUID = -7041766200980078842L;

    transient List<BeforeCall> beforeCallList;

    public BeforeInit() {
        beforeCallList = new ArrayList<>();
    }

    public void setBeforeCallList(List<BeforeCall> beforeCallList) {
        this.beforeCallList = beforeCallList;
    }

    @SetNext
    public void addBeforeCall(BeforeCall call) {
        beforeCallList.add(call);
    }

    public List<BeforeCall> getBeforeCallList() {
        return beforeCallList;
    }

}
