using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using PazCitasWA.ServiciosWS;

namespace PazCitasWA
{
    public partial class VisualizarReporte : System.Web.UI.Page
    {
        private ReporteWSClient boReporte;
        private AdministradorWSClient boAdministrador;
        protected void Page_Load(object sender, EventArgs e)
        {
            boReporte = new ReporteWSClient();
            boAdministrador = new AdministradorWSClient();
            string nombreAdmin = "";
            if (Session["id_usuario"] != null)
            {
                int idAdmin = (int)Session["id_usuario"];
                administrador admin = boAdministrador.obtenerPorIDAdministrador(idAdmin);
                nombreAdmin = admin.nombre + " " + admin.apellidoPaterno;
            }

            byte[] reporte = boReporte.generarReporteCita(nombreAdmin);
            Response.Clear();
            Response.ContentType = "application/pdf";
            Response.AddHeader("Content-Disposition", "inline;filename=ReporteCitasProgramadas");
            Response.BinaryWrite(reporte);
            Response.End();
        }
    }
}