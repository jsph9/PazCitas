using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using PazCitasWA.ServiciosWS;

// using para modal
using System.Globalization;
using System.Diagnostics.PerformanceData;
using System.Web.Compilation;
using PazCitasWA.ServiciosEmail;


namespace PazCitasWA
{
    public partial class DetalleCitaPaciente : System.Web.UI.Page
    {
        // Propiedad que usa ViewState para guardar/leer la cita entre postbacks.
        private cita CitaGuardada
        {
            get { return ViewState["CitaGuardada"] as cita; }
            set { ViewState["CitaGuardada"] = value; }
        }

        private CitaWSClient wsCita;
        private TurnoWSClient wsTurno;

        private cita c = null;
        protected void Page_Load(object sender, EventArgs e)
        {
            
            string idCita = Request.QueryString["id"];
            if (string.IsNullOrEmpty(idCita))
            {
                Response.Redirect("ListarCitasPaciente.aspx");
                return; // Detiene la ejecución si no hay ID
            }

            if (!IsPostBack)
            {
                wsCita = new CitaWSClient();

                c = wsCita.obtenerXIdCompletoSinDatosPaciente(Int32.Parse(idCita));
                if (c == null)
                {
                    Response.Redirect("ListarCitasPaciente.aspx"); 
                    return;
                }

                this.CitaGuardada = c;

                int idMedico = c.horarioTrabajo.medico.idUsuario;
                medico med = c.horarioTrabajo.medico;
                turno tur = c.horarioTrabajo.turno;

                lblEspecialidadNombre.Text = med.especialidad.nombre.ToString();
                lblSedeNombre.Text = med.sede.nombre.ToString();
                lblEstadoPagoNombre.Text = c.estadoCita.ToString();
                lblConsultorioNombre.Text = med.consultorio.nombreConsultorio.ToString();

                lblMedicoCodigo.Text = "CMP: " + med.codigoMedico.ToString();
                lblMedicoEmail.Text = med.email.ToString();
                lblMedicoNombreCompleto.Text = "Dr. " + med.nombre.ToString() + med.apellidoPaterno.ToString();

                string estadoActualCita = c.estadoAtencion.ToString();
                SetAppointmentStatus(estadoActualCita);

                decimal costoTotalCita = 250m;
                decimal coberturaSeguro = 180m;
                string estadoDelPago = "pendiente";

                SetPaymentOverview(costoTotalCita, coberturaSeguro, estadoDelPago);

                lblConsultationReason.Text = c.motivoConsulta.ToString();

                SetupActionButtons(c);

                InitializeScheduler();

            }
            cita cguar = this.CitaGuardada;
            if (cguar != null)
            {
                BuildStaticCalendar(cguar);
            }

        }

