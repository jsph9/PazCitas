using PazCitasWA.ServiciosWS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace PazCitasWA
{
    public partial class RegistrarTurnosMedico : System.Web.UI.Page
    {
        private MedicoWSClient wsMedico = new MedicoWSClient();
        private TurnoWSClient wsTurno = new TurnoWSClient();
        private HorarioTrabajoWSClient wsHorario = new HorarioTrabajoWSClient();

        // Lista para mantener turnos asignados
        private List<int> turnosAsignados = new List<int>();

        protected int IdMedico =>
            int.TryParse(Request.QueryString["idMedico"], out var id) ? id : 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (IdMedico == 0) Response.Redirect("AsignarTurnos.aspx");

                CargarTurnosAsignados();
                CargarDatosMedico();
                CargarGrillaTurnos();
            }
            else
            {
                // Recuperar del ViewState en postback
                if (ViewState["TurnosAsignados"] != null)
                    turnosAsignados = (List<int>)ViewState["TurnosAsignados"];
            }
        }

        private void CargarTurnosAsignados()
        {
            try
            {
                var horariosAsignados = wsHorario.listarPorMedico(IdMedico);
                turnosAsignados = horariosAsignados?.Select(h => h.turno.idTurno).ToList() ?? new List<int>();
            }
            catch
            {
                turnosAsignados = new List<int>();
            }

            ViewState["TurnosAsignados"] = turnosAsignados;
        }

        private void CargarDatosMedico()
        {
            var medico = wsMedico.obtenerMedico(IdMedico);
            lblNombreMedico.Text = $"Dr. {medico.nombre} {medico.apellidoPaterno} {medico.apellidoMaterno}";
            lblDNIMedico.Text = medico.dni;
            lblCMPMedico.Text = medico.codigoMedico;
        }

        private void CargarGrillaTurnos()
        {
            var turnos = wsTurno.listarTurno();

            // Días de la semana en orden
            var diasSemana = new[] { "Lunes", "Martes", "Miercoles", "Jueves", "Viernes" };

            // Obtener horas únicas y ordenarlas
            var horasUnicas = turnos.Select(t => t.horaInicio.ToString(@"HH:mm"))
                                   .Distinct()
                                   .OrderBy(h => h)
                                   .ToList();

            // Crear estructura de datos para la grilla
            var grillaDatos = horasUnicas.Select(hora => new
            {
                Hora = hora,
                TurnosPorDia = diasSemana.Select(dia =>
                {
                    var turno = turnos.FirstOrDefault(t =>
                        t.dia.ToString().Equals(dia, StringComparison.OrdinalIgnoreCase) &&
                        t.horaInicio.ToString(@"HH:mm") == hora);

                    return new
                    {
                        Dia = dia,
                        Turno = turno,
                        IdTurno = turno?.idTurno ?? -1,
                        Disponible = turno != null
                    };
                }).ToList()
            }).ToList();

            rptHorarios.DataSource = grillaDatos;
            rptHorarios.DataBind();
        }

        // Método para obtener turnos asignados en formato JavaScript
        public string GetTurnosAsignadosJS()
        {
            if (ViewState["TurnosAsignados"] != null)
                turnosAsignados = (List<int>)ViewState["TurnosAsignados"];

            return string.Join(",", turnosAsignados);
        }

        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            try
            {
                // Obtener turnos seleccionados del campo oculto
                var turnosSeleccionados = new List<int>();
                if (!string.IsNullOrEmpty(hfTurnosSeleccionados.Value))
                {
                    turnosSeleccionados = hfTurnosSeleccionados.Value
                        .Split(',')
                        .Where(s => !string.IsNullOrEmpty(s))
                        .Select(int.Parse)
                        .ToList();
                }

                // Eliminar asignaciones previas
                wsHorario.eliminarHorarioPorMedico(IdMedico);

                // Insertar nuevas asignaciones
                if (turnosSeleccionados.Any())
                {
                    var medico = wsMedico.obtenerMedico(IdMedico);

                    foreach (int idTurno in turnosSeleccionados)
                    {
                        var horarioIn = new horarioTrabajo();
                        horarioIn.medico = medico;

                        var turnoIn = new turno();
                        turnoIn.idTurno = idTurno;
                        horarioIn.turno = turnoIn;

                        wsHorario.insertaHorario(horarioIn);
                    }
                }

                // Mensaje de éxito y redirección
                Response.Write("<script>alert('✅ Turnos guardados correctamente'); window.location='AsignarTurnos.aspx';</script>");
            }
            catch (Exception ex)
            {
                Response.Write($"<script>alert('❌ Error al guardar: {ex.Message}');</script>");
            }
        }
    }
}
