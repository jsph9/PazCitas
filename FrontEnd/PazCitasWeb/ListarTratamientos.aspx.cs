using PazCitasWA.ServiciosWS;
using System;
using System.ComponentModel;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace PazCitasWA
{
    public partial class ListarTratamientos : System.Web.UI.Page
    {
        private MedicamentoWSClient wsMedicamento;
        private BindingList<medicamento> medicamentos;
        protected void Page_Load(object sender, EventArgs e)
        {
            wsMedicamento = new MedicamentoWSClient();
            medicamentos = new BindingList<medicamento>(wsMedicamento.listarMedicamento());
            gvTratamientos.DataSource = medicamentos;
            gvTratamientos.DataBind();
        }

        protected void gvTratamientos_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvTratamientos.PageIndex = e.NewPageIndex;
            gvTratamientos.DataBind();
        }

        protected void btnModificar_Click(object sender, EventArgs e)
        {
            int idMedicamento = Int32.Parse(((LinkButton)sender).CommandArgument);
            medicamento medicamentoSeleccionado = medicamentos.SingleOrDefault(x => x.idMedicamento == idMedicamento);
            Session["medicamentoSeleccionado"] = medicamentoSeleccionado;
            Response.Redirect("RegistrarTratamiento.aspx?accion=modificar");
        }



        protected void btnRegistrar_Click(object sender, EventArgs e)
        {
            Response.Redirect("RegistrarTratamiento.aspx");
        }

        protected void gvTratamientos_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                int stock = Convert.ToInt32(DataBinder.Eval(e.Row.DataItem, "stock"));
                Label lblStock = (Label)e.Row.FindControl("lblStock");

                if (lblStock != null)
                {
                    if (stock <= 10)
                        lblStock.CssClass += " bg-danger";
                    else if (stock <= 50)
                        lblStock.CssClass += " bg-warning";
                    else
                        lblStock.CssClass += " bg-success";
                }
            }
        }

        protected void btnEliminar_Click(object sender, EventArgs e)
        {
            int idMedicamentoSelec = Int32.Parse(((LinkButton)sender).CommandArgument);
            wsMedicamento.eliminarMedicamento(idMedicamentoSelec);
            Response.Redirect("ListarTratamientos.aspx");
        }
    }
}