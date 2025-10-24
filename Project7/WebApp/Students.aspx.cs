using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApp
{
    public partial class Students : System.Web.UI.Page
    {

        // строгая проверка и «не в будущем»
        protected void cvDateEdit_ServerValidate(object source, ServerValidateEventArgs args)
        {
            args.IsValid = DateTime.TryParseExact(args.Value, "yyyy-MM-dd",
                          CultureInfo.InvariantCulture, DateTimeStyles.None, out var dt)
                          && dt <= DateTime.Today;
        }

        // последняя проверка перед UPDATE (если клиентские валидаторы обошли)
        protected void gvStudents_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            if (e.NewValues["EnrollmentDate"] is string s &&
                (!DateTime.TryParseExact(s, "yyyy-MM-dd",
                    CultureInfo.InvariantCulture, DateTimeStyles.None, out var dt) || dt > DateTime.Today))
            {
                e.Cancel = true;
                lblMsg.Text = "Введите корректную дату в формате yyyy-MM-dd (и не будущую).";
            }
        }

        // дружелюбное сообщение при исключениях БД/конвертации
        protected void gvStudents_RowUpdated(object sender, GridViewUpdatedEventArgs e)
        {
            if (e.Exception != null || e.AffectedRows <= 0)
            {
                lblMsg.Text = "Ошибка при сохранении. Проверьте дату.";
                if (e.Exception != null) e.ExceptionHandled = true;
            }
        }

    }
}