        private void BuildStaticCalendar(cita citaDate)
        {
            turno tur = citaDate.horarioTrabajo.turno;
            DateTime today = DateTime.Today; 

            lblCalendarMonth.Text = citaDate.fecha.ToString("MMMM yyyy");
            lblAppointmentTime.Text = tur.horaInicio.ToString("HH:mm") + " - " + tur.horaFin.ToString("HH:mm");

            var firstDayOfMonth = new DateTime(citaDate.fecha.Year, citaDate.fecha.Month, 1);
            int startDayOfWeek = (int)firstDayOfMonth.DayOfWeek;
            if (startDayOfWeek == 0) startDayOfWeek = 7;

            var daysInMonth = DateTime.DaysInMonth(citaDate.fecha.Year, citaDate.fecha.Month);
            var prevMonthLastDay = firstDayOfMonth.AddDays(-1);

            var sb = new StringBuilder();

            // 1. Añadir días del mes anterior para rellenar
            for (int i = 1; i < startDayOfWeek; i++)
            {
                int day = prevMonthLastDay.Day - (startDayOfWeek - i - 1);
                sb.Append($"<div class='calendar-day-cell other-month'>{day}</div>");
            }

            // 2. Añadir días del mes actual
            for (int i = 1; i <= daysInMonth; i++)
            {
                var currentDate = new DateTime(citaDate.fecha.Year, citaDate.fecha.Month, i);
                string cssClasses = "calendar-day-cell";

                // ¿Es el día de la cita? Esta es la prioridad más alta.
                if (currentDate.Date == citaDate.fecha.Date)
                {
                    cssClasses += " selected-day";
                }
                // Si NO es el día de la cita, ¿es el día de hoy?
                else if (currentDate.Date == today)
                {
                    cssClasses += " today-day";
                }

                sb.Append($"<div class='{cssClasses}'>{i}</div>");
            }

            phCalendarDays.Controls.Add(new Literal { Text = sb.ToString() });
        }
        private void SetAppointmentStatus(string estado)
        {
            // Reseteamos las clases y visibilidad
            stepEspera.Attributes["class"] = "timeline-step";
            stepConsultorio.Attributes["class"] = "timeline-step";
            stepAtendido.Attributes["class"] = "timeline-step";

            phTagEspera.Visible = false;
            phTagConsultorio.Visible = false;
            phTagAtendido.Visible = false;

            // Reseteamos las descripciones
            lblDescEspera.Text = "Te atenderemos pronto";
            lblDescConsultorio.Text = "Te están atendiendo";
            lblDescAtendido.Text = "Atención Completada";

            switch (estado.ToLower().Trim())
            {
                case "en_consultorio":
                    // Paso 1 completado
                    stepEspera.Attributes["class"] += " completed";
                    phTagEspera.Visible = true;
                    phTagEspera.Controls.Add(new Literal { Text = "<div class='step-status-tag tag-completed'>Completado</div>" });

                    // Paso 2 activo
                    stepConsultorio.Attributes["class"] += " active";
                    phTagConsultorio.Visible = true;
                    phTagConsultorio.Controls.Add(new Literal { Text = "<div class='step-status-tag tag-in-progress'>En Progreso</div>" });
                    break;

                case "atendido":
                    // Pasos 1 y 2 completados
                    stepEspera.Attributes["class"] += " completed";
                    phTagEspera.Visible = true;
                    phTagEspera.Controls.Add(new Literal { Text = "<div class='step-status-tag tag-completed'>Completado</div>" });

                    stepConsultorio.Attributes["class"] += " completed";
                    phTagConsultorio.Visible = true;
                    phTagConsultorio.Controls.Add(new Literal { Text = "<div class='step-status-tag tag-completed'>Completado</div>" });

                    // Paso 3 completado 
                    stepAtendido.Attributes["class"] += " completed";
                    phTagAtendido.Visible = true;
                    phTagAtendido.Controls.Add(new Literal { Text = "<div class='step-status-tag tag-completed'>Finalizado</div>" });
                    break;

                case "en_espera":
                default:
                    // Paso 1 activo
                    stepEspera.Attributes["class"] += " active";
                    phTagEspera.Visible = true;
                    phTagEspera.Controls.Add(new Literal { Text = "<div class='step-status-tag tag-in-progress'>En Progreso</div>" });
                    break;
            }
        }
        private void SetPaymentOverview(decimal montoTotal, decimal montoSeguro, string estadoPago)
        {
            decimal montoPaciente = montoTotal - montoSeguro;

            // 1. Asignar los montos a los labels
            // "C0" formatea como moneda sin decimales. Usa "C" o "C2" si los quieres.
            lblAmountTotal.Text = montoTotal.ToString("C0");
            lblAmountInsurance.Text = montoSeguro.ToString("C0");
            lblAmountPatient.Text = montoPaciente.ToString("C0");

            // 2. Calcular y asignar el alto de las barras de progreso
            barFillTotal.Style["height"] = "95%";

            // Las otras barras son un porcentaje del total
            if (montoTotal > 0)
            {
                double insurancePercent = (double)(montoSeguro / montoTotal) * 100;
                double patientPercent = (double)(montoPaciente / montoTotal) * 100;

                barFillInsurance.Style["height"] = insurancePercent.ToString("F0") + "%";
                barFillPatient.Style["height"] = patientPercent.ToString("F0") + "%";
            }
            else 
            {
                barFillInsurance.Style["height"] = "0%";
                barFillPatient.Style["height"] = "0%";
            }

            // 3. Configurar la píldora de estado de pago
            string tagHtml = "";
            switch (estadoPago.ToLower().Trim())
            {
                case "cancelada":
                    tagHtml = "<div class='payment-status-tag tag-payment-paid'>Pagado</div>";
                    break;
                case "vencido":
                    tagHtml = "<div class='payment-status-tag tag-payment-partial'>Pago Parcial</div>";
                    break;
                case "pendiente":
                default:
                    tagHtml = "<div class='payment-status-tag tag-payment-pending'>Pendiente</div>";
                    break;
            }
            phPaymentStatusTag.Controls.Add(new Literal { Text = tagHtml });
        }
        private void SetupActionButtons(cita c)
        {
            //  EJEMPLO DE CONDICIONALES 
            bool canModify = true; // CAMBIA A 'true' PARA PROBAR
            string msjCancelarCita = "";
            bool canCancel = true;  // CAMBIA A 'false' PARA PROBAR
            string msjModificarCita = "";

            DateTime fechaActual = DateTime.Now.Date;
            TimeSpan diferencia = c.fecha - fechaActual;
            int dias = diferencia.Days;
            if (c.estadoCita == estadoCita.CANCELADA)
            {
                msjCancelarCita = "Tu cita ya se encuetra cancelada";
                canCancel = false;
                msjModificarCita = "Tu cita ya se encuetra cancelada";
                canModify = false;
            }
            else if (dias <= 0)
            {
                msjCancelarCita = "Ya paso el día de tu cita";
                canCancel = false;
                msjModificarCita = "Ya paso el día de tu cita";
                canModify = false;
            }
            else if (dias < 2)
            {
                msjCancelarCita = "Queda menos de 2 días para tu cita, no puedes cancelarla";
                canCancel = false;
            }
            else if (dias < 4)
            {
                msjModificarCita = "Queda menos de 4 días para tu cita, no puedes modificarla";
                canModify = false;
            }

            if (canModify)
            {
                btnModifyAppointment.Enabled = true;
                divModifyWarning.Visible = false; // Ocultamos el div contenedor
            }
            else
            {
                btnModifyAppointment.Enabled = false;
                lblModifyWarning.Text = msjModificarCita;
                divModifyWarning.Visible = true; // Mostramos el div contenedor
            }

            if (canCancel)
            {
                btnCancelAppointment.Enabled = true;
                divCancelWarning.Visible = false; // Ocultamos el div contenedor
            }
            else
            {
                btnCancelAppointment.Enabled = false;
                lblCancelWarning.Text = msjCancelarCita;
                divCancelWarning.Visible = true; // Mostramos el div contenedor
            }
        }


