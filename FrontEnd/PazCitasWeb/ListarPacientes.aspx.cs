using PazCitasWA.ServiciosWS;
using System;
using System.ComponentModel;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace PazCitasWA
{
    public partial class ListarPacientes : System.Web.UI.Page
    {
        private PacienteWSClient wsPaciente;
        private BindingList<paciente> pacientes;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                wsPaciente = new PacienteWSClient();
                pacientes = new BindingList<paciente>(wsPaciente.listarPaciente());
                ViewState["pacientes"] = pacientes;
                gvPacientes.DataSource = pacientes;
                gvPacientes.DataBind();
            }
            else
            {
                pacientes = (BindingList<paciente>)ViewState["pacientes"];
            }
        }

        protected void gvPacientes_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                e.Row.Cells[0].Text = DataBinder.Eval(e.Row.DataItem, "dni").ToString();
                e.Row.Cells[1].Text = DataBinder.Eval(e.Row.DataItem, "nombre").ToString() + " " +
                    DataBinder.Eval(e.Row.DataItem, "apellidoPaterno").ToString() + " " +
                    DataBinder.Eval(e.Row.DataItem, "apellidoMaterno").ToString();
                e.Row.Cells[2].Text = DataBinder.Eval(e.Row.DataItem, "email").ToString();
                e.Row.Cells[3].Text = DataBinder.Eval(e.Row.DataItem, "direccion").ToString();
                e.Row.Cells[4].Text = DataBinder.Eval(e.Row.DataItem, "telefono").ToString();
            }
        }
        protected void gvPacientes_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvPacientes.PageIndex = e.NewPageIndex;
            gvPacientes.DataSource = (BindingList<paciente>)ViewState["pacientes"];
            gvPacientes.DataBind();
        }

        protected void btnModificar_Click(object sender, EventArgs e)
        {
            int idPaciente = Int32.Parse(((LinkButton)sender).CommandArgument);
            paciente pacienteSeleccionado = pacientes.SingleOrDefault(x => x.idUsuario == idPaciente);
            Session["pacienteSeleccionado"] = pacienteSeleccionado;
            Response.Redirect("RegistrarPaciente.aspx?accion=modificar");
        }

        protected void btnEliminar_Click(object sender, EventArgs e)
        {
            int idPaciente = Int32.Parse(((LinkButton)sender).CommandArgument);
            wsPaciente.eliminarPaciente(idPaciente);
            Response.Redirect("ListarPacientes.aspx");
        }

        protected void btnRegistrar_Click(object sender, EventArgs e)
        {
            Response.Redirect("RegistrarPaciente.aspx");
        }

        protected void btnVer_Click(object sender, EventArgs e)
        {
            int idPaciente = Int32.Parse(((LinkButton)sender).CommandArgument);
            paciente pacienteSeleccionado = pacientes.SingleOrDefault(x => x.idUsuario == idPaciente);
            Session["pacienteSeleccionado"] = pacienteSeleccionado;
            Response.Redirect("RegistrarPaciente.aspx?accion=ver");
        }

        protected void btnBuscar_Click(object sender, EventArgs e)
        {
            wsPaciente = new PacienteWSClient();
            BindingList<paciente> pacientesFiltrados = new BindingList<paciente>(wsPaciente.listarPacienteXCadena(txtCadena.Text));
            ViewState["pacientes"] = pacientesFiltrados;
            gvPacientes.DataSource = pacientesFiltrados;
            gvPacientes.DataBind();
        }
    }
}