using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.EnterpriseServices;
using System.Linq;
using System.Management.Instrumentation;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using PazCitasWA.ServiciosWS;

namespace PazCitasWA
{
    public partial class EmitirReceta : System.Web.UI.Page
    {
        private BindingList<medicamento> medicamentos;
        private BindingList<lineaRecetaMedicamento> lineas;

        private medicamento med;
        private receta receta;

        private MedicamentoWSClient bomed;
        private RecetaWSClient boreceta;

        private CitaWSClient bocita;
        private LineaRecetaMedicamentoWebClient lineabo;

        private NotaClinicaWSClient notabo;
        private notaClinica nota;
        private HistorialMedicoWSClient historialbo;
        String accion;
        protected void Page_Load(object sender, EventArgs e)
        {

            accion = Request.QueryString["accion"];

            

            if (accion == null)
            {
                //Revisar si es ispostback
                if (!IsPostBack)
                {
                    cita citaselec = (cita)Session["citaSeleccionada"];
                    txtDNIPaciente.Text = citaselec.paciente.dni;
                    TextNombre.Text = citaselec.paciente.nombre + citaselec.paciente.apellidoPaterno;
                    TextTelefono.Text = citaselec.paciente.telefono;
                }

                bomed = new MedicamentoWSClient();
                boreceta = new RecetaWSClient();
                bocita = new CitaWSClient();
                receta = new receta();
                notabo = new NotaClinicaWSClient();
                historialbo = new HistorialMedicoWSClient();

                if (Session["lineas"] == null)
                {
                    lineas = new BindingList<lineaRecetaMedicamento>();

                }
                else
                    lineas = (BindingList<lineaRecetaMedicamento>)Session["lineas"];


            }
            else if (accion == "ver")
            {
                lineabo = new LineaRecetaMedicamentoWebClient();



                notaClinica notasel = (notaClinica)Session["notaSeleccionada"];
                lineas = new BindingList<lineaRecetaMedicamento>(lineabo.listar_lineas_x_receta(notasel.receta.idReceta));

                gvLineasMedicamento.DataSource = lineas;
                gvLineasMedicamento.DataBind();

                paciente pac = (paciente)Session["pac"];

                txtDNIPaciente.Text = pac.dni;
                txtDNIPaciente.Enabled = false;
                TextNombre.Text = pac.nombre;
                TextNombre.Enabled = false;
                TextTelefono.Text = pac.telefono;
                TextTelefono.Enabled = false;

                txtIndicaciones.Text = notasel.receta.indicaciones;
                txtIndicaciones.Enabled = false;
                TextDescripcion.Text = notasel.descripcion;
                TextDescripcion.Enabled = false;
                TextDiag.Text = notasel.diagnostico;
                TextDescripcion.Enabled = false;
                TextDiag.Enabled = false;
                TextObs.Text = notasel.observaciones;
                TextObs.Enabled = false;

                btnBuscarMedicamento.Visible = false;
                btnGuardar.Visible = false;
                btnBuscarMedicamento.Visible = false;
                lbAgregarMedicamento.Visible = false;






            }

        }
        protected void gvLineasMedicamento_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                e.Row.Cells[0].Text = ((medicamento)DataBinder.Eval(e.Row.DataItem, "Medicamento")).nombre;
                e.Row.Cells[1].Text = ((medicamento)DataBinder.Eval(e.Row.DataItem, "Medicamento")).presentacion;
                e.Row.Cells[2].Text = DataBinder.Eval(e.Row.DataItem, "cantidad").ToString();

