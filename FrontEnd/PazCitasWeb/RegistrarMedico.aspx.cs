using PazCitasWA.ServiciosWS;
using System;
using System.ComponentModel;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace PazCitasWA
{
    public partial class RegistrarMedico : System.Web.UI.Page
    {
        private SedeWSClient wsSede;
        private EspecialidadWSClient wsEspecialidad;
        private MedicoWSClient wsMedico;
        private ConsultorioWSClient wsConsultorio;
        private Estado estado;
        private medico medico;
        private int idConsPrevio;
        private CuentaUsuarioWSClient wsCuenta;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadDropDowns();
                // Fecha máxima: hoy menos 18 años
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
                medico = new medico();
                lblTitulo.Text = "Registrar Médico";
            }
            else if (accion == "modificar")
            {
                estado = Estado.Modificar;
                lblTitulo.Text = "Modificar Médico";
                medico = (medico)Session["medicoSeleccionado"];
                if (!IsPostBack)
                {
                    AsignarValores();
                    rfvPassword.Enabled = false;
                    rfvUsername.Enabled = false;
                    txtUsername.Enabled = false;
                    txtPassword.Enabled = false;
                }
            }
            else if (accion == "ver")
            {
                lblTitulo.Text = "Ver Médico";
                medico = (medico)Session["medicoSeleccionado"];
                AsignarValores();
                rfvPassword.Enabled = false;
                rfvUsername.Enabled = false;
                txtDNI.Enabled = false;
                txtCMP.Enabled = false;
                txtNombre.Enabled = false;
                txtPaterno.Enabled = false;
                txtMaterno.Enabled = false;
                txtEmail.Enabled = false;
                dtpFechaNacimiento.Disabled = true;
                rbFemenino.Disabled = true;
                rbMasculino.Disabled = true;
                ddlConsultorio.Enabled = false;
                ddlSede.Enabled = false;
                ddlEspecialidad.Enabled = false;
                txtUsername.Enabled = false;
                txtPassword.Enabled = false;
            }

        }

        protected void AsignarValores()
        {
            txtIDUsuario.Text = medico.idUsuario.ToString();
            txtDNI.Text = medico.dni;
            txtCMP.Text = medico.codigoMedico;
            txtNombre.Text = medico.nombre;
            txtPaterno.Text = medico.apellidoPaterno;
            txtMaterno.Text = medico.apellidoMaterno;
            if (medico.genero.Equals('M')) rbMasculino.Checked = true;
            else rbFemenino.Checked = true;
            dtpFechaNacimiento.Value = medico.fechaNacimiento.ToString("yyyy-MM-dd");
            txtEmail.Text = medico.email;

            // Preseleccionamos sede consultorio y especialidad:
            ddlSede.SelectedValue = medico.sede.idSede.ToString();
            ddlSede.Enabled = true;

            CargarConsultoriosPorSede(medico.sede.idSede);
            ViewState["idConsPrevio"] = medico.consultorio.idConsultorio;

            ddlConsultorio.Items.Add(new ListItem(medico.consultorio.nombreConsultorio,
                medico.consultorio.idConsultorio.ToString()));
            ddlConsultorio.SelectedValue = medico.consultorio.idConsultorio.ToString();
            ddlConsultorio.Enabled = true;

            CargarEspecialidadesPorSede(medico.sede.idSede);
            ddlEspecialidad.SelectedValue = medico.especialidad.idEspecialidad.ToString();

            ddlEspecialidad.Enabled = true;
        }

        private void LoadDropDowns()
        {
            wsEspecialidad = new EspecialidadWSClient();
            wsSede = new SedeWSClient();
            ddlSede.DataSource = wsSede.listarSede();
            ddlSede.DataTextField = "nombre";
            ddlSede.DataValueField = "idSede";
            ddlSede.DataBind();
            ddlSede.Items.Insert(0, new ListItem("-- Seleccione --", ""));

            // Poner placeholder en especialidades
            ddlConsultorio.Items.Clear();
            ddlConsultorio.Items.Add(new ListItem("-- Seleccione sede primero --", ""));
            ddlConsultorio.Enabled = false;

            // Poner placeholder en especialidades
            ddlEspecialidad.Items.Clear();
            ddlEspecialidad.Items.Add(new ListItem("-- Seleccione sede primero --", ""));
            ddlEspecialidad.Enabled = false;

        }

        protected void btnRegresar_Click(object sender, EventArgs e)
        {
            Response.Redirect("ListarMedicos.aspx");
        }

        protected void btnGuardar_Click(object sender, EventArgs e)
        {

            wsMedico = new MedicoWSClient();
            if (estado == Estado.Modificar)
            {
                // Asegúrate de que tomas el id que está en el TextBox oculto o similar:
                medico.idUsuario = Int32.Parse(txtIDUsuario.Text);
            }
            medico.dni = txtDNI.Text;
            medico.codigoMedico = txtCMP.Text;
            medico.nombre = txtNombre.Text;
            medico.apellidoPaterno = txtPaterno.Text;
            medico.apellidoMaterno = txtMaterno.Text;
            medico.fechaNacimiento = DateTime.Parse(dtpFechaNacimiento.Value);
            medico.fechaNacimientoSpecified = true;
            if (rbMasculino.Checked) medico.genero = 'M';
            else if (rbFemenino.Checked) medico.genero = 'F';
            sede objSede = new sede();
            objSede.idSede = Int32.Parse(ddlSede.SelectedValue);
            especialidad objEspecialidad = new especialidad();
            objEspecialidad.idEspecialidad = Int32.Parse(ddlEspecialidad.SelectedValue);
            consultorio objConsultorio = new consultorio();
            objConsultorio.idConsultorio = Int32.Parse(ddlConsultorio.SelectedValue);
            medico.email = txtEmail.Text;
            medico.sede = objSede;
            medico.especialidad = objEspecialidad;
            medico.consultorio = objConsultorio;
            wsCuenta = new CuentaUsuarioWSClient();
            cuentaUsuario cuenta = new cuentaUsuario();
            cuenta.username = txtUsername.Text;
            cuenta.password = txtPassword.Text;
            cuenta.rol = rol.MÉDICO;
            cuenta.rolSpecified = true;
            cuenta.usuario = medico;
            wsConsultorio = new ConsultorioWSClient();
            try
            {
                if (estado == Estado.Nuevo)
                {
                    var lista = wsMedico.listarMedico();

                    bool dniRepetido = lista.Any(m => m.dni == medico.dni);
                    bool cmpRepetido = lista.Any(m => m.codigoMedico == medico.codigoMedico);
                    bool usernameRepetido = wsCuenta.usernameExiste(txtUsername.Text);

                    if (dniRepetido || cmpRepetido || usernameRepetido)
                    {
                        string mensaje = "Ya existe un médico con ";
                        if (dniRepetido) mensaje += "el mismo DNI. ";
                        if (cmpRepetido) mensaje += "el mismo CMP. ";
                        if (usernameRepetido) mensaje += "el mismo nombre de usuario.";

                        lanzarMensajedeError(mensaje.Trim());
                        return; // salir del método
                    }
                    int idInsertado = wsMedico.insertarMedico(medico);
                    wsConsultorio.marcarAsignado(medico.consultorio.idConsultorio);
                    cuenta.usuario.idUsuario = idInsertado;
                    wsCuenta.insertarCuenta(cuenta);
                    Response.Redirect($"RegistrarTurnosMedico.aspx?idMedico={idInsertado}");
                }
                else if (estado == Estado.Modificar)
                {
                    int idConsPrevio = (int)ViewState["idConsPrevio"];
                    wsConsultorio.marcarNoAsignado(idConsPrevio);
                    wsMedico.modificarMedico(medico);
                    wsConsultorio.marcarAsignado(medico.consultorio.idConsultorio);
                    Response.Redirect("ListarMedicos.aspx");
                }
            }
            catch (Exception ex)
            {
                lanzarMensajedeError(ex.Message);
                return;
            }

        }

        public void lanzarMensajedeError(String mensaje)
        {
            lblMensajeError.Text = mensaje;
            string script = "mostrarModalError();";
            ScriptManager.RegisterStartupScript(this, GetType(), "modalError", script, true);
        }

        protected void ddlSede_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(ddlSede.SelectedValue))
            {
                int idSede = int.Parse(ddlSede.SelectedValue);
                CargarConsultoriosPorSede(idSede);
                CargarEspecialidadesPorSede(idSede);
            }
            else
            {
                // Poner placeholder en especialidades
                ddlConsultorio.Items.Clear();
                ddlConsultorio.Items.Add(new ListItem("-- Seleccione sede primero --", ""));
                ddlConsultorio.Enabled = false;

                ddlEspecialidad.Items.Clear();
                ddlEspecialidad.Items.Add(new ListItem("-- Seleccione sede primero --", ""));
                ddlEspecialidad.Enabled = false;
            }
        }

        private void CargarEspecialidadesPorSede(int idSede)
        {
            wsEspecialidad = new EspecialidadWSClient();

            //Si no tiene especialidades
            especialidad[] listaEspecialidades = wsEspecialidad.listarXSede(idSede);

            if (listaEspecialidades == null)
            {
                ddlEspecialidad.Items.Clear();
                ddlEspecialidad.Items.Add(new ListItem("-- Esta sede no tiene Espe....--", ""));
                ddlEspecialidad.Enabled = false;
            }
            else
            {
                ddlEspecialidad.DataSource = listaEspecialidades;
                ddlEspecialidad.DataTextField = "nombre";
                ddlEspecialidad.DataValueField = "idEspecialidad";
                ddlEspecialidad.DataBind();
                ddlEspecialidad.Enabled = true;
            }

        }

        private void CargarConsultoriosPorSede(int idSede)
        {
            wsConsultorio = new ConsultorioWSClient();

            //Si no tiene especialidades
            consultorio[] listaConsultorios = wsConsultorio.listarConsulPorSedeNoAsig(idSede);

            if (listaConsultorios == null)
            {
                ddlConsultorio.Items.Clear();
                ddlConsultorio.Items.Add(new ListItem("-- Esta sede no tiene Consultorios --", ""));
                ddlConsultorio.Enabled = false;
            }
            else
            {
                ddlConsultorio.DataSource = listaConsultorios;

                ddlConsultorio.DataTextField = "nombreConsultorio";
                ddlConsultorio.DataValueField = "idConsultorio"; // El valor asociado será el idConsultorio
                ddlConsultorio.DataBind();
                ddlConsultorio.Enabled = true;
            }

        }

        protected void cvGenero_ServerValidate(object source, ServerValidateEventArgs args)
        {
            // Verificar si algún radio button está seleccionado
            args.IsValid = rbMasculino.Checked || rbFemenino.Checked;
        }
    }
}