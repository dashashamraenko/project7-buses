<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Students.aspx.cs" Inherits="WebApp.Students" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

<h2>Students</h2>

  <div class="mb-2">
    <asp:TextBox ID="tbSearch" runat="server" CssClass="form-control" placeholder="Поиск по имени..." />
    <asp:Button ID="btnSearch" runat="server" Text="Найти" CssClass="btn btn-primary mt-1" />
  </div>

  <asp:SqlDataSource ID="dsStudents" runat="server"
      ConnectionString="<%$ ConnectionStrings:SchoolDb %>"
      DataSourceMode="DataSet"
      CancelSelectOnNullParameter="false"
      SelectCommand="
        SELECT StudentID, FirstMidName, LastName, EnrollmentDate
        FROM Students
        WHERE (@q IS NULL OR @q = '' OR LastName LIKE '%' + @q + '%' OR FirstMidName LIKE '%' + @q + '%')"
      UpdateCommand="UPDATE Students
                     SET FirstMidName=@FirstMidName, LastName=@LastName, EnrollmentDate=@EnrollmentDate
                     WHERE StudentID=@StudentID"
      DeleteCommand="DELETE FROM Students WHERE StudentID=@StudentID">
    <SelectParameters>
      <asp:ControlParameter Name="q" ControlID="tbSearch" PropertyName="Text" Type="String" DefaultValue="" />
    </SelectParameters>
    <UpdateParameters>
      <asp:Parameter Name="FirstMidName" Type="String" />
      <asp:Parameter Name="LastName" Type="String" />
      <asp:Parameter Name="EnrollmentDate" Type="DateTime" />
      <asp:Parameter Name="StudentID" Type="Int32" />
    </UpdateParameters>
    <DeleteParameters>
      <asp:Parameter Name="StudentID" Type="Int32" />
    </DeleteParameters>
  </asp:SqlDataSource>

  <asp:GridView ID="gvStudents" runat="server"
      DataSourceID="dsStudents" AutoGenerateColumns="False"
      AllowPaging="true" AllowSorting="true" PageSize="10"
      DataKeyNames="StudentID"
      OnRowUpdating="gvStudents_RowUpdating"
      OnRowUpdated="gvStudents_RowUpdated">
    <Columns>
      <asp:BoundField DataField="StudentID" HeaderText="ID" ReadOnly="True" SortExpression="StudentID" />

      <asp:TemplateField HeaderText="Name" SortExpression="LastName">
        <ItemTemplate><%# Eval("LastName") + ", " + Eval("FirstMidName") %></ItemTemplate>
        <EditItemTemplate>
          <asp:TextBox ID="tbLast"  runat="server" Text='<%# Bind("LastName") %>' />
          <asp:RequiredFieldValidator runat="server" ControlToValidate="tbLast"
              ValidationGroup="studEdit" ErrorMessage="*" Display="Dynamic" />
          <br />
          <asp:TextBox ID="tbFirst" runat="server" Text='<%# Bind("FirstMidName") %>' />
          <asp:RequiredFieldValidator runat="server" ControlToValidate="tbFirst"
              ValidationGroup="studEdit" ErrorMessage="*" Display="Dynamic" />
        </EditItemTemplate>
      </asp:TemplateField>

      <asp:TemplateField HeaderText="Enrolled" SortExpression="EnrollmentDate">
        <ItemTemplate><%# Eval("EnrollmentDate","{0:yyyy-MM-dd}") %></ItemTemplate>
        <EditItemTemplate>
          <asp:TextBox ID="tbDate" runat="server"
              Text='<%# Bind("EnrollmentDate","{0:yyyy-MM-dd}") %>'
              placeholder="yyyy-mm-dd" />
          <!-- обязательность -->
          <asp:RequiredFieldValidator runat="server" ControlToValidate="tbDate"
              ValidationGroup="studEdit" ErrorMessage="*" Display="Dynamic" />
          <!-- строгий формат -->
          <asp:RegularExpressionValidator runat="server" ControlToValidate="tbDate"
              ValidationGroup="studEdit"
              ValidationExpression="^\d{4}-\d{2}-\d{2}$"
              ErrorMessage="yyyy-mm-dd" Display="Dynamic" />
          <!-- не в будущем -->
          <asp:CustomValidator ID="cvDateEdit" runat="server" ControlToValidate="tbDate"
              ValidationGroup="studEdit"
              OnServerValidate="cvDateEdit_ServerValidate"
              ErrorMessage="Дата в будущем недопустима" Display="Dynamic" />
        </EditItemTemplate>
      </asp:TemplateField>

      <asp:CommandField ShowEditButton="true" ShowDeleteButton="true"
          CausesValidation="true" ValidationGroup="studEdit" />
    </Columns>
  </asp:GridView>

  <!-- сводка ошибок редактирования -->
  <asp:ValidationSummary ID="valSummary" runat="server"
      ValidationGroup="studEdit" CssClass="text-danger" DisplayMode="List" />

  <asp:Label ID="lblMsg" runat="server" CssClass="text-danger" EnableViewState="false" />
</asp:Content>



