#region Using
using System;
using System.Text;
using System.Web.UI;
using DevExpress.Web.ASPxTreeList;
#endregion

public partial class TreeList_Integration_ContextMenuByHand_Default : System.Web.UI.Page {

	protected void Page_Load(object sender, EventArgs e) {
		if(!IsPostBack) {
			ASPxTreeList1.DataBind();
			CreateNodeInfoScript();
		}		
	}

	void CreateNodeInfoScript() {
		StringBuilder builder = new StringBuilder();
		builder.Append("var dxNodeInfo = { };\n");
		TreeListNodeIterator iterator = ASPxTreeList1.CreateNodeIterator();
		TreeListNode node;
		while(true) {
			node = iterator.GetNext();
			if(node == null) break;
			builder.AppendFormat("dxNodeInfo['{0}'] = {1};\n", node.Key, GetNodeType(node));
		}
		ClientScript.RegisterClientScriptBlock(typeof(Page), 
			"NodeInfo", string.Format("<script>{0}</script>", builder.ToString()));
	}
	int GetNodeType(TreeListNode node) {
		if(node.HasChildren)
			return 1;
		return 2;
	}

	protected void ASPxTreeList1_HtmlRowPrepared(object sender, TreeListHtmlRowEventArgs e) {
		e.Row.Attributes["oncontextmenu"] = string.Format("return tree_OnContextMenu('{0}', event)", e.GetValue(ASPxTreeList1.KeyFieldName).ToString());
	}
	protected void ASPxTreeList1_CustomCallback(object sender, TreeListCustomCallbackEventArgs e) {
		string[] data = e.Argument.Split(':');
		if(data.Length == 2 && data[0] == "parent") {
			string key = data[1];
			TreeListNode node = ASPxTreeList1.FindNodeByKeyValue(key);
			node.Expanded = !node.Expanded;
		}
	}
}
