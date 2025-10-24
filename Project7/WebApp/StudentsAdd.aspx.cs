using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApp
{
    public partial class StudentsAdd : System.Web.UI.Page
    {
        // Строгая проверка даты и «не в будущем»
        protected void cvDate_ServerValidate(object source, ServerValidateEventArgs args)
        {
            args.IsValid = DateTime.TryParseExact(args.Value, "yyyy-MM-dd",
                          CultureInfo.InvariantCulture, DateTimeStyles.None, out var dt)
                           && dt <= DateTime.Today;
        }

        // Дополнительная серверная валидация обязательных полей и парс даты
        protected void dvStudent_ItemInserting(object sender, DetailsViewInsertEventArgs e)
        {
            var tbFirst = (TextBox)dvStudent.FindControl("tbFirst");
            var tbLast = (TextBox)dvStudent.FindControl("tbLast");
            var tbDate = (TextBox)dvStudent.FindControl("tbDate");

            if (tbFirst == null || tbLast == null || tbDate == null)
            {
                e.Cancel = true;
                lblMsg.Text = "Internal error: controls not found.";
                return;
            }

            if (string.IsNullOrWhiteSpace(tbFirst.Text) || string.IsNullOrWhiteSpace(tbLast.Text))
            {
                e.Cancel = true;
                lblMsg.Text = "First and Last names are required.";
                return;
            }

            if (!DateTime.TryParseExact(tbDate.Text, "yyyy-MM-dd",
                    CultureInfo.InvariantCulture, DateTimeStyles.None, out var dt) || dt > DateTime.Today)
            {
                e.Cancel = true;
                lblMsg.Text = "Provide a valid date in yyyy-MM-dd (not in the future).";
                return;
            }

            // передаём значения параметрам InsertCommand
            e.Values["FirstMidName"] = tbFirst.Text.Trim();
            e.Values["LastName"] = tbLast.Text.Trim();
            e.Values["EnrollmentDate"] = dt;
        }

        // Сообщение при ошибке / редирект при успехе
        protected void dvStudent_ItemInserted(object sender, DetailsViewInsertedEventArgs e)
        {
            if (e.Exception != null || e.AffectedRows <= 0)
            {
                lblMsg.Text = "Insert failed. Please check the fields.";
                if (e.Exception != null) e.ExceptionHandled = true;
                return;
            }
            // Приёмка: сразу видим в списке
            Response.Redirect("~/Students.aspx");
        }

        // Ловим SQL-исключения источника данных (например, неверный тип)
        protected void dsInsertStudent_Inserted(object sender, SqlDataSourceStatusEventArgs e)
        {
            if (e.Exception != null || e.AffectedRows <= 0)
            {
                lblMsg.Text = "Unable to add student. Check the date format (yyyy-MM-dd).";
                if (e.Exception != null) e.ExceptionHandled = true;
            }
        }
    }
}

