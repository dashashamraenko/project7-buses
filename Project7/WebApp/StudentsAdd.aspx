<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="StudentsAdd.aspx.cs" Inherits="WebApp.StudentsAdd" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
 <h2>Add Student</h2>

  <!-- Сводка ошибок формы -->
  <asp:ValidationSummary ID="valSummary" runat="server"
      ValidationGroup="addStud" CssClass="text-danger" DisplayMode="List" />

  <asp:SqlDataSource ID="dsInsertStudent" runat="server"
      ConnectionString="<%$ ConnectionStrings:SchoolDb %>"
      InsertCommand="INSERT INTO Students (FirstMidName, LastName, EnrollmentDate) VALUES (@FirstMidName, @LastName, @EnrollmentDate)"
      OnInserted="dsInsertStudent_Inserted">
    <InsertParameters>
      <asp:Parameter Name="FirstMidName" Type="String" />
      <asp:Parameter Name="LastName" Type="String" />
      <asp:Parameter Name="EnrollmentDate" Type="DateTime" />
    </InsertParameters>
  </asp:SqlDataSource>

  <asp:DetailsView ID="dvStudent" runat="server"
      DataSourceID="dsInsertStudent" DefaultMode="Insert" AutoGenerateRows="False"
      OnItemInserting="dvStudent_ItemInserting"
      OnItemInserted="dvStudent_ItemInserted">
    <Fields>

      <asp:TemplateField HeaderText="First (Middle) Name">
        <InsertItemTemplate>
          <asp:TextBox ID="tbFirst" runat="server" placeholder="First/Middle name" />
          <asp:RequiredFieldValidator runat="server" ControlToValidate="tbFirst"
              ValidationGroup="addStud" SetFocusOnError="true"
              ErrorMessage="First/Middle name is required" Display="Dynamic" />
        </InsertItemTemplate>
      </asp:TemplateField>

      <asp:TemplateField HeaderText="Last Name">
        <InsertItemTemplate>
          <asp:TextBox ID="tbLast" runat="server" placeholder="Last name" />
          <asp:RequiredFieldValidator runat="server" ControlToValidate="tbLast"
              ValidationGroup="addStud" SetFocusOnError="true"
              ErrorMessage="Last name is required" Display="Dynamic" />
        </InsertItemTemplate>
      </asp:TemplateField>

      <asp:TemplateField HeaderText="Enrollment Date (yyyy-mm-dd)">
        <InsertItemTemplate>
          <asp:TextBox ID="tbDate" runat="server" placeholder="yyyy-mm-dd" />
  
          <asp:RequiredFieldValidator runat="server" ControlToValidate="tbDate"
              ValidationGroup="addStud" SetFocusOnError="true"
              ErrorMessage="Date is required" Display="Dynamic" />
   
          <asp:RegularExpressionValidator runat="server" ControlToValidate="tbDate"
              ValidationGroup="addStud" SetFocusOnError="true"
              ValidationExpression="^\d{4}-\d{2}-\d{2}$"
              ErrorMessage="Date format must be yyyy-mm-dd" Display="Dynamic" />

          <asp:CustomValidator ID="cvDate" runat="server" ControlToValidate="tbDate"
              ValidationGroup="addStud" SetFocusOnError="true"
              OnServerValidate="cvDate_ServerValidate"
              ErrorMessage="Date cannot be in the future" Display="Dynamic" />
        </InsertItemTemplate>
      </asp:TemplateField>

      <asp:CommandField ShowInsertButton="true" InsertText="Add Student"
                        CausesValidation="true" ValidationGroup="addStud" />
    </Fields>
  </asp:DetailsView>

  <asp:Label ID="lblMsg" runat="server" CssClass="text-danger" />
</asp:Content>
