using PazCitasWA.ServiciosEmail;
using PazCitasWA.ServiciosWS;
using System;
using System.Collections.Generic;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

public static class DateTimeExtensions
{
    public static DateTime StartOfWeek(this DateTime dt, DayOfWeek startOfWeek)
    {
        int diff = (7 + (dt.DayOfWeek - startOfWeek)) % 7;
        return dt.AddDays(-1 * diff).Date;
    }
}

namespace PazCitasWA
{
    public partial class RegistrarCitaPaciente : Page
    {
        private SedeWSClient wsCliente;
        private EspecialidadWSClient wsEspecialidad;
        private MedicoWSClient wsMedico;
        private TurnoWSClient wsTurno;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                InicializarFormulario();
            }
        }

        private void InicializarFormulario()
        {
            Label5.Text = string.Empty;
            Panel1.Visible = true;
            Panel2.Visible = false;
            Panel3.Visible = false;
            Panel4.Visible = false;
            Panel5.Visible = false;

            try
            {
                DropDownList1.Items.Clear();
                DropDownList1.Items.Add(new ListItem("-- Seleccione una sede --", ""));

                wsCliente = new SedeWSClient();
                var listaSedes = wsCliente.listarSede();

                foreach (var sede in listaSedes)
                {
                    DropDownList1.Items.Add(new ListItem(sede.nombre, sede.idSede.ToString()));
                }
            }
            catch (Exception ex)
            {
                Label5.Text = "Error al cargar las sedes: " + ex.Message;
            }
        }

        protected void btnSiguiente1_Click(object sender, EventArgs e)
        {
            Label5.Text = string.Empty;
            if (!string.IsNullOrEmpty(DropDownList1.SelectedValue))
            {
                Panel1.Visible = false;
                Panel2.Visible = true;
                DropDownList2.Items.Clear();
                DropDownList2.Items.Add(new ListItem("-- Seleccione una especialidad --", ""));

                try
                {
                    wsEspecialidad = new EspecialidadWSClient();
                    int idSede = int.Parse(DropDownList1.SelectedValue);
                    var especialidades = wsEspecialidad.listarXSede(idSede);

                    foreach (var esp in especialidades)
                    {
                        DropDownList2.Items.Add(new ListItem(esp.nombre, esp.idEspecialidad.ToString()));
                    }
                }
                catch (Exception ex)
                {
                    Label5.Text = "Error al cargar las especialidades: " + ex.Message;
                }
            }
            else
            {
                Label5.Text = "Por favor selecciona una sede.";
            }
        }

        protected void btnAtras1_Click(object sender, EventArgs e)
        {
            Label5.Text = string.Empty;
            Panel1.Visible = true;
            Panel2.Visible = false;
        }

        protected void btnSiguiente2_Click(object sender, EventArgs e)
        {
            Label5.Text = string.Empty;
            if (DropDownList2.SelectedIndex > 0)
            {
                Panel2.Visible = false;
                Panel3.Visible = true;
                DropDownList3.Items.Clear();
                DropDownList3.Items.Add(new ListItem("-- Seleccione un médico --", ""));

                try
                {
                    wsMedico = new MedicoWSClient();
                    int idSede = int.Parse(DropDownList1.SelectedValue);
                    int idEspecialidad = int.Parse(DropDownList2.SelectedValue);

                    var medicos = wsMedico.listarMedicoXEspXSede(idSede, idEspecialidad);

                    foreach (var medico in medicos)
                    {
                        DropDownList3.Items.Add(
                            new ListItem(medico.nombre + " " + medico.apellidoPaterno, medico.idUsuario.ToString()));
                    }
                }
                catch (Exception ex)
                {
                    Label5.Text = "Error al cargar los médicos: " + ex.Message;
                }
            }
            else
            {
                Label5.Text = "Por favor selecciona una especialidad.";
            }
        }

        protected void btnAtras2_Click(object sender, EventArgs e)
        {
            Label5.Text = string.Empty;
            Panel2.Visible = true;
            Panel3.Visible = false;
        }

        protected void btnSiguiente3_Click(object sender, EventArgs e)
        {
            Label5.Text = string.Empty;
            if (DropDownList3.SelectedIndex > 0)
            {
                Panel3.Visible = false;
                Panel4.Visible = true;
                SemanaInicio = DateTime.Today;
                CargarSemana();
            }
            else
            {
                Label5.Text = "Por favor selecciona un médico.";
            }
        }

        protected void btnAtras3_Click(object sender, EventArgs e)
        {
            Label5.Text = string.Empty;
            Panel3.Visible = true;
            Panel4.Visible = false;
        }

        protected void btnSiguiente4_Click(object sender, EventArgs e)
        {
            Label5.Text = string.Empty;
            string turno = HiddenField1.Value;
            if (!string.IsNullOrEmpty(turno))
            {
                string[] partes = turno.Split('|');
                string horaYFecha = partes[0];
                string idHorarioTrabajo = partes.Length > 1 ? partes[1] : "";

                if (!string.IsNullOrEmpty(idHorarioTrabajo))
                {
                    Session["idHorarioTrabajo"] = idHorarioTrabajo;
                }

                Panel4.Visible = false;
                Panel5.Visible = true;
                Label1.Text = DropDownList1.SelectedItem.Text;
                Label2.Text = DropDownList2.SelectedItem.Text;
                Label3.Text = DropDownList3.SelectedItem.Text;
                Label4.Text = horaYFecha;
            }
            else
            {
                Label5.Text = "Por favor selecciona un horario disponible.";
            }
        }

        protected void btnAtras4_Click(object sender, EventArgs e)
        {
            Label5.Text = string.Empty;
            Panel5.Visible = false;
            Panel4.Visible = true;
        }


        // En tu archivo RegistrarCitaPaciente.aspx.cs

        protected int ObtenerIdDelPacienteLogueado()
        {
            // ======================================================================
            // === LA CORRECCIÓN ESTÁ AQUÍ: Buscamos "id_usuario", no "paciente" ===
            if (Session["id_usuario"] != null)
            {
                // Si la encuentra, simplemente la convierte a número y la devuelve.
                return Convert.ToInt32(Session["id_usuario"]);
            }
            // ======================================================================
            else
            {
                // Si no encuentra la sesión, es cuando te redirige.
                // Ahora que buscará la clave correcta, ya no debería entrar aquí.
                Response.Redirect("~/Login.aspx?rol=paciente");
                return 0;
            }
        }

        protected void btnRegistrar_Click(object sender, EventArgs e)
        {
            Label5.Text = string.Empty;
            try
            {
                string turnoTexto = HiddenField1.Value.Split('|')[0];
                string idTurno = Session["idHorarioTrabajo"]?.ToString();

                if (string.IsNullOrEmpty(turnoTexto) || string.IsNullOrEmpty(idTurno))
                {
                    Label5.Text = "Por favor selecciona un horario.";
                    return;
                }

                string[] partes = turnoTexto.Split(' ');
                string hora = partes[0];
                string fecha = partes[1];

                DateTime fechaCita = DateTime.ParseExact(fecha, "dd/MM", null);

                cita nuevaCita = new cita();
                nuevaCita.fecha = fechaCita;
                nuevaCita.fechaSpecified = true;
                nuevaCita.estadoCita = estadoCita.PROGRAMADA;
                nuevaCita.estadoCitaSpecified = true;
                nuevaCita.estadoAtencion = estadoAtencion.EN_ESPERA;
                nuevaCita.estadoAtencionSpecified = true;
                nuevaCita.motivoConsulta = "";
                nuevaCita.horarioTrabajo = new horarioTrabajo();
                nuevaCita.horarioTrabajo.idHorarioTrabajo = int.Parse(idTurno);
                nuevaCita.paciente = new paciente();
                nuevaCita.paciente.idUsuario = Convert.ToInt32(Session["id_usuario"]);


                // --- IMPORTANTE: Debes obtener el ID del paciente que ha iniciado sesión ---
                // nuevaCita.paciente = new paciente { idUsuario = 3 }; // NO USAR UN ID FIJO
                int idPacienteLogueado = ObtenerIdDelPacienteLogueado(); // Debes implementar esta función
                nuevaCita.paciente = new paciente { idUsuario = idPacienteLogueado };
                // -------------------------------------------------------------------------


                var wsCita = new CitaWSClient();
                int resultado = wsCita.insertarCita(nuevaCita);

                if (resultado > 0)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "alertaOk", "mostrarModal('Cita registrada correctamente. Recibirá una confirmación por correo.', true);", true);
                    // Intentamos enviar la notificación en segundo plano
                    try
                    {
                        // 1. OBTENER DATOS ADICIONALES PARA EL CORREO
                        // Necesitarás un método en tu Web Service que te devuelva el email y nombre del paciente por su ID
                        var wsPaciente = new PacienteWSClient();
                        var pacienteInfo = wsPaciente.obtenerPacienteXiD(idPacienteLogueado);
                        string emailPaciente = pacienteInfo.email;
                        string nombrePaciente = pacienteInfo.nombre;
                        string nombreMedico = Label3.Text;

                        // 2. PREPARAR EL MENSAJE
                        string asunto = "✅ Confirmación de su Cita en PazCitas";
                        string cuerpoHtml = $@"
                            <h1>¡Cita Confirmada!</h1>
                            <p>Estimado/a <strong>{nombrePaciente}</strong>,</p>
                            <p>Le confirmamos que su cita ha sido registrada con éxito para los siguientes detalles:</p>
                            <ul>
                                <li><strong>Sede:</strong> {Label1.Text}</li>
                                <li><strong>Especialidad:</strong> {Label2.Text}</li>
                                <li><strong>Médico:</strong> {nombreMedico}</li>
                                <li><strong>Fecha y Hora:</strong> {turnoTexto}</li>
                            </ul>
                            <p>Gracias por su preferencia.</p>";

                        // 3. ENVIAR EL CORREO USANDO EL SERVICIO QUE YA CREAMOS
                        ServicioEmail.Enviar(emailPaciente, asunto, cuerpoHtml);

                        // 4. (Opcional) Guardar en el historial de notificaciones del portal
                        // NotificacionDAO.Insertar(idPacienteLogueado, nuevaCitaId, "CONFIRMACION", asunto, "Su cita ha sido confirmada.");
                    }
                    catch (Exception ex)
                    {
                        // Si el envío del correo falla, no afecta al registro de la cita.
                        // Lo ideal es registrar este error en un log para revisarlo después.
                        // System.Diagnostics.Debug.WriteLine("Error al enviar email de confirmación: " + ex.Message);
                    }

                }
                else
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "alertaErr", "mostrarModal('Error al registrar la cita.', false);", true);
                }
            }
            catch (Exception ex)
            {
                Label5.Text = "Error inesperado: " + ex.Message;
            }
        }

        private DateTime SemanaInicio
        {
            get => ViewState["SemanaInicio"] == null ? DateTime.Today : (DateTime)ViewState["SemanaInicio"];
            set => ViewState["SemanaInicio"] = value;
        }

        private void CargarSemana()
        {
            DateTime hoy = DateTime.Today;
            DateTime inicio = SemanaInicio;
            DateTime fin;

            if (inicio.Date == hoy.Date)
            {
                fin = hoy.StartOfWeek(DayOfWeek.Monday).AddDays(6);
            }
            else
            {
                inicio = inicio.StartOfWeek(DayOfWeek.Monday);
                fin = inicio.AddDays(6);
            }

            lblSemanaActual.Text = $"Semana del {inicio:dd MMM} al {fin:dd MMM}";

            wsTurno = new TurnoWSClient();
            int idMedico = int.Parse(DropDownList3.SelectedValue);
            var turnosSemana = wsTurno.listarTurnosSemana(idMedico, inicio);

            // Aseguramos que la lista no sea null
            if (turnosSemana == null)
                turnosSemana = new turnoDisponibleDTO[0];

            var html = new StringBuilder();

            for (DateTime dia = inicio; dia <= fin; dia = dia.AddDays(1))
            {
                var turnosDia = new List<turnoDisponibleDTO>();
                foreach (var turno in turnosSemana)
                {
                    if (turno.fecha.Date == dia.Date)
                    {
                        turnosDia.Add(turno);
                    }
                }

                html.Append("<div class='day-card'>");
                html.AppendFormat("<div class='day-title'>{0:dd MMM} - {0:dddd}</div>", dia);
                html.Append("<div class='hour-list'>");

                if (turnosDia.Count == 0)
                {
                    html.Append("<div class='no-turnos'>SIN TURNOS DISPONIBLES</div>");
                }
                else
                {
                    foreach (var turno in turnosDia)
                    {
                        string hora = turno.horaInicio.ToString("HH:mm");
                        string valor = hora + " " + turno.fecha.ToString("dd/MM") + "|" + turno.idHorarioTrabajo;
                        html.AppendFormat(
                            "<button type='button' class='time-slot' onclick=\"seleccionarTurno(this, '{0}', '{1}')\">{2}</button>",
                            HiddenField1.ClientID, valor, hora
                        );
                    }
                }

                html.Append("</div></div>");
            }

            Literal1.Text = html.ToString();

            DateTime topeMinimo = DateTime.Today;
            DateTime topeMaximo = DateTime.Today.StartOfWeek(DayOfWeek.Monday).AddDays(7 * 4);

            btnSemanaAnterior.Enabled = SemanaInicio > topeMinimo;
            btnSemanaSiguiente.Enabled = SemanaInicio < topeMaximo;
        }


        protected void btnSemanaAnterior_Click(object sender, EventArgs e)
        {
            SemanaInicio = SemanaInicio.AddDays(-7) < DateTime.Today ? DateTime.Today : SemanaInicio.AddDays(-7);
            CargarSemana();
        }

        protected void btnSemanaSiguiente_Click(object sender, EventArgs e)
        {
            DateTime topeMaximo = DateTime.Today.StartOfWeek(DayOfWeek.Monday).AddDays(7 * 4);
            DateTime nuevaSemana = SemanaInicio.AddDays(7);

            if (nuevaSemana <= topeMaximo)
            {
                SemanaInicio = nuevaSemana;
                CargarSemana();
            }
        }
    }
}
