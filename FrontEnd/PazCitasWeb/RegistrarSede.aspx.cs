using PazCitasWA.ServiciosWS;
using System;
using System.Web.UI.WebControls;

namespace PazCitasWA
{
    public partial class RegistrarSede : System.Web.UI.Page
    {
        private SedeWSClient wsSede;
        private Estado estado;
        private sede objSede;
        private ReporteWSClient boReporte;
        protected void Page_Load(object sender, EventArgs e)
        {
            string accion = Request.QueryString["accion"];
            if (accion == null)
            {
                estado = Estado.Nuevo;
                objSede = new sede();
                lblTitulo.Text = "Registrar Sede";


                pnlReporteSede.Visible = false;
                
            }
            else if (accion == "modificar")
            {
                estado = Estado.Modificar;
                lblTitulo.Text = "Modificar Sede";
                objSede = (sede)Session["sedeSeleccionada"];
                if (!IsPostBack)
                {
                    txtIDSede.Text = objSede.idSede.ToString();
                    txtNombre.Text = objSede.nombre;
                    txtDireccion.Text = objSede.direccion;
                }
                pnlReporteSede.Visible = false;

            }
            else if (accion == "ver")
            {
                estado = Estado.Ver;
                lblTitulo.Text = "Ver Sede";
                objSede = (sede)Session["sedeSeleccionada"];
                if (!IsPostBack)
                {
                    txtIDSede.Text = objSede.idSede.ToString();

                    txtNombre.Text = objSede.nombre;
                    txtNombre.Enabled = false;
                    txtDireccion.Text = objSede.direccion;
                    txtDireccion.Enabled = false;


                }
            }
        }
        protected void btnRegresar_Click(object sender, EventArgs e)
        {
            Response.Redirect("ListarSedes.aspx");
        }

        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            wsSede = new SedeWSClient();
            objSede.nombre = txtNombre.Text;
            objSede.direccion = txtDireccion.Text;
            try
            {
                if (estado == Estado.Nuevo)
                {
                    wsSede.insertarSede(objSede);
                }
                else if (estado == Estado.Modificar)
                {
                    wsSede.modificarSede(objSede);
                }
            }
            catch (Exception ex)
            {
                /*lblMensajeError.Text = ex.Message;
                string script =
                    "mostrarModalError();";
                ScriptManager.RegisterStartupScript
                    (this, GetType(), "modalError", script, true);
                return;*/
            }
            Response.Redirect("ListarSedes.aspx");
        }

        protected void btnReporteSede_Click(object sender, EventArgs e)
        {
            boReporte = new ReporteWSClient();

            /*if (Session["medico"] != null)
            {
                medico med = (medico)Session["medico"];
                
            }*/
            administrador admin = (administrador)Session["admin"];
            objSede = (sede)Session["sedeSeleccionada"];
            byte[] reporte = boReporte.generarReporteCitasXSede(admin.nombre,objSede);
            Response.Clear();
            Response.ContentType = "application/pdf";
            Response.AddHeader("Content-Disposition", "inline;filename=ReporteCitasProgramadas");
            Response.BinaryWrite(reporte);
            Response.End();
        }
    }
}