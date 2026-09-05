using PazCitasWA.ServiciosWS;
using System;

namespace PazCitasWA
{
    public partial class HomeAdmin : System.Web.UI.Page
    {
        administrador adm;
        AdministradorWSClient wsAdmin;
        protected void Page_Load(object sender, EventArgs e)
        {
            wsAdmin = new AdministradorWSClient();
            if (!IsPostBack)
            {
                int idAdmin = (int)Session["id_usuario"];
                adm = wsAdmin.obtenerPorIDAdministrador(idAdmin);
                Session["admin"] = adm;
                lblBienvenida.Text = $"Bienvenido(a), Doctor(a) {adm.nombre} {adm.apellidoPaterno}";

            }
        }
    }
}