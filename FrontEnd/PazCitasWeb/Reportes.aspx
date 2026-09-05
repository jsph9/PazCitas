<%@ Page Title="" Language="C#" MasterPageFile="~/PazCitasAdmin.Master" AutoEventWireup="true" CodeBehind="Reportes.aspx.cs" Inherits="PazCitasWA.Reportes" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cph_Title" runat="server">
    Reportes
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph_Scripts" runat="server">
    <style>
        .construction-message {
            text-align: center;
            font-size: 30px;
            color: #333;
            margin-top: 150px;
            font-family: Arial, sans-serif;
        }

            .construction-message h1 {
                font-size: 50px;
                color: #FF6347; /* Tomato color */
            }

            .construction-message p {
                font-size: 20px;
                color: #888;
            }

        .construction-icon {
            font-size: 100px;
            color: #FF6347;
        }
    </style>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="cph_Contenido" runat="server">

    <%-- Estilos para dar una apariencia profesional a la tarjeta del reporte --%>
    <style>
        .report-card {
            border: 1px solid #e9ecef;
            border-radius: 12px;
            padding: 2rem;
            text-align: center;
            background-color: #fff;
            transition: all 0.3s ease;
            box-shadow: 0 4px S10px rgba(0,0,0,0.04);
            display: flex;
            flex-direction: column;
            height: 100%;
        }

            .report-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 8px 25px rgba(0,0,0,0.08);
            }

            .report-card .icon {
                font-size: 48px;
                color: #34a853; /* Color verde del admin */
                margin-bottom: 1rem;
            }

            .report-card h3 {
                font-weight: 600;
                margin-bottom: 0.75rem;
            }

            .report-card p {
                color: #6c757d;
                flex-grow: 1; /* Esto empuja el botón hacia abajo para un diseño equilibrado */
            }

            .report-card .btn {
                font-weight: bold;
                padding: 10px 25px;
                border-radius: 8px;
                margin-top: 1.5rem; /* Espacio arriba del botón */
            }
    </style>

    <%-- Título de la página --%>
    <div class="mb-4">
        <h1>Centro de Reportes</h1>
        <p class="text-muted">Seleccione un reporte para generar y visualizar.</p>
    </div>

    <%-- Contenedor para las tarjetas de reporte --%>
    <div class="row">
        <div class="col-md-6 col-lg-4">
            <div class="report-card">
                <div class="icon"><i class="fas fa-file-invoice-dollar"></i></div>
                <h3>Reporte General de Citas</h3>
                <p>Genera un informe completo con estadísticas sobre especialidades, médicos y estados de las citas programadas.</p>

                <asp:LinkButton ID="btnGenerarReporte" runat="server" CssClass="btn btn-success" OnClick="btnGenerarReporte_Click">
                    <i class="fas fa-file-pdf me-2"></i>Generar Reporte
                </asp:LinkButton>

            </div>
        </div>

    </div>

</asp:Content>