                if (accion == "ver")
                {
                    LinkButton btnTrash = (LinkButton)e.Row.FindControl("btnTrash");
                    if (btnTrash != null)
                    {
                        btnTrash.Visible = false;
                    }
                }

            }

        }

        protected void lbAgregarMedicamento_Click(object sender, EventArgs e)
        {
            if (Session["medicamento"] == null)
            {
                lblMensajeError.Text = "Debe seleccionar un medicamento";
                string script = "showModalFormError();";
                ScriptManager.RegisterStartupScript(this, GetType(), "ShowModalFormError", script, true);
                return;
            }
            if (txtCantidadUnidades.Text.Trim().Equals(""))
            {
                lblMensajeError.Text = "Debe ingresar una cantidad de unidades.";
                string script = "showModalFormError();";
                ScriptManager.RegisterStartupScript(this, GetType(), "ShowModalFormError", script, true);
                return;
            }
            lineaRecetaMedicamento line = new lineaRecetaMedicamento();
            int cantidad;

            try
            {
                cantidad = Int32.Parse(txtCantidadUnidades.Text);
            }
            catch (Exception ex)
            {
                lblMensajeError.Text = "La cantidad ingresada no es un número.";
                string script = "showModalFormError();";
                ScriptManager.RegisterStartupScript(this, GetType(), "ShowModalFormError", script, true);
                return;
            }
            if (cantidad <= 0)
            {
                lblMensajeError.Text = "La cantidad ingresada no puede ser cero o negativo";
                string script = "showModalFormError();";
                ScriptManager.RegisterStartupScript(this, GetType(), "ShowModalFormError", script, true);
                return;
            }

            line.cantidad = cantidad;
            line.medicamento = (medicamento)Session["medicamento"];
            lineas.Add(line);
            Session["lineas"] = lineas;

            gvLineasMedicamento.DataSource = lineas;
            gvLineasMedicamento.DataBind();

            txtIDMedicamento.Text = "";
            txtNombreMedicamento.Text = "";
            txtCantidadUnidades.Text = "";
            TextPresentacion.Text = "";
            Session["medicamento"] = null;


        }

        protected void btnBuscarMedicamento_Click(object sender, EventArgs e)
        {
            txtNombreMedicamentoModal.Text = "";
            medicamentos = new BindingList<medicamento>(bomed.listarMedicamento());
            gvMedicamentos.DataSource = medicamentos;
            gvMedicamentos.DataBind();
            Session["medicamentos"] = medicamentos;
            String script = "showModalFormMedicamento();";
            ScriptManager.RegisterStartupScript(this, GetType(), "showModalMedicamento", script, true);

        }

        protected void btnRegresar_Click(object sender, EventArgs e)
        {

            if (accion == null)
            {

                cita citaselec = (cita)Session["citaSeleccionada"];
                estadoAtencion es;
                es = estadoAtencion.EN_ESPERA;
                citaselec.estadoAtencion = es;
                citaselec.estadoAtencionSpecified = true;
                bocita.modificarCita(citaselec);
                Session["citaSeleccionada"] = citaselec;
                Response.Redirect("VerCitaMedico.aspx");
            }
            else
            {

                Session["pac"] = null;
                txtDNIPaciente.Text = "";
                txtDNIPaciente.Enabled = true;
                TextNombre.Text = "";
                TextNombre.Enabled = true;
                TextTelefono.Text = "";
                TextTelefono.Enabled = true;

                txtIndicaciones.Text = "";
                txtIndicaciones.Enabled = true;
                TextDescripcion.Text = "";
                TextDescripcion.Enabled = true;
                TextDiag.Text = "";
                TextDescripcion.Enabled = true;
                TextDiag.Enabled = true;
                TextObs.Text = "";
                TextObs.Enabled = true;

                btnBuscarMedicamento.Visible = true;
                btnGuardar.Visible = true;
                btnBuscarMedicamento.Visible = true;
                lbAgregarMedicamento.Visible = true;
                gvLineasMedicamento.DataSource = null;

                Response.Redirect("MisPacientes.aspx");
            }

        }

        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            if (lineas.Count == 0)
            {
                lblMensajeError.Text = "Debe agregar por lo menos un producto.";
                string script = "showModalFormError();";
                ScriptManager.RegisterStartupScript(this, GetType(), "ShowModalFormError", script, true);
                return;
            }

            if (txtIndicaciones.Text == "")
            {
                lblMensajeError.Text = "Debe agregar una indicacion";
                string script = "showModalFormError();";
                ScriptManager.RegisterStartupScript(this, GetType(), "ShowModalFormError", script, true);
                return;
            }
            receta.indicaciones = txtIndicaciones.Text;
            receta.lineasReceta = lineas.ToArray();

            boreceta = new RecetaWSClient();

            int resultado = boreceta.insertarReceta(receta);
            receta.idReceta = resultado;
            Session["receta"] = receta;

            if (resultado != 0)
            {

                if (TextObs.Text == "")
                {
                    lblMensajeError.Text = "Debe agregar una observacion";
                    string script = "showModalFormError();";
                    ScriptManager.RegisterStartupScript(this, GetType(), "ShowModalFormError", script, true);
                    return;
                }
                if (TextDescripcion.Text == "")
                {
                    lblMensajeError.Text = "Debe agregar una descripcion";
                    string script = "showModalFormError();";
                    ScriptManager.RegisterStartupScript(this, GetType(), "ShowModalFormError", script, true);
                    return;
                }
                if (TextDiag.Text == "")
                {
                    lblMensajeError.Text = "Debe agregar una diagnostico";
                    string script = "showModalFormError();";
                    ScriptManager.RegisterStartupScript(this, GetType(), "ShowModalFormError", script, true);
                    return;
                }
                nota = new notaClinica();
                receta rec = (receta)Session["receta"];

                nota.receta = new receta();
                nota.receta = rec;
                nota.receta.fechaPrescripcionSpecified = true;
                nota.observaciones = TextObs.Text;
                nota.descripcion = TextDescripcion.Text;
                nota.diagnostico = TextDiag.Text;


                cita c = new cita();
                c = (cita)Session["citaSeleccionada"];

                estadoAtencion es;
                es = estadoAtencion.ATENDIDO;
                c.estadoAtencion = es;

                estadoCita ess;
                ess = estadoCita.ATENDIDA;
                c.estadoCita = ess;

                c.estadoCitaSpecified = true;
                c.estadoAtencionSpecified = true;
                bocita.modificarCita(c);

                nota.cita = c;

                int idPaciente = c.paciente.idUsuario;
                historialMedico historialmed = new historialMedico();

                historialmed = new historialMedico();
                historialmed = historialbo.obtenerHistorial(idPaciente);
                nota.historial = historialmed;

                Session["notaClinica"] = nota;

                int res = notabo.insertarNotaClinica(nota);


                Response.Redirect("ListarCitasMedico.aspx");
            }
            else
                Response.Write("Ocurrio un error con el registro");

            Response.Redirect("RegistrarNotaClinica.aspx");

        }

        protected void gvMedicamentos_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                e.Row.Cells[0].Text = DataBinder.Eval(e.Row.DataItem, "IdMedicamento").ToString();
                e.Row.Cells[1].Text = DataBinder.Eval(e.Row.DataItem, "Nombre").ToString();
                e.Row.Cells[2].Text = DataBinder.Eval(e.Row.DataItem, "Presentacion").ToString();
                e.Row.Cells[3].Text = DataBinder.Eval(e.Row.DataItem, "Stock").ToString();

                if (accion == "ver")
                {
                    LinkButton btnTrash = (LinkButton)e.Row.FindControl("lbltrash");
                    if (btnTrash != null)
                    {
                        btnTrash.Visible = false;
                    }
                }
            }
        }

        protected void gvMedicamentos_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvMedicamentos.PageIndex = e.NewPageIndex;
            gvMedicamentos.DataSource = (BindingList<medicamento>)Session["medicamentos"];
            gvMedicamentos.DataBind();
            upBusqMedicamento.Update();
        }

        protected void lbSeleccionarMedicamento_Click(object sender, EventArgs e)
        {
            int idMedicamento = Int32.Parse(((LinkButton)sender).CommandArgument);
            med = ((BindingList<medicamento>)Session["medicamentos"]).SingleOrDefault(x => x.idMedicamento == idMedicamento);

            Session["medicamento"] = med;
            txtIDMedicamento.Text = med.idMedicamento.ToString();
            txtNombreMedicamento.Text = med.nombre.ToString();
            TextPresentacion.Text = med.presentacion.ToString();
            upContenedor.Update();
            string script = "hideModalFormMedicamento();";
            ScriptManager.RegisterStartupScript(this, GetType(), "hideModalFormMedicamento", script, true);

        }

        protected void trashBouton(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            int index = Convert.ToInt32(btn.CommandArgument);

            BindingList<lineaRecetaMedicamento> lineas = (BindingList<lineaRecetaMedicamento>)Session["lineas"];

            if (index >= 0 && index < lineas.Count)
            {
                lineas.RemoveAt(index);
                Session["lineas"] = lineas;

                gvLineasMedicamento.DataSource = lineas;
                gvLineasMedicamento.DataBind();
            }
        }

        protected void lbBusquedaMedicamentoModal_Click(object sender, EventArgs e)
        {

            if (bomed.listarMedicamentoXnombre(txtNombreMedicamentoModal.Text) != null)
            {
                medicamentos = new BindingList<medicamento>(bomed.listarMedicamentoXnombre(txtNombreMedicamentoModal.Text));
                gvMedicamentos.DataSource = medicamentos;
                gvMedicamentos.DataBind();
                Session["medicamentos"] = medicamentos;
            }
            else
            {
                lblMensajeError.Text = "No hay medicamentos con ese nombre";
                string script = "showModalFormError();";
                ScriptManager.RegisterStartupScript(this, GetType(), "ShowModalFormError", script, true);
                txtNombreMedicamentoModal.Text = "";
                return;
            }
        }
    }
}