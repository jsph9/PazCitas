using PazCitasWA.ServiciosWS;
using System;
using System.ComponentModel;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace PazCitasWA
{
    public partial class ListarMedicos : System.Web.UI.Page
    {
        private MedicoWSClient wsMedico;
        private BindingList<medico> medicos;
        private BindingList<medico> medicosFiltrados;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                wsMedico = new MedicoWSClient();
                medicos = new BindingList<medico>(wsMedico.listarMedico());
                ViewState["medicos"] = medicos;
                gvMedicos.DataSource = medicos;
                gvMedicos.DataBind();

            }
            else
            {
                // Recuperar la lista en postbacks
                medicos = (BindingList<medico>)ViewState["medicos"];
            }
        }

        protected void gvMedicos_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                e.Row.Cells[0].Text = DataBinder.Eval(e.Row.DataItem, "dni").ToString();
                e.Row.Cells[1].Text = DataBinder.Eval(e.Row.DataItem, "codigoMedico").ToString();
                e.Row.Cells[2].Text = DataBinder.Eval(e.Row.DataItem, "nombre").ToString() + " " +
                    DataBinder.Eval(e.Row.DataItem, "apellidoPaterno").ToString() + " " +
                    DataBinder.Eval(e.Row.DataItem, "apellidoMaterno").ToString();
                e.Row.Cells[3].Text = DataBinder.Eval(e.Row.DataItem, "especialidad.nombre").ToString();
                e.Row.Cells[4].Text = DataBinder.Eval(e.Row.DataItem, "sede.nombre").ToString();
                e.Row.Cells[5].Text = DataBinder.Eval(e.Row.DataItem, "consultorio.nombreConsultorio").ToString();
            }
        }

        protected void gvMedicos_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvMedicos.PageIndex = e.NewPageIndex;
            gvMedicos.DataSource = (BindingList<medico>)ViewState["medicos"];
            gvMedicos.DataBind();
        }
        protected void btnRegistrar_Click(object sender, EventArgs e)
        {
            Response.Redirect("RegistrarMedico.aspx");
        }

        protected void btnModificar_Click(object sender, EventArgs e)
        {
            int idMedico = Int32.Parse(((LinkButton)sender).CommandArgument);
            medico medicoSeleccionado = medicos.SingleOrDefault(x => x.idUsuario == idMedico);
            Session["medicoSeleccionado"] = medicoSeleccionado;
            Response.Redirect("RegistrarMedico.aspx?accion=modificar");
        }

        protected void btnEliminar_Click(object sender, EventArgs e)
        {
            int idMedico = Int32.Parse(((LinkButton)sender).CommandArgument);
            wsMedico.eliminarMedico(idMedico);
            Response.Redirect("ListarMedicos.aspx");
        }

        protected void btnVer_Click(object sender, EventArgs e)
        {
            int idMedico = Int32.Parse(((LinkButton)sender).CommandArgument);
            medico medicoSeleccionado = medicos.SingleOrDefault(x => x.idUsuario == idMedico);
            Session["medicoSeleccionado"] = medicoSeleccionado;
            Response.Redirect("RegistrarMedico.aspx?accion=ver");
        }

        protected void btnBuscar_Click(object sender, EventArgs e)
        {
            wsMedico = new MedicoWSClient();
            medicosFiltrados = new BindingList<medico>(wsMedico.listarMedicoXCadena(txtCadena.Text));
            ViewState["medicos"] = medicosFiltrados;
            gvMedicos.DataSource = medicosFiltrados;
            gvMedicos.DataBind();
        }
    }
}