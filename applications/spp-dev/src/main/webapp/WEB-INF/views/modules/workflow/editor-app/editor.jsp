<%@page contentType="text/html;charset=UTF-8"%>
<div ng-controller="StencilController">
  <div class="subheader editor-toolbar" id="editor-header">
  	<div class="btn-group">
	    <div class="btn-toolbar pull-left" ng-controller="ToolbarController" ng-cloak>
        	<button id="{{item.id}}"
                    title="{{item.title | translate}}"
                    ng-repeat="item in items"
                    ng-switch on="item.type"
                    class="btn btn-inverse" ng-class="{'separator': item.type == 'separator'}"
                    ng-disabled="item.type == 'separator' || item.enabled == false"
                    ng-click="toolbarButtonClicked($index)">
        		<i ng-switch-when="button" ng-class="item.cssClass" class="toolbar-button" data-toggle="tooltip" title="{{item.title | translate}}"></i>
	            <div ng-switch-when="separator" ng-class="item.cssClass"></div>
        	</button>
  		  </div>
        </div>
        <div class="btn-group pull-right" ng-show="!secondaryItems.length">
	        <div class="btn-toolbar pull-right" ng-controller="ToolbarController">
        	<button title="{{item.title | translate}}" ng-repeat="item in secondaryItems" ng-switch on="item.type" class="btn btn-inverse" ng-class="{'separator': item.type == 'separator'}"
                ng-disabled="item.type == 'separator'" ng-click="toolbarSecondaryButtonClicked($index)" id="{{item.id}}">
        		<i ng-switch-when="button" ng-class="item.cssClass" class="toolbar-button" data-toggle="tooltip" title="{{item.title | translate}}"></i>
	            <div ng-switch-when="separator" ng-class="item.cssClass"></div>
        	</button>
  		  </div>
        </div>
  </div>
  <div class="full">
      <div class="row row-no-gutter">
	      <div id="paletteHelpWrapper" class="col-xs-3">
	      	<div class="stencils" id="paletteSection">
			    <div ng-if="stencilItemGroups.length > 1">
                    <div ng-repeat="group in stencilItemGroups">

                        <ul ng-if="group.visible && group.items" class="stencil-group"  ng-class="{collapsed: !group.expanded, 'first': $first}">
                            <li ng-include="'${basePath}/editor-app/partials/stencil-item-template'"></li>
                        </ul>

                        <div ng-if="!group.items" ng-include="'${basePath}/editor-app/partials/root-stencil-item-template'"></div>

                    </div>
			    </div>
			    <div ng-if="stencilItemGroups.length == 1">
	                <ul class="stencil-group">
	                    <li ng-repeat="item in stencilItemGroups[0].paletteItems" class="stencil-item"
	                         id="{{item.id}}"
	                         title="{{item.description}}"
	                         ng-model="draggedElement"
	                         data-drag="true"
	                         jqyoui-draggable="{onStart:'startDragCallback', onDrag:'dragCallback'}"
	                         data-jqyoui-options="{revert: 'invalid', helper: 'clone', opacity : 0.5}">
	                         
	                        <img ng-src="${basePath}/common/libs/activiti/editor-app/stencilsets/bpmn2.0/icons/{{item.icon}}" width="16px;" height="16px;"/>
	                        {{item.name}}
	                    </li>
                    </ul>
			     </div>
		      </div>
	      </div>
	      <div id="canvasHelpWrapper" class="col-xs-9">
	      	<div class="canvas-wrapper" id="canvasSection" 
	      		ng-model="droppedElement"
                  ng-model="droppedElement"
                  data-drop="true"
                  data-jqyoui-options
                  jqyoui-droppable="{onDrop:'dropCallback',onOver: 'overCallback', onOut: 'outCallback'}"> 
            	<div class="canvas-message" id="model-modified-date"></div>
            	<div class="Oryx_button" 
            	     id="delete-button" 
            	     title="{{'BUTTON.ACTION.DELETE.TOOLTIP' | translate}}"
            	     ng-click="deleteShape()"
            	     style="display:none">
            	    <img src="${basePath}/common/libs/activiti/editor-app/images/delete.png"/>
            	</div>
            	<div class="Oryx_button" 
            	     id="morph-button"
            	     title="{{'BUTTON.ACTION.MORPH.TOOLTIP' | translate}}"
            	     ng-click="morphShape()"
            	     style="display:none">
            	    <img src="${basePath}/common/libs/activiti/editor-app/images/wrench.png"/>
            	</div>
            	<div class="Oryx_button"
            		 ng-repeat="item in quickMenuItems"
	                 id="{{item.id}}"
	                 title="{{item.description}}"
	                 ng-click="quickAddItem(item.id)"
            	     ng-model="draggedElement"
	                 data-drag="true"
	                 jqyoui-draggable="{onStart:'startDragCallbackQuickMenu', onDrag:'dragCallbackQuickMenu'}"
	                 data-jqyoui-options="{revert: 'invalid', helper: 'clone', opacity : 0.5}"
	                 style="display:none">
	             	<img ng-src="${basePath}/common/libs/activiti/editor-app/stencilsets/bpmn2.0/icons/{{item.icon}}"/>
	             </div>
	         </div>
           </div>
           <div id="propertiesHelpWrapper" class="col-xs-9">
            	<div class="propertySection" id="propertySection"
                	ng-class="{collapsed: propertyWindowState.collapsed}">
	                <div class="selected-item-section">
	                	<div class="clearfix">
		                    <div class="pull-right" ng-if="selectedItem.auditData.createDate">
		                        <strong>{{'ELEMENT.DATE_CREATED' | translate}}: </strong> {{selectedItem.auditData.createDate}}
		                    </div>
		                    <div class="pull-right" ng-if="selectedItem.auditData.author">
		                        <strong>{{'ELEMENT.AUTHOR' | translate}}: </strong> {{selectedItem.auditData.author}}
		                    </div>
		                    <div class="selected-item-title">
		                        <a ng-click="propertyWindowState.toggle()"> 
		                            <i class="glyphicon" ng-class="{'glyphicon-chevron-right': propertyWindowState.collapsed, 'glyphicon-chevron-down': !propertyWindowState.collapsed}"></i>
		                            <span ng-show="selectedItem.title != undefined && selectedItem.title != null && selectedItem.title.length > 0">{{selectedItem.title}}</span> 
		                            <span ng-show="!selectedItem || selectedItem.title == undefined || selectedItem.title == null || selectedItem.title.length == 0">{{modelData.name}}</span>
		                        </a>
		                    </div>
		                </div>
                    	<div class="selected-item-body">
	                        <div>
	                             <div class="property-row" ng-repeat="property in selectedItem.properties"
	                                ng-click="propertyClicked($index)" ng-class="{'clear' : $index%2 == 0}">
	                                <span class="title" ng-if="!property.hidden">{{ property.title }}&nbsp;:</span>
	                                <span class="title-removed" ng-if="property.hidden"><i>{{ property.title }}&nbsp;({{'PROPERTY.REMOVED' | translate}})&nbsp;:</i></span>
	                                <span class="value"> 
	                                    <ng-include
	                                        src="getPropertyTemplateUrl($index)" ng-if="!property.hasReadWriteMode"></ng-include>
	                                    <ng-include src="getPropertyReadModeTemplateUrl($index)"
	                                        ng-if="property.hasReadWriteMode && property.mode == 'read'"></ng-include>
	                                    <ng-include src="getPropertyWriteModeTemplateUrl($index)"
	                                        ng-if="property.hasReadWriteMode && property.mode == 'write'"></ng-include>
	                                </span>
	                            </div>
	                        </div>
	                    </div>
	    			</div>     
    			</div>            
            </div>
         </div>
    </div>
</div>
