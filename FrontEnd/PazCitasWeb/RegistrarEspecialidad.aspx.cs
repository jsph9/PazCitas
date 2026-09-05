using PazCitasWA.ServiciosWS;
using System;
using System.Linq;
using System.Web.UI;

namespace PazCitasWA
{
    public partial class RegistrarEspecialidad : System.Web.UI.Page
    {
        private EspecialidadWSClient wsEspecialidad;
        private Estado estado;
        private especialidad objEspecialidad;
        protected void Page_Load(object sender, EventArgs e)
        {
            string accion = Request.QueryString["accion"];
            if (accion == null)
            {
                estado = Estado.Nuevo;
                objEspecialidad = new especialidad();
                lblTitulo.Text = "Registrar Especialidad";
            }
            else if (accion == "modificar")
            {
                estado = Estado.Modificar;
                lblTitulo.Text = "Modificar Especialidad";
                objEspecialidad = (especialidad)Session["espSeleccionada"];
                if (!IsPostBack)
                {
                    txtIDEspecialidad.Text = objEspecialidad.idEspecialidad.ToString();
                    txtNombre.Text = objEspecialidad.nombre;
                    txtDescripcion.Text = objEspecialidad.descripcion;
                }
            }
        }

        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            wsEspecialidad = new EspecialidadWSClient();
            objEspecialidad.nombre = txtNombre.Text;
            objEspecialidad.descripcion = txtDescripcion.Text;
            try
            {
                if (estado == Estado.Nuevo)
                {
                    var lista = wsEspecialidad.listarEspecialidad();

                    bool nombreRepetido = lista.Any(esp => esp.nombre == objEspecialidad.nombre);

                    if (nombreRepetido)
                    {
                        string mensaje = "Ya existe una especialidad con ese nombre";

                        lanzarMensajedeError(mensaje.Trim());
                        return; // salir del método
                    }
                    wsEspecialidad.insertarEspecialidad(objEspecialidad);
                }
                else if (estado == Estado.Modificar)
                {
                    wsEspecialidad.modificarEspecialidad(objEspecialidad);
                }
            }
            catch (Exception ex)
            {
                lanzarMensajedeError(ex.Message);
                return;
            }
            Response.Redirect("ListarEspecialidades.aspx");
        }
        public void lanzarMensajedeError(String mensaje)
        {
            lblMensajeError.Text = mensaje;
            string script = "mostrarModalError();";
            ScriptManager.RegisterStartupScript(this, GetType(), "modalError", script, true);
        }

        protected void btnRegresar_Click(object sender, EventArgs e)
        {
            Response.Redirect("ListarEspecialidades.aspx");
        }
    }
}