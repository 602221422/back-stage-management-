<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%
if session("guess")= "" or session("flag")<>"admin"then
	response.write"<script>alert('未登录，请先登录！');location.href='index.html'</script>"
 else if session("authority")=1 or session("authority")=4 then
    else
	response.write"<script>alert('权限不够！');location.href='admin_index.asp'</script>"
    end if
end if
Fname=""
if session("authority")=4 then
 Fname=session("guess")
 end if
%>
<!--#include file="conn.asp"-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>社团会员聊天记录表</title>
<link href="style/style7.css" rel="stylesheet" type="text/css" />
<link href="style.css" rel="stylesheet" type="text/css" />
</head>
<body>
<div align="right" style="height:35px">	
<br>               
<form id="formsearch" name="formsearch" method="get" action="t_club_message.asp">
 <label>
    &nbsp;&nbsp; <input name="search" id="search" maxlength="80" value="请输入聊天内容关键词" type="text" onclick="this.value=''" onblur="if(this.value=='')this.value='请输入聊天内容关键词';"/>
  </label>
 <label>
     <input type="submit" name="Submit" value="提交" />
</label>
</form>
<hr width="100%%" size="3" color="#0099FF" />	 
 </div><br><br><br><br>
<div class="content">
<div class="mainbar" style="height:350px">
<%
set rs=server.CreateObject("Adodb.Recordset")
if Fname="" then
   sql="select * from t_rc_message,t_student,t_club where t_rc_message.cl_no=t_club.cl_no and t_rc_message.s_no=t_student.s_no and (rc_content like '%"&request("search")&"%' ) order by rc_id asc"
else
  set rs1=server.CreateObject("Adodb.Recordset")
  sql="select * from t_club where s_no='"&Fname&"'"
  rs1.open sql,conn,3,1
  clno=rs1("cl_no")
  rs1.close
  set rs1=nothing
    sql="select * from t_rc_message,t_student,t_club where t_rc_message.cl_no=t_club.cl_no and t_rc_message.s_no=t_student.s_no and t_rc_message.cl_no='"&clno&"' and (rc_content like '%"&request("search")&"%' ) order by rc_id asc"
end if
rs.open sql,conn,3,1
if rs.eof then
response.Write("记录集合为空!")
else
rs.pagesize=8
nowpage=request.QueryString("page")
if nowpage="" then nowpage=1
nowpage=cint(nowpage)
if nowpage<1 then nowpage=1
if nowpage>rs.pagecount then nowpage=rs.pagecount
rs.absolutepage=nowpage
%>
          <p>
		  <table width="95%" border="0" cellpadding="0" cellspacing="0" class="main_table">
          <tr class="main_tr">
		    <td width="10%" height="30"><div align="center"><font color="#3366FF"><b>社团名称</b></font></div></td>
		    <td width="10%" height="30"><div align="center"><font color="#3366FF"><b>会员姓名</b></font></div></td>
			<td width="10%" height="30"><div align="center"><font color="#3366FF"><b>聊天内容</b></font></div></td>
		    <td width="10%" height="30"><div align="center"><font color="#3366FF"><b>聊天日期</b></font></div></td>
		    <td width="10%" height="30"><div align="center"><strong><font color="#3366FF">操作</font></strong></div></td>
		  </tr>
<%'输出当前页面记录
for i=0 to rs.pagesize-1
%>
		 <tr height="30">
		    <td ><div align="center"><%=rs("cl_name")%></div></td>
		    <td ><div align="center"><%=rs("s_name")%></div></td>
			<td ><div align="center"><%=rs("rc_content")%></div></td>
		    <td ><div align="center"><%=rs("rc_date")%></div></td>
		    <td ><div align="center"><a href="t_club_message_del.asp?Id=<%=rs("rc_id")%>">删除</a></div></td>
		    </tr>
<%
rs.movenext
if rs.eof then exit for
next
%> 
</tr>
</table>
</p>
</div>
<p class="pages" align="right">
<%
if nowpage<>1 then
response.Write("<a href='t_club_message.asp?page=1&search="&request("search")&"'>首页</a>&nbsp;<a href='t_club_message.asp?page="&nowpage-1&"&search="&request("search")&"'>上一页</a>&nbsp;")
end if
%>
第
<%
for i=1 to rs.pagecount
if i=nowpage then
response.Write("<span>"&i&"</span>&nbsp;")
else
response.Write("<a href='t_club_message.asp?page="&i&"&search="&request("search")&"'>"&i&"</a>&nbsp;")
end if
next
%>
页
<%
if nowpage<>rs.pagecount then
response.Write("<a href='t_club_message.asp?page="&nowpage+1&"&search="&request("search")&"'>下一页</a>&nbsp;<a href='t_club_message.asp?page="&rs.pagecount&"&search="&request("search")&"'>尾页</a>")
end if
end if
rs.close
set conn=nothing
%></p>
</div>
</body>
</html>
