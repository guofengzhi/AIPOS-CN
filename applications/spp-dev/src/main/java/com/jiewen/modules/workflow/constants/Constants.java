package com.jiewen.modules.workflow.constants;

/**
 * 
 */
public class Constants {
    /** 审批结果 **/
    public static final String APPROVE_RESULT = "approved";

    /** 审批意见 **/
    public static final String APPROVE_SUGGESTION = "suggestion";

    /** 已执行 **/
    public static final String STATE_DONE = "0";

    /** 正在执行（下一步执行节点） **/
    public static final String STATE_DOING = "1";

    /** 尚未执行节点 **/
    public static final String STATE_TODO = "2";

    /** 办理中 **/
    public static final String STATE_INSTANCE_DOING = "0";

    /** 办结 **/
    public static final String STATE_INSTANCE_DONE = "1";

    public static final String IDENTITY_ASSIGNEE = "assignee";

    public static final String IDENTITY_GROUP = "group";

    public static final String IDENTITY_USER = "user";

    public static final String WITHDRAW_YES = "1";

    public static final String WITHDRAW_NO = "0";

    /** 通过 **/
    public static final String APPROVED_PASSED = "1";

    /** 拒绝 **/
    public static final String APPROVED_REJECT = "0";

    public static final String[] APPROVED_PASSED_TEXT = { "同意", "通过", "批准", "提交" };

    public static final String[] APPROVED_REJECT_TEXT = { "拒绝", "不同意", "不批准", "终止" };

    public static final String VAR_FORM_URL = "local_form_url";

    public static final String VAR_APPLYUSER_NAME = "applyUserName";

    public static final String VAR_APPLYUSER_ID = "applyUserId";

    public static final String VAR_BUSINESS_KEY = "businessKey";

    /** 临时保存 **/
    public static final int FLOW_STATE_SAVE = 0;

    /** 审批中 **/
    public static final int FLOW_STATE_DOING = 1;

    /** 审批通过 **/
    public static final int FLOW_STATE_DONE = 2;

    /** 强制结束 **/
    public static final int FLOW_STATE_CLOSE = 3;

    /** 待定 **/
    public static final String INDETERMINATE = "待定";
}