        protected void btnConfirmCancel_Click(object sender, EventArgs e)
        {

            wsCita = new CitaWSClient();
            cita auxct = this.CitaGuardada;
            auxct.estadoCita = estadoCita.CANCELADA;
            auxct.estadoCitaSpecified = true;
            int res = wsCita.modificarCita(auxct);

            PacienteWSClient boPaciente = new PacienteWSClient();
            string script;
            if (res != 0)
            {
                try
                {

                    if (Session["id_usuario"] != null)
                    {
                        int idPaciente = (int)Session["id_usuario"];
                        paciente pacienteLogueado = boPaciente.obtenerPacienteXiD(idPaciente);

                        string nombreMedico = auxct.horarioTrabajo.medico.nombre + " " + auxct.horarioTrabajo.medico.apellidoPaterno;
                        string fechaOriginal = auxct.fecha.ToString("dd 'de' MMMM 'de' yyyy");

                        // --- Notificación para el Paciente ---
                        if (pacienteLogueado != null && !string.IsNullOrEmpty(pacienteLogueado.email))
                        {
                            string asuntoPaciente = "✅ Confirmación de Cancelación de Cita - PazCitas";
                            string cuerpoPaciente = $@"
                        <h3>Hola, {pacienteLogueado.nombre}!</h3>
                        <p>Te confirmamos que tu cita con el Dr./Dra. <strong>{nombreMedico}</strong> del día <strong>{fechaOriginal}</strong> ha sido <strong>cancelada exitosamente</strong>.</p>
                        <p>Atentamente,<br><strong>El equipo de Clínica PazCitas</strong></p>";

                            ServicioEmail.Enviar(pacienteLogueado.email, asuntoPaciente, cuerpoPaciente);
                        }

                    }

                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine("Error al enviar email de cancelación: " + ex.Message);
                }
                script = "alert('Tu cita ha sido cancelada exitosamente.'); window.location='ListarCitasPaciente.aspx';";
            }
            else
            {
                script = "alert('¡Algo sucedio! Intenta cancelar tu cita mas tarde.'); window.location='ListarCitasPaciente.aspx';";
            }

            ScriptManager.RegisterStartupScript(this, GetType(), "CancelSuccess", script, true);
        }

