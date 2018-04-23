<%-- BeginRegion Page Settings --%>
<%@ Page Language="vb" AutoEventWireup="true" CodeFile="Default.aspx.vb" Inherits="TreeList_Integration_ContextMenuByHand_Default" %>
<%@ Register Assembly="DevExpress.Web.ASPxTreeList.v8.1" Namespace="DevExpress.Web.ASPxTreeList" TagPrefix="dxwtl" %>
<%@ Register Assembly="DevExpress.Web.v8.1" Namespace="DevExpress.Web.ASPxMenu" TagPrefix="dxm" %>
<%-- EndRegion --%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
<title>Node-specific context menu</title>
<script type="text/javascript">
var dxMenuNodeKey;
function tree_OnContextMenu(key, htmlEvent) {            
	dxMenuNodeKey = key;
	var type = dxNodeInfo[key];            
	menu.GetItem(0).SetEnabled(type == 1);
	menu.GetItem(1).SetEnabled(type == 2);        
	var menuX = ASPxClientUtils.GetEventX(htmlEvent);
	var menuY = ASPxClientUtils.GetEventY(htmlEvent);
	menu.ShowAtPos(menuX, menuY);
	return false;
}
function menu_OnItemClick(s, e) {
	switch(e.item.index) {
		case 0:
			tree.PerformCustomCallback("parent:" + dxMenuNodeKey);
			break;
		case 1:
			alert("Node key is: " + dxMenuNodeKey);
			break;
		case 2:
			alert("ASPxTreeList v2008 vol 1.2");
			break;
	}
}
</script>
</head>
<body>
	<form id="form1" runat="server">
		<%-- BeginRegion ASPxTreeList --%>
		<dxwtl:ASPxTreeList ID="ASPxTreeList1" runat="server" AutoGenerateColumns="False"
			DataSourceID="AccessDataSource1" KeyFieldName="ID" ParentFieldName="ParentID" ClientInstanceName="tree" OnHtmlRowPrepared="ASPxTreeList1_HtmlRowPrepared" OnCustomCallback="ASPxTreeList1_CustomCallback">            
			<Columns>
				<dxwtl:TreeListDataColumn FieldName="Department" VisibleIndex="0" />                
				<dxwtl:TreeListDataColumn FieldName="Location" VisibleIndex="1" />                
			</Columns>
			<SettingsBehavior AutoExpandAllNodes="true" />
		</dxwtl:ASPxTreeList>
		<%-- EndRegion --%>

		<%-- BeginRegion ASPxPopupMenu --%>
		<dxm:ASPxPopupMenu ID="ASPxPopupMenu1" runat="server" ClientInstanceName="menu">
			<ClientSideEvents ItemClick="menu_OnItemClick" />
			<Items>
				<dxm:MenuItem Text="Expand / Collapse" />
				<dxm:MenuItem Text="Get node info..." />
				<dxm:MenuItem Text="About..." />
			</Items>
		</dxm:ASPxPopupMenu>
		<%-- EndRegion --%>
		<%-- BeginRegion AccessDataSource --%>
		<asp:AccessDataSource ID="AccessDataSource1" runat="server" DataFile="~/App_Data/Departments.mdb"
			SelectCommand="SELECT [ID], [ParentID], [Department], [Location] FROM [Departments]">
		</asp:AccessDataSource>    
		<%-- EndRegion --%>        
	</form>
</body>
</html>