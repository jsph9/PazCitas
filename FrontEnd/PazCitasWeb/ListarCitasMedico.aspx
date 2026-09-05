<%@ Page Title="" Language="C#" MasterPageFile="~/PazCitasMedico.Master" AutoEventWireup="true" CodeBehind="ListarCitasMedico.aspx.cs" Inherits="PazCitasWA.ListarCitasMedico" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cph_Title" runat="server">
    Listar Citas Médicas
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="cph_Scripts" runat="server">
    <style>
        .medical-container {
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
            min-height: 100vh;
            padding: 2rem 0;
        }
        
        .content-wrapper {
            background: rgba(255, 255, 255, 0.98);
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(30, 60, 114, 0.2);
            backdrop-filter: blur(10px);
            padding: 2rem;
            margin: 0 auto;
            max-width: 1400px;
            animation: slideUp 0.6s ease-out;
            border: 1px solid rgba(42, 82, 152, 0.1);
        }
        
        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .page-title {
            background: linear-gradient(45deg, #1e3c72, #2a5298);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            font-size: 2.5rem;
            font-weight: 700;
            text-align: center;
            margin-bottom: 2rem;
            position: relative;
        }
        
        .page-title::after {
            content: '';
            position: absolute;
            bottom: -10px;
            left: 50%;
            transform: translateX(-50%);
            width: 120px;
            height: 4px;
            background: linear-gradient(45deg, #1e3c72, #2a5298);
            border-radius: 2px;
        }
        
        .info-card {
            background: #ffffff;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(30, 60, 114, 0.08);
            border: none;
            margin-bottom: 2rem;
            overflow: hidden;
            transition: all 0.3s ease;
            animation: fadeIn 0.6s ease-out;
            position: relative;
        }
        
        .info-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #1e3c72, #2a5298, #74b9ff);
            border-radius: 15px 15px 0 0;
        }
        
        .info-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 15px 40px rgba(30, 60, 114, 0.12);
        }
        
        @keyframes fadeIn {
            from { opacity: 0; transform: scale(0.98); }
            to { opacity: 1; transform: scale(1); }
        }
        
        .card-header-appointments {
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
            color: #fff;
            padding: 1.5rem;
            border: none;
            font-weight: 600;
            font-size: 1.2rem;
            text-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }
        
        .card-body-enhanced {
            padding: 2rem;
            background: #fafbfc;
        }
        
        .icon-large {
            font-size: 1.5rem;
            margin-right: 0.75rem;
            vertical-align: middle;
        }
        
        .table-modern {
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 8px 25px rgba(30, 60, 114, 0.1);
            border: none;
            background: white;
            margin-bottom: 0;
        }
        
        .table-modern thead th {
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
            color: white;
            border: none;
            padding: 1rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            font-size: 0.9rem;
            text-align: center;
        }
        
        .table-modern tbody td {
            padding: 1rem;
            border-color: #e2e8f0;
            vertical-align: middle;
            text-align: center;
        }
        
        .table-modern tbody tr {
            transition: all 0.3s ease;
        }
        
        .table-modern tbody tr:hover {
            background-color: rgba(116, 185, 255, 0.05);
            transform: scale(1.01);
            box-shadow: 0 4px 12px rgba(30, 60, 114, 0.1);
        }
        
        .table-container {
            background: white;
            border-radius: 15px;
            padding: 1.5rem;
            box-shadow: 0 8px 25px rgba(30, 60, 114, 0.08);
            margin-bottom: 2rem;
        }
        
        .btn-modern {
            border-radius: 12px;
            padding: 0.5rem 1rem;
            font-weight: 600;
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            transition: all 0.3s ease;
            border: none;
            position: relative;
            overflow: hidden;
            text-decoration: none;
            display: inline-block;
        }
        
        .btn-modern::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
            transition: left 0.5s;
        }
        
        .btn-modern:hover::before {
            left: 100%;
        }
        
        .btn-outline-primary {
            background: transparent;
            border: 2px solid #2a5298 !important;
            color: #2a5298 !important;
            box-shadow: 0 4px 15px rgba(42, 82, 152, 0.1);
        }
        
        .btn-outline-primary:hover {
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%) !important;
            color: white !important;
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(30, 60, 114, 0.3);
            text-decoration: none;
            border-color: #2a5298 !important;
        }
        
        .empty-state {
            text-align: center;
            padding: 4rem 2rem;
            color: #74b9ff;
        }
        
        .empty-state i {
            font-size: 5rem;
            margin-bottom: 1.5rem;
            opacity: 0.5;
        }
        
        .empty-state h4 {
            color: #1e3c72;
            margin-bottom: 1rem;
        }
        
        .empty-state p {
            color: #74b9ff;
            font-size: 1.1rem;
        }
        
        .message-container {
            background: linear-gradient(135deg, #fd79a8 0%, #e84393 100%);
            border-radius: 12px;
            padding: 1rem;
            margin-top: 1rem;
            text-align: center;
            color: white;
            font-weight: 600;
            box-shadow: 0 4px 15px rgba(253, 121, 168, 0.3);
        }
        
        .message-container i {
            margin-right: 0.5rem;
            font-size: 1.2rem;
        }
        
        /* Estilos para la paginación */
        .table-modern .pagination {
            justify-content: center;
            margin-top: 1rem;
        }
        
        .table-modern .pagination a,
        .table-modern .pagination span {
            background: white;
            border: 2px solid #74b9ff;
            color: #74b9ff;
            padding: 0.5rem 0.75rem;
            margin: 0 0.25rem;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .table-modern .pagination a:hover {
            background: #74b9ff;
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(116, 185, 255, 0.3);
        }
        
        .table-modern .pagination span {
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
            color: white;
            border-color: #2a5298;
        }
        
        /* Responsive Design */
        @media (max-width: 768px) {
            .content-wrapper {
                margin: 1rem;
                padding: 1.5rem;
            }
            
            .page-title {
                font-size: 2rem;
            }
            
            .card-body-enhanced {
                padding: 1.5rem;
            }
            
            .table-modern {
                font-size: 0.85rem;
            }
            
            .table-modern thead th,
            .table-modern tbody td {
                padding: 0.75rem 0.5rem;
            }
        }
        
        @media (max-width: 576px) {
            .medical-container {
                padding: 1rem 0;
            }
            
            .content-wrapper {
                margin: 0.5rem;
                padding: 1rem;
            }
            
            .page-title {
                font-size: 1.8rem;
            }
            
            .icon-large {
                font-size: 1.2rem;
            }
            
            .table-modern {
                font-size: 0.8rem;
            }
        }
        
        /* Animaciones adicionales */
        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.05); }
            100% { transform: scale(1); }
        }
        
        .btn-modern:active {
            animation: pulse 0.2s ease-in-out;
        }
        
        /* Efectos de carga */
        .table-container {
            animation: fadeIn 0.6s ease-out;
            animation-delay: 0.2s;
            animation-fill-mode: both;
        }
    </style>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="cph_Contenido" runat="server">
    <div class="medical-container">
        <div class="content-wrapper">
            <h1 class="page-title">
                <i class="fa-solid fa-calendar-days icon-large"></i>
                Lista de Citas Médicas
            </h1>
            <div class="row mb-3">
                <div class="col-md-4">
                    <asp:DropDownList ID="ddlEstadoCita" runat="server" CssClass="form-control">
                        <asp:ListItem Text="-- Todos --" Value=""></asp:ListItem>
                        <asp:ListItem Text="PROGRAMADA" Value="PROGRAMADA"></asp:ListItem>
                        <asp:ListItem Text="CANCELADA" Value="CANCELADA"></asp:ListItem>
                        <asp:ListItem Text="ATENDIDA" Value="ATENDIDA"></asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="col-md-2">
                    <asp:Button ID="btnFiltrar" runat="server" Text="Filtrar" CssClass="btn btn-outline-primary btn-modern w-100" OnClick="btnFiltrar_Click" />
                </div>
            </div>
            <div class="info-card">
                <div class="card-header-appointments">
                    <i class="fa-solid fa-list-check icon-large"></i>
                    Citas Programadas
                </div>


                <div class="card-body-enhanced">
                    <div class="container">
                        <div class="container row">
                            <div class="table-responsive">
                                <div class="table-container">
                                    <asp:GridView ID="gvCitasMed" runat="server" 
                                        CssClass="table table-hover table-responsive table-striped table-modern"
                                        AutoGenerateColumns="false" 
                                        PageSize="4" 
                                        AllowPaging="true"
                                        OnPageIndexChanging="gvCitasMed_PageIndexChanging" 
                                        OnRowDataBound="gvCitasMed_RowDataBound">
                                        <Columns>
                                            <asp:BoundField HeaderText="Nombre Paciente" />
                                            <asp:BoundField HeaderText="DNI" />
                                            <asp:BoundField HeaderText="Fecha Cita" />
                                            <asp:BoundField HeaderText="Hora Inicio" />
                                            <asp:BoundField HeaderText="Estado Cita" />
                                            <asp:BoundField HeaderText="Estado Paciente" />
                                            <asp:TemplateField HeaderText="Acciones">
                                                <ItemTemplate>
                                                    <asp:LinkButton
                                                        ID ="BtonSeleccionar"
                                                        runat="server"
                                                        Text="Ver detalle"
                                                        OnClick="BtonSeleccionar_Click"
                                                        CommandArgument='<%# Eval("IdCita") %>'
                                                        CssClass="btn btn-outline-primary btn-sm btn-modern" />
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                        </Columns>
                                    </asp:GridView>
                                </div>
                            </div>
                            <div class="form-group mt-2">
                                <asp:Label ID="lblMensaje" runat="server" CssClass="text-danger text-center d-block" EnableViewState="false"></asp:Label>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
