using PazCitasWA.ServiciosWS;
using System;
using System.Collections;
using System.ComponentModel;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace PazCitasWA
{
    public partial class HistorialesMedicos : System.Web.UI.Page
    {
        private HistorialMedicoWSClient wsHistorialMedico;
        private BindingList<historialMedico> historiales;
        protected void Page_Load(object sender, EventArgs e)
        {
            wsHistorialMedico = new HistorialMedicoWSClient();
            historiales = new BindingList<historialMedico>(wsHistorialMedico.listarHistorial());
            gvHistoriales.DataSource = historiales;
            gvHistoriales.DataBind();
        }

        protected void gvHistoriales_RowDataBound(object sender, System.Web.UI.WebControls.GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                e.Row.Cells[0].Text = DataBinder.Eval(e.Row.DataItem, "idHistorial").ToString();
                e.Row.Cells[1].Text = DataBinder.Eval(e.Row.DataItem, "paciente.nombre").ToString() + " " +
                    DataBinder.Eval(e.Row.DataItem, "paciente.apellidoPaterno").ToString() + " " +
                    DataBinder.Eval(e.Row.DataItem, "paciente.apellidoMaterno").ToString();
                e.Row.Cells[2].Text = DataBinder.Eval(e.Row.DataItem, "paciente.dni").ToString();
                e.Row.Cells[3].Text = DataBinder.Eval(e.Row.DataItem, "fechaActualizacion").ToString();
            }
        }

        protected void gvHistoriales_PageIndexChanging(object sender, System.Web.UI.WebControls.GridViewPageEventArgs e)
        {
            gvHistoriales.PageIndex = e.NewPageIndex;
            gvHistoriales.DataBind();
        }
    }
}