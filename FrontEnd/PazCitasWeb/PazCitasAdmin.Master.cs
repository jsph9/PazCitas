using PazCitasWA.ServiciosWS;
using System;

namespace PazCitasWA
{
    public partial class PazCitas : System.Web.UI.MasterPage
    {
        AdministradorWSClient wsAdmin;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargarInformacionAdministrador();
            }
        }

        private void CargarInformacionAdministrador()
        {
            try
            {
                // Verificar si hay un administrador en sesión
                if (Session["id_usuario"] != null)
                {
                    int idAdmin = (int)Session["id_usuario"];
                    administrador adminSelect = new administrador();
                    wsAdmin = new AdministradorWSClient();
                    adminSelect = wsAdmin.obtenerPorIDAdministrador(idAdmin);
                    // Mostrar nombre completo del administrador
                    string nombreCompleto = $"{adminSelect.nombre} {adminSelect.apellidoPaterno}";

                    // Si el nombre es muy largo, truncarlo
                    if (nombreCompleto.Length > 20)
                    {
                        nombreCompleto = nombreCompleto.Substring(0, 17) + "...";
                    }

                    lblNombreCompleto.Text = nombreCompleto;
                }
                else
                {
                    // Si no hay sesión, redirigir al login
                    Response.Redirect("~/Inicio.aspx");
                }
            }
            catch (Exception ex)
            {
                // En caso de error, mostrar texto por defecto y log del error
                lblNombreCompleto.Text = "Administrador";

                // Opcional: Log del error
                System.Diagnostics.Debug.WriteLine($"Error cargando admin: {ex.Message}");
            }
        }

        // Método público para obtener información del admin desde páginas hijas
        public administrador ObtenerAdministradorActual()
        {
            if (Session["administrador"] != null)
            {
                return (administrador)Session["administrador"];
            }
            return null;
        }

        // Método para verificar si el usuario está autenticado
        public bool EstaAutenticado()
        {
            return Session["administrador"] != null;
        }

    }
}