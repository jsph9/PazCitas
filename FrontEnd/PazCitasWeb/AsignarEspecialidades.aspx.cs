using PazCitasWA.ServiciosWS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace PazCitasWA
{
    public partial class AsignarEspecialidades : System.Web.UI.Page
    {
        private SedeWSClient wsSede;
        private EspecialidadWSClient wsEspecialidad;
        private int idSede;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Obtener el ID de la sede desde la URL
            if (!int.TryParse(Request.QueryString["idSede"], out idSede))
            {
                // Si no hay ID válido, regresar a la lista de sedes
                Response.Redirect("ListarSedes.aspx");
                return;
            }

            if (!IsPostBack)
            {
                CargarDatosSede();
                CargarEspecialidades();
            }
        }

        private void CargarDatosSede()
        {
            try
            {
                wsSede = new SedeWSClient();
                // Asumiendo que tienes un método para obtener una sede por ID
                var sede = wsSede.obtenerSedePorId(idSede);

                if (sede != null)
                {
                    lblIdSede.Text = sede.idSede.ToString();
                    lblNombreSede.Text = sede.nombre;
                    lblDireccionSede.Text = sede.direccion ?? "Dirección no especificada";
                }
                else
                {
                    // Si no se encuentra la sede, regresar
                    Response.Write("<script>alert('Sede no encontrada.'); window.location='ListarSedes.aspx';</script>");
                }
            }
            catch (Exception ex)
            {
                Response.Write($"<script>alert('Error al cargar datos de la sede: {ex.Message}');</script>");
            }
        }

        private void CargarEspecialidades()
        {
            try
            {
                wsEspecialidad = new EspecialidadWSClient();

                // Obtener todas las especialidades
                var todasEspecialidades = wsEspecialidad.listarEspecialidad();

                // Obtener especialidades ya asignadas a esta sede
                var especialidadesAsignadas = ObtenerEspecialidadesAsignadas();

                // Crear lista combinada con información de asignación
                var especialidadesConAsignacion = todasEspecialidades.Select(esp => new
                {
                    idEspecialidad = esp.idEspecialidad,
                    nombre = esp.nombre,
                    descripcion = esp.descripcion,
                    asignada = especialidadesAsignadas.Any(ea => ea.idEspecialidad == esp.idEspecialidad)
                }).ToList();

                rptEspecialidades.DataSource = especialidadesConAsignacion;
                rptEspecialidades.DataBind();

                // Actualizar estadísticas
                ActualizarEstadisticas(especialidadesConAsignacion.Count,
                                     especialidadesAsignadas.Count);

                // Mostrar panel si no hay especialidades
                pnlSinEspecialidades.Visible = !especialidadesConAsignacion.Any();
            }
            catch (Exception ex)
            {
                Response.Write($"<script>alert('Error al cargar especialidades: {ex.Message}');</script>");
                pnlSinEspecialidades.Visible = true;
            }
        }

        private List<especialidad> ObtenerEspecialidadesAsignadas()
        {
            try
            {
                // Aquí deberías llamar a tu servicio web para obtener las especialidades
                // ya asignadas a esta sede específica
                // Por ejemplo: return wsSedeEspecialidad.obtenerEspecialidadesPorSede(idSede);
                SedeEspecialidadWSClient wsSedeEspecialidad = new SedeEspecialidadWSClient();
                // Por ahora, retorno una lista vacía como ejemplo
                var retornar = wsEspecialidad.listarXSede(idSede).ToList();
                return retornar;
            }
            catch
            {
                return new List<especialidad>();
            }
        }

        private void ActualizarEstadisticas(int total, int asignadas)
        {
            lblTotalEspecialidades.Text = total.ToString();
            lblEspecialidadesAsignadas.Text = asignadas.ToString();
            lblEspecialidadesDisponibles.Text = (total - asignadas).ToString();
        }

        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            try
            {
                var especialidadesSeleccionadas = new List<int>();

                // Recorrer el repeater para obtener las especialidades seleccionadas
                foreach (RepeaterItem item in rptEspecialidades.Items)
                {
                    if (item.ItemType == ListItemType.Item || item.ItemType == ListItemType.AlternatingItem)
                    {
                        CheckBox chkEspecialidad = item.FindControl("chkEspecialidad") as CheckBox;
                        if (chkEspecialidad != null && chkEspecialidad.Checked)
                        {
                            // Obtener el ID de la especialidad desde el atributo data
                            string especialidadId = chkEspecialidad.Attributes["data-especialidad-id"];
                            if (int.TryParse(especialidadId, out int id))
                            {
                                especialidadesSeleccionadas.Add(id);
                            }
                        }
                    }
                }

                // Guardar las asignaciones
                GuardarAsignaciones(especialidadesSeleccionadas);

                // Mostrar mensaje de éxito y regresar
                Response.Write("<script>alert('Especialidades asignadas correctamente.'); window.location='ListarSedes.aspx';</script>");
            }
            catch (Exception ex)
            {
                Response.Write($"<script>alert('Error al guardar asignaciones: {ex.Message}');</script>");
            }
        }

        private void GuardarAsignaciones(List<int> especialidadesSeleccionadas)
        {
            // Aquí implementarías la lógica para guardar las asignaciones
            // Esto podría involucrar:
            // 1. Eliminar todas las asignaciones existentes para esta sede
            // 2. Insertar las nuevas asignaciones

            // Ejemplo de implementación:
            
            try
            {
                var wsSedeEspecialidad = new SedeEspecialidadWSClient();
                
                // Eliminar asignaciones existentes
                wsSedeEspecialidad.eliminarSedeEspecialidadXSede(idSede);
                
                // Insertar nuevas asignaciones
                sede sedeInsertar = new sede();
                wsSede = new SedeWSClient();
                sedeInsertar = wsSede.obtenerSedePorId(idSede);
                wsEspecialidad = new EspecialidadWSClient();
                foreach (int idEspecialidad in especialidadesSeleccionadas)
                {
                    especialidad espInsertar = new especialidad();
                    espInsertar = wsEspecialidad.obtenerEspecialidadPorId(idEspecialidad);
                    sedeEspecialidad sedEspInsertar = new sedeEspecialidad();
                    sedEspInsertar.sede = sedeInsertar;
                    sedEspInsertar.especialidad = espInsertar;
                    wsSedeEspecialidad.insertarSedeEspecialidad(sedEspInsertar);
                }
            }
            catch (Exception ex)
            {
                throw new Exception($"Error al guardar en base de datos: {ex.Message}");
            }
            
        }

        protected void btnRegresar_Click(object sender, EventArgs e)
        {
            Response.Redirect("ListarSedes.aspx");
        }
    }
}