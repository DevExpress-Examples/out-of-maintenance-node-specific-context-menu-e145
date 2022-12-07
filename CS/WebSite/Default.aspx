<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>

<%@ Register Assembly="DevExpress.Web.v15.1, Version=15.1.15.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a"
    Namespace="DevExpress.Web" TagPrefix="dx" %>

<%@ Register Assembly="DevExpress.Web.ASPxTreeList.v15.1, Version=15.1.15.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a"
    Namespace="DevExpress.Web.ASPxTreeList" TagPrefix="dx" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Node-specific context menu</title>

    <script type="text/javascript" language="javascript">
        var key = "";
    
        function OnContextMenu (s, e) {
            if (e.objectType == "Node") {
                key = e.objectKey;
                
                /* prepare popup menu */                
                var state = tree.GetNodeState(e.objectKey);
                
                popupMenu.GetItem(0).SetEnabled(state != "Child" && state != "NotFound");  
                popupMenu.GetItem(1).SetEnabled(state == "Child" || state == "NotFound");                
                
                popupMenu.ShowAtPos(ASPxClientUtils.GetEventX(e.htmlEvent), ASPxClientUtils.GetEventY(e.htmlEvent));                
            }
        }
        
        function menu_OnItemClick(s, e) {
            switch(e.item.index) {
                case 0:
                    var state = tree.GetNodeState(key);
                    if (state == "Expanded")
                        tree.CollapseNode(key);
                    else
                        tree.ExpandNode(key);
                    break;
                    
                case 1:
                    alert("Node key is: " + key);
                    break;
                    
                case 2:
                    alert("ASPxTreeList v2010 vol 1.5");
                    break;
            }
        }
    </script>

</head>
<body>
    <form id="form1" runat="server">
        <div>
            <dx:ASPxTreeList ID="tree" runat="server" AutoGenerateColumns="False" DataSourceID="ads"
                KeyFieldName="ID" ParentFieldName="ParentID" ClientInstanceName="tree">
                <Columns>
                    <dx:TreeListDataColumn FieldName="Department" VisibleIndex="0" />
                    <dx:TreeListDataColumn FieldName="Location" VisibleIndex="1" />
                </Columns>
                <SettingsBehavior AutoExpandAllNodes="true" />
                <ClientSideEvents ContextMenu="OnContextMenu" />
            </dx:ASPxTreeList>
            <dx:ASPxPopupMenu ID="popupMenu" runat="server" ClientInstanceName="popupMenu">
                <ClientSideEvents ItemClick="menu_OnItemClick" />
                <Items>
                    <dx:MenuItem Text="Expand / Collapse" />
                    <dx:MenuItem Text="Get node info..." />
                    <dx:MenuItem Text="About..." />
                </Items>
            </dx:ASPxPopupMenu>
            <asp:AccessDataSource ID="ads" runat="server" DataFile="~/App_Data/Departments.mdb"
                SelectCommand="SELECT [ID], [ParentID], [Department], [Location] FROM [Departments]">
            </asp:AccessDataSource>
        </div>
    </form>
</body>
</html>
