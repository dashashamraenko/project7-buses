<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Courses.aspx.cs" Inherits="WebApp.Courses" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
 <h2>Courses by Department</h2>

  <!-- Departments (SQL) -->
  <asp:SqlDataSource ID="dsDepartments" runat="server"
      ConnectionString="<%$ ConnectionStrings:SchoolDb %>"
      SelectCommand="SELECT DepartmentID, Name FROM Departments ORDER BY Name" />

  <asp:DropDownList ID="ddlDept" runat="server"
      DataSourceID="dsDepartments" DataTextField="Name" DataValueField="DepartmentID"
      AutoPostBack="true" />

  <!-- Courses filtered by selected Department (SQL) -->
  <asp:SqlDataSource ID="dsCourses" runat="server"
      ConnectionString="<%$ ConnectionStrings:SchoolDb %>"
      SelectCommand="SELECT CourseID, Title, Credits FROM Courses WHERE DepartmentID=@DeptId ORDER BY Title">
    <SelectParameters>
      <asp:ControlParameter Name="DeptId" ControlID="ddlDept" PropertyName="SelectedValue" Type="Int32" />
    </SelectParameters>
  </asp:SqlDataSource>

  <asp:GridView ID="gvCourses" runat="server"
      DataSourceID="dsCourses" AutoGenerateColumns="False" CssClass="table table-striped">
    <Columns>
      <asp:BoundField DataField="CourseID" HeaderText="ID" ReadOnly="True" />
      <asp:BoundField DataField="Title" HeaderText="Title" />
      <asp:BoundField DataField="Credits" HeaderText="Credits" />
    </Columns>
  </asp:GridView>
</asp:Content>