        private List<DateTime> AvailableDates
        {
            get { return ViewState["AvailableDates"] as List<DateTime>; }
            set { ViewState["AvailableDates"] = value; }
        }

        protected void btnModifyAppointment_Click(object sender, EventArgs e)
        {
            InitializeScheduler();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "OpenModifyModalScript", "openModal('modalModify');", true);
        }

        private void InitializeScheduler()
        {
            DateTime fechCita = this.CitaGuardada.fecha;
            var dates = new List<DateTime>();
            for (int i = 0; i <= 14; i++)
            {
                dates.Add(fechCita.AddDays(i));
            }
            this.AvailableDates = dates; // Guardamos la lista completa en ViewState

            // Reseteamos los campos ocultos.
            hdnSelectedDate.Value = string.Empty;
            hdnSelectedTime.Value = string.Empty;
            hdnDateOffset.Value = "0";

            BindDatesPage();

            // Ocultamos las secciones de horarios.
            pnlTimeSlots.Visible = false;
            pnlNoTimes.Visible = false;

            // Actualizamos el estado del botón de guardado.
            UpdateButtonState();
        }

        // NUEVO MÉTODO: Muestra una "página" de la lista de fechas guardada.
        private void BindDatesPage()
        {
            int offset = 0;
            int.TryParse(hdnDateOffset.Value, out offset);

            int pageSize = 5;

            var datesToShow = this.AvailableDates
                                  .Skip(offset * pageSize)
                                  .Take(pageSize)
                                  .ToList();

            rptDates.DataSource = datesToShow;
            rptDates.DataBind();

        }

        // Evento central que se ejecuta en cada clic dentro del modal.
        protected void btnRefreshScheduler_Click(object sender, EventArgs e)
        {
            BindDatesPage();

            DateTime? selectedDate = null;
            if (DateTime.TryParse(hdnSelectedDate.Value, out DateTime parsedDate))
            {
                selectedDate = parsedDate;
            }

            if (selectedDate.HasValue)
            {
                BindTimeSlotsForDate(selectedDate.Value);
            }
            else
            {
                pnlTimeSlots.Visible = false;
                pnlNoTimes.Visible = false;
            }

            UpdateButtonState();
        }

        // La lógica de BindTimeSlotsForDate y los demás métodos se mantiene igual.
        private void BindTimeSlotsForDate(DateTime date)
        {
            TurnoWSClient wsTurno = new TurnoWSClient();

            cita citaOriginal = this.CitaGuardada;
            if (citaOriginal == null)
            {
                pnlNoTimes.Visible = true;
                pnlTimeSlots.Visible = false;
                return;
            }
            int idMedico = citaOriginal.horarioTrabajo.medico.idUsuario;

            // 1. Llama al servicio y guarda el resultado en una variable temporal.
            turno[] turnosDesdeWS = wsTurno.obtenerTurnosLibres(idMedico, date);

            // 2. Comprueba si el resultado NO es nulo Y si tiene al menos un elemento.
            if (turnosDesdeWS != null && turnosDesdeWS.Length > 0)
            {
                // Solo si la comprobación es exitosa, creamos el BindingList.
                BindingList<turno> turnosDisp = new BindingList<turno>(turnosDesdeWS);

                var availableTimes = new BindingList<object>();
                foreach (turno tur in turnosDisp)
                {
                    string horaFormateada = tur.horaInicio.ToString("hh:mm tt", CultureInfo.InvariantCulture);
                    availableTimes.Add(new { Time = horaFormateada });
                }

                rptTimes.DataSource = availableTimes;
                rptTimes.DataBind();
                pnlTimeSlots.Visible = true;
                pnlNoTimes.Visible = false;
            }
            else
            {
                pnlTimeSlots.Visible = false;
                pnlNoTimes.Visible = true;
            }
        }

