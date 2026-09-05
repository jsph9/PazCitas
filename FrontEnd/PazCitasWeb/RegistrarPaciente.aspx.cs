using PazCitasWA.ServiciosWS;
using System;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace PazCitasWA
{
    public partial class RegistrarPaciente : System.Web.UI.Page
    {
        private PacienteWSClient wsPaciente;
        private SeguroWSClient wsSeguro;
        private Estado estado;
        private paciente paciente;
        private HistorialMedicoWSClient wsHistorial;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                wsSeguro = new SeguroWSClient();
                ddlSeguro.DataSource = wsSeguro.listarSeguro();
                ddlSeguro.DataTextField = "nombreSeguro";
                ddlSeguro.DataValueField = "idSeguro";
                ddlSeguro.DataBind();
                ddlSeguro.Items.Insert(0, new ListItem("-- Seleccione --", ""));

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
                paciente = new paciente();
                lblTitulo.Text = "Registrar Paciente";
            }
            else if (accion == "modificar")
            {
                estado = Estado.Modificar;
                lblTitulo.Text = "Modificar Paciente";
                paciente = (paciente)Session["pacienteSeleccionado"];
                if (!IsPostBack)
                {
                    AsignarValores();
                    txtUsername.Enabled = false;
                    txtPassword.Enabled = false;
                    rfvUsername.Enabled = false;
                    rfvPassword.Enabled = false;
                }
            }
            else if(accion == "ver")
            {
                lblTitulo.Text = "Ver Paciente";
                paciente = (paciente)Session["pacienteSeleccionado"];
                AsignarValores();
                txtDNI.Enabled= false;
                txtDireccion.Enabled = false;
                txtUsername.Text = "-- Solo visible para usuario --";
                txtPassword.Text = "-- Solo visible para usuario --";
                txtUsername.Enabled = false;
                txtPassword.Enabled = false;
                txtNombre.Enabled = false;
                txtPaterno.Enabled = false;
                txtMaterno.Enabled = false;
                txtTelefono.Enabled = false;
                txtEmail.Enabled = false;
                dtpFechaNacimiento.Disabled = true;
                ddlSeguro.Enabled = false;
                btnGuardar.Visible = false;
                rbMasculino.Disabled = true;
                rbFemenino.Disabled = true;
                rfvUsername.Enabled = false;
                rfvPassword.Enabled = false;
            }

        }

        protected void AsignarValores()
        {
            txtIDUsuario.Text = paciente.idUsuario.ToString();
            txtDNI.Text = paciente.dni;
            txtNombre.Text = paciente.nombre;
            txtPaterno.Text = paciente.apellidoPaterno;
            txtMaterno.Text = paciente.apellidoMaterno;
            if (paciente.genero.Equals('M')) rbMasculino.Checked = true;
            else rbFemenino.Checked = true;
            dtpFechaNacimiento.Value = paciente.fechaNacimiento.ToString("yyyy-MM-dd");
            txtEmail.Text = paciente.email;
            ddlSeguro.SelectedValue = paciente.seguro.idSeguro.ToString();
            txtDireccion.Text = paciente.direccion;
            txtTelefono.Text = paciente.telefono.ToString();
        }

        protected void btnRegresar_Click(object sender, EventArgs e)
        {
            Response.Redirect("ListarPacientes.aspx");
        }

        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            wsPaciente = new PacienteWSClient();
            if (estado == Estado.Modificar)
            {
                // Asegúrate de que tomas el id que está en el TextBox oculto o similar:
                paciente.idUsuario = Int32.Parse(txtIDUsuario.Text);
            }
            paciente.dni = txtDNI.Text;
            paciente.nombre = txtNombre.Text;
            paciente.apellidoPaterno = txtPaterno.Text;
            paciente.apellidoMaterno = txtMaterno.Text;
            paciente.fechaNacimiento = DateTime.Parse(dtpFechaNacimiento.Value);
            paciente.fechaNacimientoSpecified = true;
            if (rbMasculino.Checked) paciente.genero = 'M';
            else if (rbFemenino.Checked) paciente.genero = 'F';
            seguro objSeguro = new seguro();
            objSeguro.idSeguro = Int32.Parse(ddlSeguro.SelectedValue);
            paciente.email = txtEmail.Text;
            paciente.seguro = objSeguro;
            paciente.direccion = txtDireccion.Text;
            paciente.telefono = txtTelefono.Text;

            CuentaUsuarioWSClient wsCuenta = new CuentaUsuarioWSClient();
            cuentaUsuario cuenta = new cuentaUsuario();
            cuenta.username = txtUsername.Text;
            cuenta.password = txtPassword.Text;
            cuenta.rol = rol.PACIENTE;
            cuenta.rolSpecified = true;
            cuenta.usuario = paciente;

            try
            {
                if (estado == Estado.Nuevo)
                {
                    var lista = wsPaciente.listarPaciente(); 

                    bool dniRepetido = lista.Any(p => p.dni == paciente.dni);
                    bool usernameRepetido = wsCuenta.usernameExiste(txtUsername.Text);

                    if (dniRepetido  || usernameRepetido)
                    {
                        string mensaje = "Ya existe un paciente con ";
                        if (dniRepetido) mensaje += "el mismo DNI. ";
                        if (usernameRepetido) mensaje += "el mismo nombre de usuario.";

                        lanzarMensajedeError(mensaje.Trim());
                        return; // salir del método
                    }
                    int idInsertado = wsPaciente.insertarPaciente(paciente);
                    cuenta.usuario.idUsuario = idInsertado;
                    wsCuenta.insertarCuenta(cuenta);
                    wsHistorial = new HistorialMedicoWSClient();
                    historialMedico historial = new historialMedico();
                    historial.paciente = paciente;
                    wsHistorial.insertarHistorial(historial);
                }
                else if (estado == Estado.Modificar)
                {
                    wsPaciente.modificarPaciente(paciente);
                }
            }
            catch (Exception ex)
            {
                lanzarMensajedeError(ex.Message);
                return;
            }

            Response.Redirect("ListarPacientes.aspx");
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