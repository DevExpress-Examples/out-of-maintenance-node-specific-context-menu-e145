Imports Microsoft.VisualBasic
#Region "Using"
Imports System
Imports System.Text
Imports System.Web.UI
Imports DevExpress.Web.ASPxTreeList
#End Region

Partial Public Class TreeList_Integration_ContextMenuByHand_Default
	Inherits System.Web.UI.Page

	Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
		If Not IsPostBack Then
			ASPxTreeList1.DataBind()
			CreateNodeInfoScript()
		End If
	End Sub

	Private Sub CreateNodeInfoScript()
		Dim builder As New StringBuilder()
		builder.Append("var dxNodeInfo = { };" & Constants.vbLf)
		Dim iterator As TreeListNodeIterator = ASPxTreeList1.CreateNodeIterator()
		Dim node As TreeListNode
		Do
			node = iterator.GetNext()
			If node Is Nothing Then
				Exit Do
			End If
			builder.AppendFormat("dxNodeInfo['{0}'] = {1};" & Constants.vbLf, node.Key, GetNodeType(node))
		Loop
		ClientScript.RegisterClientScriptBlock(GetType(Page), "NodeInfo", String.Format("<script>{0}</script>", builder.ToString()))
	End Sub
	Private Function GetNodeType(ByVal node As TreeListNode) As Integer
		If node.HasChildren Then
			Return 1
		End If
		Return 2
	End Function

	Protected Sub ASPxTreeList1_HtmlRowPrepared(ByVal sender As Object, ByVal e As TreeListHtmlRowEventArgs)
		e.Row.Attributes("oncontextmenu") = String.Format("return tree_OnContextMenu('{0}', event)", e.GetValue(ASPxTreeList1.KeyFieldName).ToString())
	End Sub
	Protected Sub ASPxTreeList1_CustomCallback(ByVal sender As Object, ByVal e As TreeListCustomCallbackEventArgs)
		Dim data() As String = e.Argument.Split(":"c)
		If data.Length = 2 AndAlso data(0) = "parent" Then
			Dim key As String = data(1)
			Dim node As TreeListNode = ASPxTreeList1.FindNodeByKeyValue(key)
			node.Expanded = Not node.Expanded
		End If
	End Sub
End Class
