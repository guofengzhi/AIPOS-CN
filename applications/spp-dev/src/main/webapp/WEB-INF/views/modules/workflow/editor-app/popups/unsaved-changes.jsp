<%@page contentType="text/html;charset=UTF-8"%>
<div class="modal" ng-controller="EditorUnsavedChangesPopupCrtl">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h2 translate="EDITOR.POPUP.UNSAVED-CHANGES.TITLE"></h2>
            </div>
            <div class="modal-body">
            	<p translate="EDITOR.POPUP.UNSAVED-CHANGES.DESCRIPTION"></p>
            </div>
            <div class="modal-footer">
            	<div class="pull-right">
                	<button class="btn btn-danger" ng-click="ok()" translate="EDITOR.POPUP.UNSAVED-CHANGES.ACTION.DISCARD"></button>
                	<button class="btn btn-default" ng-click="cancel()" translate="EDITOR.POPUP.UNSAVED-CHANGES.ACTION.CONTINUE"></button>
                </div>
            	<div class="loading pull-right" ng-show="loading">
            		<div class="l1"></div><div class="l2"></div><div class="l2"></div>
            	</div>
            </div>
        </div>
    </div>
</div>