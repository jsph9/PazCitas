<%@ Page Title="" Language="C#" MasterPageFile="~/PazCitasMedico.Master" AutoEventWireup="true" CodeBehind="EmitirReceta.aspx.cs" Inherits="PazCitasWA.EmitirReceta" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cph_Title" runat="server" />

<asp:Content ID="Content2" ContentPlaceHolderID="cph_Scripts" runat="server">
    <script src="Scripts/PazcitasS/RegistrarLineaMedicamento.js"></script>
    <style>
/* Estilos personalizados para la página de recetas - Tema Azul */
.prescription-container {
    background: linear-gradient(135deg, #f0f8ff 0%, #e6f3ff 100%);
    min-height: 100vh;
    padding: 2rem 0;
}

.prescription-header {
    background: linear-gradient(135deg, #0d6efd 0%, #0b5ed7 100%);
    color: white;
    padding: 2rem;
    border-radius: 15px 15px 0 0;
    box-shadow: 0 4px 15px rgba(13, 110, 253, 0.3);
    margin-bottom: 0;
}

.prescription-header h2 {
    margin: 0;
    font-weight: 600;
    text-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

.prescription-header .fa-prescription-bottle-medical {
    background: rgba(255,255,255,0.2);
    padding: 0.5rem;
    border-radius: 50%;
    margin-right: 1rem;
}

.section-card {
    border: none;
    border-radius: 15px;
    box-shadow: 0 8px 25px rgba(0,0,0,0.1);
    margin-bottom: 2rem;
    overflow: hidden;
    transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.section-card:hover {
    transform: translateY(-2px);
    box-shadow: 0 12px 35px rgba(0,0,0,0.15);
}

.section-header {
    background: linear-gradient(135deg, #0dcaf0 0%, #0aa2c0 100%);
    color: white;
    padding: 1.25rem 1.5rem;
    font-weight: 600;
    font-size: 1.1rem;
    border: none;
    margin: 0;
}

.section-header.patient-info {
    background: linear-gradient(135deg, #6610f2 0%, #0d6efd 100%);
}

.section-header.prescription-detail {
    background: linear-gradient(135deg, #0d6efd 0%, #0dcaf0 100%);
}

.section-header.observations {
    background: linear-gradient(135deg, #17a2b8 0%, #0dcaf0 100%);
}

.section-body {
    padding: 2rem;
    background: white;
}

.form-label-custom {
    color: #0d6efd;
    font-weight: 600;
    margin-bottom: 0.5rem;
}

.form-control-custom {
    border: 2px solid #b6d7ff;
    border-radius: 10px;
    padding: 0.75rem 1rem;
    transition: all 0.3s ease;
    font-size: 0.95rem;
}

.form-control-custom:focus {
    border-color: #0d6efd;
    box-shadow: 0 0 0 0.2rem rgba(13, 110, 253, 0.15);
    transform: translateY(-1px);
}

.btn-custom {
    border-radius: 25px;
    padding: 0.6rem 1.5rem;
    font-weight: 600;
    text-transform: uppercase;
    letter-spacing: 0.5px;
    transition: all 0.3s ease;
    border: none;
    box-shadow: 0 4px 15px rgba(0,0,0,0.1);
}

.btn-custom:hover {
    transform: translateY(-2px);
    box-shadow: 0 6px 20px rgba(0,0,0,0.2);
}

.btn-search {
    background: linear-gradient(135deg, #0dcaf0 0%, #17a2b8 100%);
    color: white;
}

.btn-add {
    background: linear-gradient(135deg, #0d6efd 0%, #0b5ed7 100%);
    color: white;
}

.btn-delete {
    background: linear-gradient(135deg, #6c757d 0%, #495057 100%);
    color: white;
    border-radius: 50%;
    width: 35px;
    height: 35px;
    padding: 0;
    display: flex;
    align-items: center;
    justify-content: center;
}

.medication-grid {
    border-radius: 15px;
    overflow: hidden;
    box-shadow: 0 4px 15px rgba(0,0,0,0.1);
}

.medication-grid .table {
    margin: 0;
}

.medication-grid .table thead th {
    background: linear-gradient(135deg, #0d6efd 0%, #6610f2 100%);
    color: white;
    border: none;
    padding: 1rem;
    font-weight: 600;
    text-transform: uppercase;
    letter-spacing: 0.5px;
    font-size: 0.85rem;
}

.medication-grid .table tbody td {
    padding: 1rem;
    vertical-align: middle;
    border-color: #b6d7ff;
}

.medication-grid .table tbody tr:hover {
    background-color: #f0f8ff;
}

.action-buttons {
    background: linear-gradient(135deg, #f0f8ff 0%, #e6f3ff 100%);
    padding: 1.5rem 2rem;
    border-radius: 0 0 15px 15px;
    border-top: 1px solid #b6d7ff;
}

.btn-secondary-custom {
    background: linear-gradient(135deg, #17a2b8 0%, #138496 100%);
    color: white;
}

.btn-primary-custom {
    background: linear-gradient(135deg, #0d6efd 0%, #0b5ed7 100%);
    color: white;
}

.input-group-custom {
    position: relative;
}

.input-group-custom .form-control-custom {
    padding-right: 3rem;
}

.search-icon {
    position: absolute;
    right: 1rem;
    top: 50%;
    transform: translateY(-50%);
    z-index: 10;
}

.info-badge {
    background: linear-gradient(135deg, #0dcaf0 0%, #17a2b8 100%);
    color: white;
    padding: 0.25rem 0.75rem;
    border-radius: 15px;
    font-size: 0.8rem;
    font-weight: 600;
}

.section-divider {
    height: 3px;
    background: linear-gradient(90deg, #0d6efd, #0dcaf0, #17a2b8, #6610f2);
    border: none;
    border-radius: 2px;
    margin: 2rem 0;
}

@media (max-width: 768px) {
    .prescription-container {
        padding: 1rem 0;
    }
    
    .prescription-header {
        padding: 1.5rem;
        border-radius: 10px 10px 0 0;
    }
    
    .section-body {
        padding: 1.5rem;
    }
    
    .btn-custom {
        padding: 0.5rem 1rem;
        font-size: 0.9rem;
    }
}
</style>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="cph_Contenido" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server" />

    <asp:UpdatePanel ID="upContenedor" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <div class="prescription-container">
                <div class="container">
                    <!-- Header Principal -->
                    <div class="prescription-header">
                        <h2><i class="fa-solid fa-prescription-bottle-medical"></i>Emitir Nota Clínica</h2>
                        <p class="mb-0 mt-2 opacity-75">Sistema de gestión de recetas médicas</p>
                    </div>

                    <!-- Información del paciente -->
                    <div class="section-card">
                        <div class="section-header patient-info">
                            <i class="fa-solid fa-user-injured me-2"></i>Información del Paciente
                        </div>
                        <div class="section-body">
                            <div class="row g-4">
                                <div class="col-md-4">
                                    <asp:Label ID="lblDNICliente" runat="server" Text="DNI del Paciente" CssClass="form-label form-label-custom" />
                                    <asp:TextBox ID="txtDNIPaciente" runat="server" Enabled="false" CssClass="form-control form-control-custom" />
                                </div>
                                <div class="col-md-4">
                                    <asp:Label ID="LabelNombre" runat="server" Text="Nombre Completo" CssClass="form-label form-label-custom" />
                                    <asp:TextBox ID="TextNombre" runat="server" Enabled="false" CssClass="form-control form-control-custom" />
                                </div>
                                <div class="col-md-4">
                                    <asp:Label ID="Labeltelefono" runat="server" Text="Teléfono de Contacto" CssClass="form-label form-label-custom" />
                                    <asp:TextBox ID="TextTelefono" runat="server" Enabled="false" CssClass="form-control form-control-custom" />
                                </div>
                            </div>
                        </div>
                    </div>

                    <hr class="section-divider" />

                    <!-- Detalle de receta -->
                    <div class="section-card">
                        <div class="section-header prescription-detail">
                            <i class="fa-solid fa-pills me-2"></i>Detalle de Receta Médica
                        </div>
                        <div class="section-body">
                            <div class="row g-4 mb-4">
                                <div class="col-md-3">
                                    <asp:Label ID="lblIDMedicamento" runat="server" Text="ID Medicamento" CssClass="form-label form-label-custom" />
                                    <div class="input-group-custom">
                                        <asp:TextBox ID="txtIDMedicamento" runat="server" Enabled="false" CssClass="form-control form-control-custom" />
                                        <asp:LinkButton ID="btnBuscarMedicamento" runat="server" CssClass="btn btn-custom btn-search search-icon" OnClick="btnBuscarMedicamento_Click">
                                            <i class="fa-solid fa-magnifying-glass"></i>
                                        </asp:LinkButton>
                                    </div>
                                </div>
                                <div class="col-md-5">
                                    <asp:Label ID="lblNombreMedicamento" runat="server" Text="Nombre del Medicamento" CssClass="form-label form-label-custom" />
                                    <asp:TextBox ID="txtNombreMedicamento" runat="server" Enabled="false" CssClass="form-control form-control-custom" />
                                </div>
                                <div class="col-md-4">
                                    <asp:Label ID="lblPresentacionMedicamento" runat="server" Text="Presentación" CssClass="form-label form-label-custom" />
                                    <asp:TextBox ID="TextPresentacion" runat="server" Enabled="false" CssClass="form-control form-control-custom" />
                                </div>
                            </div>

                            <div class="row g-4 mb-4">
                                <div class="col-md-3">
                                    <asp:Label ID="lblCantidadUnidades" runat="server" Text="Cantidad" CssClass="form-label form-label-custom" />
                                    <asp:TextBox ID="txtCantidadUnidades" runat="server" CssClass="form-control form-control-custom" placeholder="Ingrese cantidad" />
                                </div>
                                <div class="col-md-3 d-flex align-items-end">
                                    <asp:LinkButton ID="lbAgregarMedicamento" runat="server" CssClass="btn btn-custom btn-add" OnClick="lbAgregarMedicamento_Click">
                                        <i class="fa-solid fa-plus me-2"></i>Agregar Medicamento
                                    </asp:LinkButton>
                                </div>
                                <div class="col-md-6">
                                    <asp:Label ID="LabelIndicaciones" runat="server" Text="Indicaciones Médicas" CssClass="form-label form-label-custom" />
                                    <asp:TextBox ID="txtIndicaciones" runat="server" CssClass="form-control form-control-custom" placeholder="Escriba las indicaciones..." />
                                </div>
                            </div>

                            <!-- Grid de Medicamentos -->
                            <div class="medication-grid">
                                <asp:GridView ID="gvLineasMedicamento" runat="server"
                                    AllowPaging="true" PageSize="5" AutoGenerateColumns="false"
                                    CssClass="table table-hover align-middle"
                                    OnRowDataBound="gvLineasMedicamento_RowDataBound">
                                    <Columns>
                                        <asp:BoundField HeaderText="Medicamento" />
                                        <asp:BoundField HeaderText="Presentación" />
                                        <asp:BoundField HeaderText="Cantidad" />
                                        <asp:TemplateField HeaderText="Acciones">
                                            <ItemTemplate>

                                                <asp:LinkButton ID="btnTrash" runat="server" CssClass="btn btn-delete" OnClick="trashBouton" 
                                                    CommandArgument="<%# Container.DataItemIndex %>" ToolTip="Eliminar medicamento">
                                                    <i class="fa-solid fa-trash"></i>
                                                </asp:LinkButton>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                    </Columns>
                                </asp:GridView>
                            </div>
                        </div>
                    </div>

                    <hr class="section-divider" />

                    <!-- Observaciones médicas -->
                    <div class="section-card">
                        <div class="section-header observations">
                            <i class="fa-solid fa-stethoscope me-2"></i>Observaciones Médicas
                        </div>
                        <div class="section-body">
                            <div class="row g-4">
                                <div class="col-md-6">
                                    <asp:Label ID="lblDescripcion" runat="server" Text="Descripción del Caso" CssClass="form-label form-label-custom" />
                                    <asp:TextBox ID="TextDescripcion" runat="server" CssClass="form-control form-control-custom" 
                                        TextMode="MultiLine" Rows="3" placeholder="Describa el caso clínico..." />
                                </div>
                                <div class="col-md-6">
                                    <asp:Label ID="lblDiagnostico" runat="server" Text="Diagnóstico Médico" CssClass="form-label form-label-custom" />
                                    <asp:TextBox ID="TextDiag" runat="server" CssClass="form-control form-control-custom" 
                                        TextMode="MultiLine" Rows="3" placeholder="Ingrese el diagnóstico..." />
                                </div>
                                <div class="col-12">
                                    <asp:Label ID="LabelObs" runat="server" Text="Observaciones Adicionales" CssClass="form-label form-label-custom" />
                                    <asp:TextBox ID="TextObs" runat="server" CssClass="form-control form-control-custom" 
                                        TextMode="MultiLine" Rows="2" placeholder="Observaciones generales..." />
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Botones de acción -->
                    <div class="section-card">
                        <div class="action-buttons d-flex justify-content-between align-items-center">
                            <asp:LinkButton ID="btnRegresar" runat="server" CssClass="btn btn-custom btn-secondary-custom" OnClick="btnRegresar_Click">
                                <i class="fa-solid fa-arrow-left me-2"></i>Regresar
                            </asp:LinkButton>
                            <div class="text-center">
                                <span class="info-badge">
                                    <i class="fa-solid fa-info-circle me-1"></i>
                                    Verifique todos los datos antes de guardar
                                </span>
                            </div>
                            <asp:LinkButton ID="btnGuardar" runat="server" CssClass="btn btn-custom btn-primary-custom" OnClick="btnGuardar_Click">
                                <i class="fa-solid fa-save me-2"></i>Guardar Receta
                            </asp:LinkButton>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Modal de búsqueda de medicamentos -->
            <div class="modal fade" id="form-modal-medicamento">
                <div class="modal-dialog modal-xl modal-dialog-centered modal-dialog-scrollable shadow-lg rounded-3">
                    <div class="modal-content rounded-3">
                        <div class="modal-header bg-primary text-white">
                            <h5 class="modal-title"><i class="fa-solid fa-capsules pe-2"></i> Búsqueda de Medicamentos</h5>
                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <asp:UpdatePanel ID="upBusqMedicamento" runat="server" UpdateMode="Conditional">
                                <ContentTemplate>
                                    <div class="row pb-3 pt-3 align-items-center">
                                        <div class="col-auto">
                                            <asp:Label CssClass="form-label fw-semibold" runat="server" Text="Ingresar nombre del Medicamento:" />
                                        </div>
                                        <div class="col-sm-3">
                                            <asp:TextBox CssClass="form-control form-control-sm" ID="txtNombreMedicamentoModal" runat="server" />
                                        </div>
                                        <div class="col-sm-2">
                                            <asp:LinkButton ID="lbBusquedaMedicamentoModal" runat="server" CssClass="btn btn-info btn-sm rounded-pill shadow-sm" 
                                                Text="<i class='fa-solid fa-magnifying-glass pe-2'></i> Buscar" OnClick="lbBusquedaMedicamentoModal_Click"/>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <asp:GridView ID="gvMedicamentos" runat="server"
                                            PageSize="5" AllowPaging="true" AutoGenerateColumns="false"
                                            CssClass="table table-bordered table-hover table-striped align-middle shadow-sm"
                                            OnRowDataBound="gvMedicamentos_RowDataBound"
                                            OnPageIndexChanging="gvMedicamentos_PageIndexChanging">
                                            <HeaderStyle CssClass="table-info" />
                                            <Columns>
                                                <asp:BoundField HeaderText="Nro." />
                                                <asp:BoundField HeaderText="Nombre del medicamento" />
                                                <asp:BoundField HeaderText="Presentación del medicamento" />
                                                <asp:BoundField HeaderText="Stock" />
                                                <asp:TemplateField>
                                                    <ItemTemplate>
                                                        <asp:LinkButton runat="server"
                                                            Text="<i class='fa-solid fa-check ps-2'></i> Seleccionar"
                                                            CommandArgument='<%# Eval("IdMedicamento") %>'
                                                            CssClass="btn btn-outline-success btn-sm rounded-pill shadow-sm"
                                                            OnClick="lbSeleccionarMedicamento_Click" />
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                            </Columns>
                                        </asp:GridView>
                                    </div>
                                </ContentTemplate>
                            </asp:UpdatePanel>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Modal de error -->
            <div class="modal fade" id="errorModal" tabindex="-1" aria-labelledby="errorModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered rounded-3 shadow">
                    <div class="modal-content rounded-3">
                        <div class="modal-header bg-danger text-white rounded-top">
                            <h5 class="modal-title" id="errorModalLabel">
                                <i class="bi bi-exclamation-triangle-fill me-2"></i> Mensaje de Error
                            </h5>
                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <asp:Label ID="lblMensajeError" runat="server" Text="Mensaje de ejemplo..." CssClass="form-text text-danger fw-bold" />
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-outline-light btn-sm rounded-pill" data-bs-dismiss="modal">Cerrar</button>
                        </div>
                    </div>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
