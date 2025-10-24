<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Enrollments.aspx.cs" Inherits="WebApp.Enrollments1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Enrollments (зачисления)</h2>

  <!-- Студенты -->
  <asp:SqlDataSource ID="dsStudents" runat="server"
      ConnectionString="<%$ ConnectionStrings:SchoolDb %>"
      SelectCommand="
        SELECT StudentID, (LastName + N' ' + FirstMidName) AS FullName
        FROM Students
        ORDER BY LastName, FirstMidName" />

  <div class="mb-2">
    <label>Студент:</label>
    <asp:DropDownList ID="ddlStudent" runat="server"
        DataSourceID="dsStudents" DataTextField="FullName" DataValueField="StudentID"
        AutoPostBack="true" />
  </div>

  <!-- Курсы (с названием кафедры для удобства) -->
  <asp:SqlDataSource ID="dsCourses" runat="server"
      ConnectionString="<%$ ConnectionStrings:SchoolDb %>"
      SelectCommand="
        SELECT c.CourseID,
               (c.Title + N' (' + d.Name + N')') AS CourseName
        FROM Courses c
        JOIN Departments d ON d.DepartmentID = c.DepartmentID
        ORDER BY d.Name, c.Title" />

  <div class="mb-3">
    <label>Курс:</label>
    <asp:DropDownList ID="ddlCourse" runat="server"
        DataSourceID="dsCourses" DataTextField="CourseName" DataValueField="CourseID" />
    <asp:Button ID="btnEnroll" runat="server" Text="Записать"
        CssClass="btn btn-primary ms-2" OnClick="btnEnroll_OnClick" />
  </div>

  <asp:SqlDataSource ID="dsEnrollmentsInsert" runat="server"
      ConnectionString="<%$ ConnectionStrings:SchoolDb %>"
      InsertCommand="INSERT INTO Enrollments (StudentID, CourseID) VALUES (@StudentID, @CourseID)">
    <InsertParameters>
      <asp:Parameter Name="StudentID" Type="Int32" />
      <asp:Parameter Name="CourseID"  Type="Int32" />
    </InsertParameters>
  </asp:SqlDataSource>

  <asp:SqlDataSource ID="dsEnrollmentsList" runat="server"
      ConnectionString="<%$ ConnectionStrings:SchoolDb %>"
      DataSourceMode="DataSet"
      SelectCommand="
        SELECT e.EnrollmentID, c.Title, c.Credits, d.Name AS Department
        FROM Enrollments e
        JOIN Courses c     ON c.CourseID = e.CourseID
        JOIN Departments d ON d.DepartmentID = c.DepartmentID
        WHERE e.StudentID = @StudentID
        ORDER BY d.Name, c.Title"
      DeleteCommand="DELETE FROM Enrollments WHERE EnrollmentID=@EnrollmentID">
    <SelectParameters>
      <asp:ControlParameter Name="StudentID" ControlID="ddlStudent" PropertyName="SelectedValue" Type="Int32" />
    </SelectParameters>
    <DeleteParameters>
      <asp:Parameter Name="EnrollmentID" Type="Int32" />
    </DeleteParameters>
  </asp:SqlDataSource>

  <asp:GridView ID="gvEnrollments" runat="server"
      DataSourceID="dsEnrollmentsList" AutoGenerateColumns="False"
      DataKeyNames="EnrollmentID" CssClass="table table-striped" AllowSorting="true">
    <Columns>
      <asp:BoundField DataField="Department" HeaderText="Department" SortExpression="Department" />
      <asp:BoundField DataField="Title"      HeaderText="Course"     SortExpression="Title" />
      <asp:BoundField DataField="Credits"    HeaderText="Credits"    SortExpression="Credits" />
      <asp:CommandField ShowDeleteButton="true" />
    </Columns>
  </asp:GridView>

  <asp:Label ID="lblMsg" runat="server" CssClass="text-danger" EnableViewState="false" />
</asp:Content>
