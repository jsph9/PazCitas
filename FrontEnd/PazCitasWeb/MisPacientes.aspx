<%@ Page Title="" Language="C#" MasterPageFile="~/PazCitasMedico.Master" AutoEventWireup="true" CodeBehind="MisPacientes.aspx.cs" Inherits="PazCitasWA.MisPacientes" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cph_Title" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="cph_Scripts" runat="server">
    <script src="Scripts/PazcitasS/RegistrarLineaMedicamento.js"></script>
    <style>
        /* Estilos personalizados para Mis Pacientes - Tema Azul */
        .patients-container {
            background: linear-gradient(135deg, #f0f8ff 0%, #e6f3ff 100%);
            min-height: 100vh;
            padding: 2rem 0;
        }

        .patients-header {
            background: linear-gradient(135deg, #0d6efd 0%, #0b5ed7 100%);
            color: white;
            padding: 2rem;
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(13, 110, 253, 0.3);
            margin-bottom: 2rem;
            text-align: center;
        }

        .patients-header h2 {
            margin: 0;
            font-weight: 600;
            text-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .patients-header .fa-users {
            background: rgba(255,255,255,0.2);
            padding: 0.5rem;
            border-radius: 50%;
            margin-right: 1rem;
        }

        .search-card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
            margin-bottom: 2rem;
            overflow: hidden;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .search-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 12px 35px rgba(0,0,0,0.15);
        }

        .search-header {
            background: linear-gradient(135deg, #0dcaf0 0%, #17a2b8 100%);
            color: white;
            padding: 1.25rem 1.5rem;
            font-weight: 600;
            font-size: 1.1rem;
            border: none;
            margin: 0;
        }

        .search-body {
            padding: 2rem;
            background: white;
        }

        .patient-info-card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
            margin-bottom: 2rem;
            overflow: hidden;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .patient-info-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 12px 35px rgba(0,0,0,0.15);
        }

        .patient-info-header {
            background: linear-gradient(135deg, #6610f2 0%, #0d6efd 100%);
            color: white;
            padding: 1.25rem 1.5rem;
            font-weight: 600;
            font-size: 1.1rem;
            border: none;
            margin: 0;
        }

        .patient-info-body {
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

        .btn-search-custom {
            background: linear-gradient(135deg, #0d6efd 0%, #0b5ed7 100%);
            color: white;
        }

        .btn-back-custom {
            background: linear-gradient(135deg, #17a2b8 0%, #138496 100%);
            color: white;
        }

        .action-buttons {
            background: linear-gradient(135deg, #f0f8ff 0%, #e6f3ff 100%);
            padding: 1.5rem 2rem;
            border-radius: 0 0 15px 15px;
            border-top: 1px solid #b6d7ff;
        }

        .notes-section {
            background: white;
            border-radius: 15px;
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
            overflow: hidden;
            margin-top: 2rem;
        }

        .notes-header {
            background: linear-gradient(135deg, #0d6efd 0%, #6610f2 100%);
            color: white;
            padding: 1.5rem 2rem;
            margin: 0;
        }

        .notes-header h3 {
            margin: 0;
            font-weight: 600;
            font-size: 1.2rem;
        }

        .notes-grid {
            padding: 2rem;
        }

        .notes-grid .table {
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            margin: 0;
        }

        .notes-grid .table thead th {
            background: linear-gradient(135deg, #0dcaf0 0%, #17a2b8 100%);
            color: white;
            border: none;
            padding: 1rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            font-size: 0.85rem;
        }

        .notes-grid .table tbody td {
            padding: 1rem;
            vertical-align: middle;
            border-color: #b6d7ff;
        }

        .notes-grid .table tbody tr:hover {
            background-color: #f0f8ff;
        }

        .btn-detail {
            background: linear-gradient(135deg, #0d6efd 0%, #0b5ed7 100%);
            color: white;
            border: none;
            border-radius: 20px;
            padding: 0.4rem 1rem;
            font-size: 0.85rem;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .btn-detail:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(13, 110, 253, 0.3);
            color: white;
        }

        .search-icon {
            margin-right: 0.5rem;
        }

        .patient-icon {
            margin-right: 0.5rem;
        }

        .notes-icon {
            margin-right: 0.5rem;
        }

        .empty-state {
            text-align: center;
            padding: 3rem 2rem;
            color: #6c757d;
        }

        .empty-state i {
            font-size: 3rem;
            color: #b6d7ff;
            margin-bottom: 1rem;
        }

        .section-divider {
            height: 3px;
            background: linear-gradient(90deg, #0d6efd, #0dcaf0, #17a2b8, #6610f2);
            border: none;
            border-radius: 2px;
            margin: 2rem 0;
        }

        @media (max-width: 768px) {
            .patients-container {
                padding: 1rem 0;
            }
            
            .patients-header {
                padding: 1.5rem;
                border-radius: 10px;
            }
            
            .search-body, .patient-info-body, .notes-grid {
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
            <div class="patients-container">
                <div class="container">
                    <!-- Header Principal -->
                    <div class="patients-header">
                        <h2><i class="fa-solid fa-users"></i>Gestión de Pacientes</h2>
                        <p class="mb-0 mt-2 opacity-75">Consulta y administra la información de tus pacientes</p>
                    </div>

                    <!-- Sección de Búsqueda -->
                    <div class="search-card">
                        <div class="search-header">
                            <i class="fa-solid fa-magnifying-glass search-icon"></i>Búsqueda de Paciente
                        </div>
                        <div class="search-body">
                            <div class="row align-items-center g-3">
                                <div class="col-auto">
                                    <asp:Label ID="lblDni" runat="server" Text="DNI del Paciente:" CssClass="form-label form-label-custom" />
                                </div>
                                <div class="col-md-6">
                                    <asp:TextBox ID="txtDni" runat="server" CssClass="form-control form-control-custom" 
                                        placeholder="Ingrese el número de DNI..." />
                                </div>
                            </div>
                        </div>
                        <div class="action-buttons d-flex justify-content-between">
                            <asp:LinkButton ID="btnRegresar" runat="server" CssClass="btn btn-custom btn-back-custom" OnClick="btnRegresar_Click">
                                <i class="fa-solid fa-arrow-left me-2"></i>Regresar
                            </asp:LinkButton>
                            <asp:LinkButton ID="btnBuscar" runat="server" CssClass="btn btn-custom btn-search-custom" OnClick="btnBuscar_Click">
                                <i class="fa-solid fa-search me-2"></i>Buscar Paciente
                            </asp:LinkButton>
                        </div>
                    </div>

                    <hr class="section-divider" />

                    <!-- Información del Paciente -->
                    <div class="patient-info-card">
                        <div class="patient-info-header">
                            <i class="fa-solid fa-user-injured patient-icon"></i>Información del Paciente
                        </div>
                        <div class="patient-info-body">
                            <div class="row g-4">
                                <div class="col-md-6">
                                    <div class="row g-3">
                                        <div class="col-12">
                                            <asp:Label ID="LabelId" runat="server" Text="ID del Paciente" CssClass="form-label form-label-custom" />
                                            <asp:TextBox ID="TextID" runat="server" Enabled="false" CssClass="form-control form-control-custom" />
                                        </div>
                                        <div class="col-12">
                                            <asp:Label ID="LabelNombre" runat="server" Text="Nombre Completo" CssClass="form-label form-label-custom" />
                                            <asp:TextBox ID="TextNombre" runat="server" Enabled="false" CssClass="form-control form-control-custom" />
                                        </div>
                                        <div class="col-12">
                                            <asp:Label ID="lblApellido" runat="server" Text="Apellidos" CssClass="form-label form-label-custom" />
                                            <asp:TextBox ID="textApellido" runat="server" Enabled="false" CssClass="form-control form-control-custom" />
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="row g-3">
                                        <div class="col-12">
                                            <asp:Label ID="Labeltelefono" runat="server" Text="Teléfono de Contacto" CssClass="form-label form-label-custom" />
                                            <asp:TextBox ID="TextTelefono" runat="server" Enabled="false" CssClass="form-control form-control-custom" />
                                        </div>
                                        <div class="col-12">
                                            <asp:Label ID="Labelemail" runat="server" Text="Correo Electrónico" CssClass="form-label form-label-custom" />
                                            <asp:TextBox ID="Textemail" runat="server" Enabled="false" CssClass="form-control form-control-custom" />
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Sección de Notas Médicas -->
                    <div class="notes-section">
                        <div class="notes-header">
                            <h3><i class="fa-solid fa-file-medical notes-icon"></i>Historial de Notas Médicas</h3>
                        </div>
                        <div class="notes-grid">
                            <asp:GridView ID="dgvNotas" runat="server" AutoGenerateColumns="false"
                                OnRowDataBound="dgvNotas_RowDataBound" AllowPaging="true"
                                OnPageIndexChanging="dgvNotas_PageIndexChanging" PageSize="5"
                                CssClass="table table-hover align-middle">
                                <Columns>
                                    <asp:BoundField HeaderText="Descripción del Caso" DataField="descripcion" ItemStyle-CssClass="align-middle" />
                                    <asp:BoundField HeaderText="Diagnóstico Médico" DataField="diagnostico" ItemStyle-CssClass="align-middle" />
                                    <asp:BoundField HeaderText="Observaciones" DataField="observaciones" ItemStyle-CssClass="align-middle" />
                                    <asp:TemplateField HeaderText="Acciones">
                                        <ItemTemplate>
                                            <asp:LinkButton ID="btnVerDetalle" runat="server"
                                                Text="<i class='fa-solid fa-eye me-1'></i>Ver Detalle"
                                                CssClass="btn btn-detail"
                                                CommandName="VerDetalle" 
                                                CommandArgument='<%# Eval("IdNota") %>' 
                                                OnClick="btnVerDetalle_Click"/>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                                <EmptyDataTemplate>
                                    <div class="empty-state">
                                        <i class="fa-solid fa-clipboard-list"></i>
                                        <h5>No hay notas médicas registradas</h5>
                                        <p class="text-muted">Aún no se han registrado notas médicas para este paciente.</p>
                                    </div>
                                </EmptyDataTemplate>
                            </asp:GridView>
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
