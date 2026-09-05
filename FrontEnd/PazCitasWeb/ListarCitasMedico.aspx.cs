using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Security.Cryptography;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using PazCitasWA.ServiciosWS;

namespace PazCitasWA
{
    public partial class ListarCitasMedico : System.Web.UI.Page
    {
        private CitaWSClient citabo;
        private MedicoWSClient wsMedico;
        BindingList<cita> citasmed;
        medico med;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                lblMensaje.Text = "";
                citabo = new CitaWSClient();
                wsMedico = new MedicoWSClient();

                int idMedico = (int)Session["id_usuario"];
                med = wsMedico.obtenerMedico(idMedico);
                Session["medico"] = med;

                // Cargar todas las citas inicialmente
                var lista = citabo.listaCitaPorMedico(med.idUsuario);
                if (lista != null && lista.Length > 0)
                {
                    citasmed = new BindingList<cita>(lista);
                    gvCitasMed.DataSource = citasmed;
                    gvCitasMed.DataBind();

                    Session["citasmed"] = citasmed;
                }
                else
                {
                    lblMensaje.Text = "No tiene citas pendientes";
                }
            }
        }

        protected void gvCitasMed_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvCitasMed.PageIndex = e.NewPageIndex;
            citasmed = (BindingList<cita>)Session["citasmed"];

            if (citasmed != null)
            {
                gvCitasMed.DataSource = citasmed;
                gvCitasMed.DataBind();
            }
        }

        protected void BtonSeleccionar_Click(object sender, EventArgs e)
        {
            int idCita = Int32.Parse(((LinkButton)sender).CommandArgument);
            citasmed = (BindingList<cita>)Session["citasmed"];
            cita citaSeleccionada = citasmed.SingleOrDefault(x => x.idCita == idCita);
            Session["citaSeleccionada"] = citaSeleccionada;
            Response.Redirect("VerCitaMedico.aspx");
        }

        protected void gvCitasMed_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                e.Row.Cells[0].Text = ((paciente)DataBinder.Eval(e.Row.DataItem, "paciente")).nombre + " " + ((paciente)DataBinder.Eval(e.Row.DataItem, "paciente")).apellidoPaterno;
                e.Row.Cells[1].Text = ((paciente)DataBinder.Eval(e.Row.DataItem, "paciente")).dni;
                DateTime fecha = (DateTime)DataBinder.Eval(e.Row.DataItem, "fecha");
                e.Row.Cells[2].Text = fecha.ToString("dd/MM/yyyy");

                cita citaTemp = (cita)e.Row.DataItem;
                
                    int idTurno = citaTemp.horarioTrabajo.turno.idTurno;

                    TurnoWSClient wsTurno = new TurnoWSClient();
                    turno turnoTemp = wsTurno.obtenerXId(idTurno);

                        DateTime horaInicio = (DateTime)turnoTemp.horaInicio;
                        e.Row.Cells[3].Text = horaInicio.ToString(@"hh\:mm");
                    


                string  est = e.Row.Cells[4].Text = (DataBinder.Eval(e.Row.DataItem, "estadoCita")).ToString();
                e.Row.Cells[5].Text = (DataBinder.Eval(e.Row.DataItem, "estadoAtencion")).ToString();

                string estadoSeleccionado = ddlEstadoCita.SelectedValue;
                // Si el estado es ATENDIDA o CANCELADA, ocultar el botón

                LinkButton btnVerDetalle = (LinkButton)e.Row.FindControl("BtonSeleccionar");
                
                if (btnVerDetalle != null)
                {
                    if (est.Equals("ATENDIDA", StringComparison.OrdinalIgnoreCase)
                        || est.Equals("CANCELADA", StringComparison.OrdinalIgnoreCase))
                    {
                        btnVerDetalle.Visible = false;
                    }
                }

            }
        }

        protected void btnFiltrar_Click(object sender, EventArgs e)
        {
            lblMensaje.Text = "";

            citabo = new CitaWSClient();
            wsMedico = new MedicoWSClient();

            int idMedico = (int)Session["id_usuario"];
            string estadoSeleccionado = ddlEstadoCita.SelectedValue;

            if (string.IsNullOrEmpty(estadoSeleccionado))
            {
                // Si se elige "Todos" o vacío, mostrar todas
                var lista = citabo.listaCitaPorMedico(idMedico);
                if (lista != null && lista.Length > 0)
                {
                    citasmed = new BindingList<cita>(lista);
                    gvCitasMed.DataSource = citasmed;
                    gvCitasMed.DataBind();

                    Session["citasmed"] = citasmed;
                }
                else
                {
                    gvCitasMed.DataSource = null;
                    gvCitasMed.DataBind();
                    lblMensaje.Text = "No tiene citas pendientes.";
                }
            }
            else
            {
                // Si se selecciona un estado específico, filtrar
                var listaFiltrada = citabo.listaCitaPorMedicoXestado(idMedico, estadoSeleccionado);
                if (listaFiltrada != null && listaFiltrada.Length > 0)
                {
                    citasmed = new BindingList<cita>(listaFiltrada);
                    gvCitasMed.DataSource = citasmed;
                    gvCitasMed.DataBind();

                    Session["citasmed"] = citasmed;
                }
                else
                {
                    gvCitasMed.DataSource = null;
                    gvCitasMed.DataBind();
                    lblMensaje.Text = "No se encontraron citas para el estado seleccionado.";
                }
            }
        }
    }
}