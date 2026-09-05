using PazCitasWA.ServiciosWS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace PazCitasWA
{
    public partial class RegistrarAdministrador : System.Web.UI.Page
    {
        private AdministradorWSClient wsAdmin;
        private Estado estado;
        private administrador admin;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                
                DateTime maxDate = DateTime.Today.AddYears(-18);
                DateTime minDate = new DateTime(1940, 1, 1);

                dtpFechaNacimiento.Attributes["min"] = minDate.ToString("yyyy-MM-dd");
                dtpFechaNacimiento.Attributes["max"] = maxDate.ToString("yyyy-MM-dd");

                // Establecer el valor máximo de la fecha como la fecha actual
                rvFechaNacimiento.MaximumValue = DateTime.Today.ToString("yyyy-MM-dd");
            }

            string accion = Request.QueryString["accion"];
            if (accion == null)
            {
                estado = Estado.Nuevo;
                admin = new administrador();
                lblTitulo.Text = "Registrar Administrador";
            }
            else if (accion == "modificar")
            {
                estado = Estado.Modificar;
                lblTitulo.Text = "Modificar Administrador";
                admin = (administrador)Session["adminSeleccionado"];
                if (!IsPostBack)
                {

                    AsignarValores();
                    txtUsername.Enabled = false;
                    txtPassword.Enabled = false;
                }
            }
            else if(accion == "ver")
            {
                lblTitulo.Text = "Ver Administrador";
                admin = (administrador)Session["adminSeleccionado"];
                AsignarValores();
                txtDNI.Enabled = false;
                txtNombre.Enabled = false;
                txtPaterno.Enabled = false;
                txtMaterno.Enabled = false;
                txtEmail.Enabled = false;
                dtpFechaNacimiento.Disabled = true;
                rbFemenino.Disabled = true;
                rbMasculino.Disabled = true;
                txtUsername.Enabled = false;
                txtPassword.Enabled = false;
            }
        }

        protected void AsignarValores()
        {
            txtIDUsuario.Text = admin.idUsuario.ToString();
            txtDNI.Text = admin.dni;
            txtNombre.Text = admin.nombre;
            txtPaterno.Text = admin.apellidoPaterno;
            txtMaterno.Text = admin.apellidoMaterno;
            if (admin.genero.Equals('M')) rbMasculino.Checked = true;
            else rbFemenino.Checked = true;
            dtpFechaNacimiento.Value = admin.fechaNacimiento.ToString("yyyy-MM-dd");
            txtEmail.Text = admin.email;
        }

        protected void btnRegresar_Click(object sender, EventArgs e)
        {
            Response.Redirect("ListarAdministradores.aspx");
        }

        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            wsAdmin = new AdministradorWSClient();
            if (estado == Estado.Modificar)
            {
                // Asegúrate de que tomas el id que está en el TextBox oculto o similar:
                admin.idUsuario = Int32.Parse(txtIDUsuario.Text);
            }
            admin.dni = txtDNI.Text;
            admin.nombre = txtNombre.Text;
            admin.apellidoPaterno = txtPaterno.Text;
            admin.apellidoMaterno = txtMaterno.Text;
            admin.fechaNacimiento = DateTime.Parse(dtpFechaNacimiento.Value);
            admin.fechaNacimientoSpecified = true;
            if (rbMasculino.Checked) admin.genero = 'M';
            else if (rbFemenino.Checked) admin.genero = 'F';
            admin.email = txtEmail.Text;

            CuentaUsuarioWSClient wsCuenta = new CuentaUsuarioWSClient();
            cuentaUsuario cuenta = new cuentaUsuario();
            cuenta.username = txtUsername.Text;
            cuenta.password = txtPassword.Text;
            cuenta.rol = rol.ADMINISTRADOR;
            cuenta.rolSpecified = true;
            cuenta.usuario = admin;

            try
            {
                if (estado == Estado.Nuevo)
                {
                    var lista = wsAdmin.listarAdministrador();

                    bool dniRepetido = lista.Any(a => a.dni == admin.dni);
                    bool usernameRepetido = wsCuenta.usernameExiste(txtUsername.Text);

                    if (dniRepetido || usernameRepetido)
                    {
                        string mensaje = "Ya existe un administrador con ";
                        if (dniRepetido) mensaje += "el mismo DNI. ";
                        if (usernameRepetido) mensaje += "el mismo nombre de usuario.";

                        lanzarMensajedeError(mensaje.Trim());
                        return; // salir del método
                    }
                    int idInsertado = wsAdmin.insertarAdministrador(admin);
                    cuenta.usuario.idUsuario = idInsertado;
                    wsCuenta.insertarCuenta(cuenta);
                }
                else if (estado == Estado.Modificar)
                {
                    wsAdmin.modificarAdministrador(admin);
                }
            }
            catch (Exception ex)
            {
                throw;
            }

            Response.Redirect("ListarAdministradores.aspx");
        }
        public void lanzarMensajedeError(String mensaje)
        {
            lblMensajeError.Text = mensaje;
            string script = "mostrarModalError();";
            ScriptManager.RegisterStartupScript(this, GetType(), "modalError", script, true);
        }
        protected void cvGenero_ServerValidate(object source, ServerValidateEventArgs args)
        {
            // Verificar si algún radio button está seleccionado
            args.IsValid = rbMasculino.Checked || rbFemenino.Checked;
        }
    }
}