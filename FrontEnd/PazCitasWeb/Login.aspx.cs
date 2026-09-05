using System;
using System.Web;
using System.Web.UI;
using PazCitasWA.ServiciosWS;

namespace PazCitasWA
{
    public partial class Login : System.Web.UI.Page
    {
        private CuentaUsuarioWSClient bocuenta;

        protected void Page_Load(object sender, EventArgs e)
        {
            bocuenta = new CuentaUsuarioWSClient();

            if (!IsPostBack)
            {
                string rolUrl = Request.QueryString["rol"];
                if (!string.IsNullOrEmpty(rolUrl))
                {
                    switch (rolUrl.ToLower())
                    {
                        case "paciente":
                            Session["rolSeleccionado"] = "PACIENTE";
                            break;
                        case "medico":
                            Session["rolSeleccionado"] = "MÉDICO";
                            break;
                        case "admin":
                            Session["rolSeleccionado"] = "ADMINISTRADOR";
                            break;
                        default:
                            Session["rolSeleccionado"] = "";
                            break;
                    }
                }
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string identificador = txtUsuario.Text.Trim();
            string password = txtClave.Text.Trim();
            string rol = Session["rolSeleccionado"]?.ToString() ?? "";

            int resultado = bocuenta.verificarCuenta(identificador, password, rol);

            if (resultado > 0)
            {
                Session["id_usuario"] = resultado;
                Session["rol"] = rol;

                // Redirección según el rol
                switch (rol)
                {
                    case "PACIENTE":
                        Response.Redirect("ListarCitasPaciente.aspx");
                        break;
                    case "MÉDICO":
                        Response.Redirect("HomeMedico.aspx");
                        break;
                    case "ADMINISTRADOR":
                        Response.Redirect("HomeAdmin.aspx");
                        break;
                    default:
                        Response.Redirect("Inicio.aspx");
                        break;
                }
            }
            else
            {
                lblMensaje.Text = "*Error al iniciar Sesion \n credenciales incorrectas o invalidas*"; // opcional, limpiar
            }
        }

        protected void btnRegistro_Click(object sender, EventArgs e)
        {
            // Implementar lógica de registro si aplica
        }
    }
}