        private void UpdateButtonState()
        {
            bool isSelectionComplete = !string.IsNullOrEmpty(hdnSelectedDate.Value) && !string.IsNullOrEmpty(hdnSelectedTime.Value);
            btnConfirmModify.Enabled = isSelectionComplete;
            if (isSelectionComplete)
            {
                // Si la selección está completa, nos aseguramos de que no tenga la clase de deshabilitado.
                btnConfirmModify.CssClass = "btn btn-primary";
            }
            else
            {
                // Si la selección no está completa, añadimos la clase para que el CSS lo pinte de oscuro.
                btnConfirmModify.CssClass = "btn btn-primary aspNetDisabled";
            }
        }

        protected string GetDateItemCssClass(object dataItem)
        {
            DateTime date = (DateTime)dataItem;
            if (DateTime.TryParse(hdnSelectedDate.Value, out DateTime selectedDate))
            {
                return date.Date == selectedDate.Date ? "date-item selected" : "date-item";
            }
            return "date-item";
        }

        protected string GetTimeSlotCssClass(object timeValue)
        {
            // Si por alguna razón el valor es nulo, devolvemos la clase base.
            if (timeValue == null)
            {
                return "time-slot-button";
            }

            // 1. 'timeValue' ya es el string que necesitamos (ej: "09:00 AM").
            //    Lo convertimos a string de forma segura.
            string time = timeValue.ToString();

            // 2. Comparamos directamente el string de la hora actual con el del campo oculto.
            return !string.IsNullOrEmpty(hdnSelectedTime.Value) && time == hdnSelectedTime.Value
                   ? "time-slot-button selected"
                   : "time-slot-button";
        }

        protected void btnConfirmModify_Click(object sender, EventArgs e)
        {
            string selectedDateValue = hdnSelectedDate.Value;
            string selectedTimeValue = hdnSelectedTime.Value;

            if (string.IsNullOrEmpty(selectedDateValue) || string.IsNullOrEmpty(selectedTimeValue))
            {
                return; // No hacer nada si no hay selección completa
            }
            // 1. Parsea la fecha seleccionada
            DateTime fechaSeleccionada = DateTime.Parse(selectedDateValue, CultureInfo.InvariantCulture, DateTimeStyles.RoundtripKind);

            // 2. Parsea la hora seleccionada.
            DateTime horaSeleccionada = DateTime.Parse(selectedTimeValue, new CultureInfo("en-US")); // "en-US" para parsear "AM/PM" correctamente.

            // 3. Combina la parte de la fecha con la parte de la hora.
            DateTime nuevaFechaCompleta = new DateTime(
                fechaSeleccionada.Year,
                fechaSeleccionada.Month,
                fechaSeleccionada.Day,
                horaSeleccionada.Hour,
                horaSeleccionada.Minute,
                horaSeleccionada.Second
            );

            wsCita = new CitaWSClient();
            int res = wsCita.modificarFechaCita(this.CitaGuardada.idCita, fechaSeleccionada, horaSeleccionada, this.CitaGuardada.horarioTrabajo.medico.idUsuario);

            string script;
            if (res != 0) script = "closeModal('modalModify'); alert('Cita modificada con éxito para el " + nuevaFechaCompleta.ToString("dd 'de' MMMM 'a las' hh:mm tt") + "'); window.location.reload();";
            else script = "closeModal('modalModify'); alert('¡Algo sucedio! Intenta cancelar tu cita mas tarde.'); window.location.reload();";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "ModifySuccessScript", script, true);
        }

    }
}