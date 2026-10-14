using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using PazCitasWA.ServiciosWS;

namespace PazCitasWA
{
    public partial class ListarCitasPaciente : System.Web.UI.Page
    {
        private CitaWSClient wsCita;
        private BindingList<cita> citas;

        private MedicoWSClient wsMedico;
        private TurnoWSClient wsTurno;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (IdPacienteLogueado == 0)
            {
                // Manejar caso de no estar logueado (ya se haría en la propiedad IdPacienteLogueado)
                lblMensajeGeneral.Text = "Debe iniciar sesión para ver sus citas.";
                lblMensajeGeneral.Visible = true;
                rptMisCitas.DataSource = new BindingList<cita>(); // Vaciar repeater
                rptMisCitas.DataBind();
                return;
            }

            try
            {
                wsCita = new CitaWSClient();
                citas = new BindingList<cita>(wsCita.listarXPacienteCompletoSinDatosPaciente(IdPacienteLogueado));

                // ENLAZAR DATOS AL REPEATER
                rptMisCitas.DataSource = citas;
                rptMisCitas.DataBind();
            }
            catch (Exception ex)
            {
                lblMensajeGeneral.Text = "Parece que no tienes citas. ";
                lblMensajeGeneral.Visible = true;
            }
        }
        private int IdPacienteLogueado // Prueba
        {
            get
            {
                if (Session["id_usuario"] != null && int.TryParse(Session["id_usuario"].ToString(), out int id))
                {
                    return id;
                }
                // Redirigir a login si no hay sesión o devolver un valor que indique error
                Response.Redirect("Login.aspx"); 
                return -1; //Para la prueba
            }
        }

        protected void rptMisCitas_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                cita ct = (cita)e.Item.DataItem;
                var lit = (Literal)e.Item.FindControl("litNombreMedico");
                if (lit != null)
                {
                    lit.Text = "Dr. " + ct.horarioTrabajo.medico.nombre.ToString() + " " + ct.horarioTrabajo.medico.apellidoPaterno.ToString();
                }

                lit = (Literal)e.Item.FindControl("litSubNom");
                if (lit != null)
                {
                    lit.Text = ct.horarioTrabajo.medico.email.ToString();
                }

                lit = (Literal)e.Item.FindControl("litEspecialidadMedico");
                if (lit != null)
                {

                    lit.Text = "<span class=\"specialty-pill\">" + HttpUtility.HtmlEncode(ct.horarioTrabajo.medico.especialidad.nombre.ToString()) + "</span>";
                }

                lit = (Literal)e.Item.FindControl("litEstadoCita");
                if (lit != null)
                {
                    // Etiqueta de color segun el estado (estilos .status-pill en el .aspx)
                    string clase, icono, texto;
                    switch (ct.estadoCita)
                    {
                        case estadoCita.PROGRAMADA:
                            clase = "programada"; icono = "fa-regular fa-calendar-check"; texto = "Programada";
                            break;
                        case estadoCita.ATENDIDA:
                            clase = "atendida"; icono = "fa-solid fa-circle-check"; texto = "Atendida";
                            break;
                        default:
                            clase = "cancelada"; icono = "fa-solid fa-circle-xmark"; texto = "Cancelada";
                            break;
                    }
                    lit.Text = "<span class=\"status-pill " + clase + "\"><i class=\"" + icono + " pill-icon\"></i>" + texto + "</span>";
                }

                lit = (Literal)e.Item.FindControl("litFecha");
                if (lit != null)
                {
                    DateTime d = ct.fecha;
                    lit.Text = d.ToString("dd/MM/yyyy");
                }

                lit = (Literal)e.Item.FindControl("litHora");
                if (lit != null)
                {

                    lit.Text = ct.horarioTrabajo.turno.horaInicio.ToString("HH:mm");
                }
            }
        }

        protected void btnCancelarCita_Click(object sender, EventArgs e)
        {

        }

        protected void btnVerDetalle_Click(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            string idCita = btn.CommandArgument;
            Response.Redirect("DetalleCitaPaciente.aspx?id=" + idCita);
        }
    }
}