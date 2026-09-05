using PazCitasWA.ServiciosWS;
using System;
using System.ComponentModel;
using System.Linq;
using System.Web.UI.WebControls;

namespace PazCitasWA
{
    public partial class ListarSedes : System.Web.UI.Page
    {
        private SedeWSClient wsSede;
        private BindingList<sede> sedes;
        protected void Page_Load(object sender, EventArgs e)
        {
            wsSede = new SedeWSClient();
            sedes = new BindingList<sede>(wsSede.listarSede());
            gvSedes.DataSource = sedes;
            gvSedes.DataBind();
        }

        protected void btnRegistrar_Click(object sender, EventArgs e)
        {
            Response.Redirect("RegistrarSede.aspx");
        }

        protected void gvSedes_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvSedes.PageIndex = e.NewPageIndex;
            gvSedes.DataBind();

        }

        protected void btnModificar_Click(object sender, EventArgs e)
        {
            int idSede = Int32.Parse(((LinkButton)sender).CommandArgument);
            sede sedeSeleccionada = sedes.SingleOrDefault(x => x.idSede == idSede);
            Session["sedeSeleccionada"] = sedeSeleccionada;
            Response.Redirect("RegistrarSede.aspx?accion=modificar");
        }

        protected void btnEliminar_Click(object sender, EventArgs e)
        {
            int idSede = Int32.Parse(((LinkButton)sender).CommandArgument);
            wsSede.eliminarSede(idSede);
            Response.Redirect("ListarSedes.aspx");
        }

        protected void btnEspecialidades_Click(object sender, EventArgs e)
        {
            int idSede = Int32.Parse(((LinkButton)sender).CommandArgument);
            Response.Redirect($"AsignarEspecialidades.aspx?idSede={idSede}");
        }

        protected void btnVizualisar_Click(object sender, EventArgs e)
        {
            int idSede = Int32.Parse(((LinkButton)sender).CommandArgument);
            sede sedeSeleccionada = sedes.SingleOrDefault(x => x.idSede == idSede);
            Session["sedeSeleccionada"] = sedeSeleccionada;
            Response.Redirect("RegistrarSede.aspx?accion=ver");
        }
    }
}