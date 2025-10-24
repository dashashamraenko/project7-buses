using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApp
{
    public partial class Enrollments1 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected void btnEnroll_OnClick(object sender, EventArgs e)
        {
            lblMsg.Text = "";

            if (string.IsNullOrEmpty(ddlStudent.SelectedValue) || string.IsNullOrEmpty(ddlCourse.SelectedValue))
            {
                lblMsg.Text = "Выберите студента и курс.";
                return;
            }

            dsEnrollmentsInsert.InsertParameters["StudentID"].DefaultValue = ddlStudent.SelectedValue;
            dsEnrollmentsInsert.InsertParameters["CourseID"].DefaultValue = ddlCourse.SelectedValue;

            try
            {
                dsEnrollmentsInsert.Insert();
                // Обновим список зачислений
                gvEnrollments.DataBind();
            }
            catch (SqlException ex)
            {
                // Напр., уникальный индекс (один и тот же курс дважды) или другие ошибки
                lblMsg.Text = "Не удалось записать студента на курс. Такой студент уже записан."; //+ ex.Message;
            }
            catch (Exception ex)
            {
                lblMsg.Text = "Ошибка при записи на курс. " + ex.Message;
            }
        }
    }

}
