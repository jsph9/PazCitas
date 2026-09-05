<%@ Page Title="" Language="C#" MasterPageFile="~/PazCitasAdmin.Master" AutoEventWireup="true" CodeBehind="RegistrarSede.aspx.cs" Inherits="PazCitasWA.RegistrarSede" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cph_Title" runat="server">
    Registrar Sede
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
            max-width: 1200px;
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
                width: 100px;
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
        }

            .info-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 15px 40px rgba(30, 60, 114, 0.15);
            }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: scale(0.95);
            }

            to {
                opacity: 1;
                transform: scale(1);
            }
        }

        .card-header-patient {
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            color: #fff;
            padding: 1.5rem;
            border: none;
            font-weight: 600;
            font-size: 1.2rem;
            text-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        .card-header-appointment {
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

        .form-group-modern {
            margin-bottom: 1.5rem;
            position: relative;
        }

        .form-label-modern {
            font-weight: 600;
            color: #1e3c72;
            margin-bottom: 0.5rem;
            font-size: 0.9rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .form-control-modern {
            border: 2px solid #e2e8f0;
            border-radius: 10px;
            padding: 0.75rem 1rem;
            font-size: 1rem;
            background: #ffffff;
            transition: all 0.3s ease;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.02);
            color: #2d3748;
        }

            .form-control-modern:focus {
                border-color: #2a5298;
                box-shadow: 0 0 0 3px rgba(42, 82, 152, 0.1);
                outline: none;
            }

            .form-control-modern:disabled {
                background-color: #f7fafc;
                border-color: #cbd5e0;
                color: #4a5568;
            }

        .icon-large {
            font-size: 1.5rem;
            margin-right: 0.75rem;
            vertical-align: middle;
        }

        .btn-modern {
            border-radius: 12px;
            padding: 0.75rem 2rem;
            font-weight: 600;
            font-size: 1rem;
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

        .btn-primary-modern {
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
            color: white;
            box-shadow: 0 4px 15px rgba(30, 60, 114, 0.3);
        }

            .btn-primary-modern:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 25px rgba(30, 60, 114, 0.4);
                color: white;
                text-decoration: none;
            }

        .btn-secondary-modern {
            background: linear-gradient(135deg, #74b9ff 0%, #0984e3 100%);
            color: white;
            box-shadow: 0 4px 15px rgba(116, 185, 255, 0.3);
        }

            .btn-secondary-modern:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 25px rgba(116, 185, 255, 0.4);
                color: white;
                text-decoration: none;
            }

        .btn-outline-modern {
            background: transparent;
            border: 2px solid #2a5298;
            color: #2a5298;
            box-shadow: 0 4px 15px rgba(42, 82, 152, 0.1);
        }

            .btn-outline-modern:hover {
                background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
                color: white;
                transform: translateY(-2px);
                box-shadow: 0 8px 25px rgba(30, 60, 114, 0.3);
                text-decoration: none;
            }

        .button-container {
            background: #ffffff;
            border-radius: 15px;
            padding: 2rem;
            box-shadow: 0 10px 30px rgba(30, 60, 114, 0.08);
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 1rem;
        }

        .download-section {
            background: linear-gradient(135deg, #74b9ff 0%, #0984e3 100%);
            border-radius: 15px;
            padding: 1.5rem;
            margin-bottom: 2rem;
            text-align: center;
            box-shadow: 0 10px 30px rgba(116, 185, 255, 0.2);
            color: white;
        }

            .download-section h4 {
                color: white;
                text-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                margin-bottom: 1rem;
            }

            .download-section p {
                color: rgba(255, 255, 255, 0.9);
                margin-bottom: 1.5rem;
            }

        .status-badge {
            display: inline-block;
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-weight: 600;
            font-size: 0.9rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .status-active {
            background: linear-gradient(135deg, #74b9ff 0%, #0984e3 100%);
            color: white;
        }

        .status-pending {
            background: linear-gradient(135deg, #a29bfe 0%, #6c5ce7 100%);
            color: white;
        }

        .status-completed {
            background: linear-gradient(135deg, #00b894 0%, #00cec9 100%);
            color: white;
        }

        /* Efectos adicionales para mejorar la experiencia */
        .form-control-modern:hover {
            border-color: #74b9ff;
            box-shadow: 0 4px 8px rgba(116, 185, 255, 0.1);
        }

        .info-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 3px;
            background: linear-gradient(90deg, #1e3c72, #2a5298, #74b9ff);
            border-radius: 15px 15px 0 0;
        }

        .info-card {
            position: relative;
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

            .button-container {
                flex-direction: column;
                text-align: center;
            }

            .btn-modern {
                width: 100%;
                margin-bottom: 0.5rem;
            }

            .card-body-enhanced {
                padding: 1.5rem;
            }

            .form-group-modern {
                margin-bottom: 1rem;
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
        }

        /* Animaciones adicionales */
        @keyframes pulse {
            0% {
                transform: scale(1);
            }

            50% {
                transform: scale(1.05);
            }

            100% {
                transform: scale(1);
            }
        }

        .btn-modern:active {
            animation: pulse 0.2s ease-in-out;
        }

        /* Mejoras de accesibilidad */
        .btn-modern:focus {
            outline: 3px solid rgba(42, 82, 152, 0.3);
            outline-offset: 2px;
        }

        .form-control-modern:focus {
            outline: none;
        }

        /* Efectos de carga */
        .content-wrapper {
            animation-delay: 0.1s;
        }

        .info-card:nth-child(2) {
            animation-delay: 0.2s;
        }

        .info-card:nth-child(3) {
            animation-delay: 0.3s;
        }

        .download-section {
            animation: fadeIn 0.6s ease-out;
            animation-delay: 0.4s;
            animation-fill-mode: both;
        }

        .button-container {
            animation: fadeIn 0.6s ease-out;
            animation-delay: 0.5s;
            animation-fill-mode: both;
        }
    </style>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="cph_Contenido" runat="server">
    <div class="container">
        <div class="card">
            <div class="card-header text-center">
                <h4 class="fw-bold m-0">
                    <asp:Label ID="lblTitulo" runat="server" Text="Label"></asp:Label>
                </h4>
            </div>
            <div class="card-body">
                <div class="mb-3 row align-items-center">
                    <asp:Label ID="lblIDSede" CssClass="col-form-label col-sm-auto pe-sm-2 fw-bold" runat="server" Text="ID Sede:"></asp:Label>
                    <div class="col-sm-2">
                        <asp:TextBox ID="txtIDSede" CssClass="form-control" Enabled="false" runat="server"></asp:TextBox>
                    </div>
                </div>
                <div class="mb-3 row align-items-center">
                    <asp:Label ID="lblNombre" CssClass="col-form-label col-sm-auto pe-sm-2 fw-bold" runat="server" Text="Nombre:"></asp:Label>
                    <div class="col-sm-6">
                        <asp:TextBox ID="txtNombre" CssClass="form-control" runat="server"></asp:TextBox>
                    </div>
                </div>
                <div class="mb-3 row align-items-start">
                    <asp:Label ID="lblDireccion" CssClass="col-form-label col-sm-auto pe-sm-2 fw-bold " runat="server" Text="Dirección:"></asp:Label>
                    <div class="col-sm-8">
                        <asp:TextBox ID="txtDireccion" CssClass="form-control" runat="server"></asp:TextBox>
                    </div>
                </div>


            </div>
            <asp:Panel ID="pnlReporteSede" runat="server">
                <!-- Sección de Descarga -->
                <div class="download-section">
                    <h4 class="mb-3">
                        <i class="fa-solid fa-file-medical icon-large"></i>
                        Reporte de Citas
                    </h4>
                    <p class="mb-3">Descarga el reporte de especialidades completo del paciente en formato PDF</p>
                    <asp:LinkButton ID="btnReporteSede" runat="server" CssClass="btn btn-outline-modern btn-modern" OnClick="btnReporteSede_Click">
                        <i class="fa-solid fa-download pe-2"></i>Descargar Reporte Sede
                    </asp:LinkButton>
                </div>
                </asp:Panel>
                <div class="card-footer clearfix">
                    <asp:LinkButton ID="btnRegresar" runat="server" Text="<i class='fa-solid fa-rotate-left'></i> Regresar" CssClass="float-start btn btn-secondary" OnClick="btnRegresar_Click" />
                    <asp:LinkButton ID="btnGuardar" CssClass="float-end btn btn-success" runat="server" Text="<i class='fa-solid fa-floppy-disk pe-2'></i> Guardar" OnClick="btnGuardar_Click" />
                </div>
            
        </div>
    </div>
</asp:Content>
