<%@ Page Title="" Language="C#" MasterPageFile="~/PazCitasMedico.Master" AutoEventWireup="true" CodeBehind="VerCitaMedico.aspx.cs" Inherits="PazCitasWA.VerCitaMedico" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cph_Title" runat="server">
    Ver Cita Médica
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
            from { opacity: 0; transform: scale(0.95); }
            to { opacity: 1; transform: scale(1); }
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
            0% { transform: scale(1); }
            50% { transform: scale(1.05); }
            100% { transform: scale(1); }
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
    <div class="medical-container">
        <div class="content-wrapper">
            <h1 class="page-title">
                <i class="fa-solid fa-stethoscope icon-large"></i>
                Información de la Cita Médica
            </h1>

            <!-- Información del Paciente -->
            <div class="info-card">
                <div class="card-header-patient">
                    <i class="fa-solid fa-user-injured icon-large"></i>
                    Datos del Paciente
                </div>
                <div class="card-body-enhanced">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group-modern">
                                <asp:Label ID="lblDNICliente" runat="server" Text="DNI del Paciente" CssClass="form-label-modern" />
                                <asp:TextBox ID="txtDNIPaciente" runat="server" Enabled="false" CssClass="form-control-modern" />
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group-modern">
                                <asp:Label ID="LabelNombre" runat="server" Text="Nombre Completo" CssClass="form-label-modern" />
                                <asp:TextBox ID="TextNombre" runat="server" Enabled="false" CssClass="form-control-modern" />
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group-modern">
                                <asp:Label ID="LablEmail" runat="server" Text="Correo Electrónico" CssClass="form-label-modern" />
                                <asp:TextBox ID="txtEmail" runat="server" Enabled="false" CssClass="form-control-modern" />
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group-modern">
                                <asp:Label runat="server" Text="Teléfono" CssClass="form-label-modern" />
                                <asp:TextBox runat="server" Enabled="false" CssClass="form-control-modern" placeholder="No especificado" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Información de la Cita -->
            <div class="info-card">
                <div class="card-header-appointment">
                    <i class="fa-solid fa-calendar-check icon-large"></i>
                    Detalles de la Cita
                </div>
                <div class="card-body-enhanced">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group-modern">
                                <asp:Label ID="Label1" runat="server" Text="Número de Cita" CssClass="form-label-modern" />
                                <asp:TextBox ID="TxtNume" runat="server" Enabled="false" CssClass="form-control-modern" />
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group-modern">
                                <asp:Label ID="Label2" runat="server" Text="Fecha y Hora" CssClass="form-label-modern" />
                                <asp:TextBox ID="TxtFecha" runat="server" Enabled="false" CssClass="form-control-modern" />
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group-modern">
                                <asp:Label ID="Label3" runat="server" Text="Estado de la Cita" CssClass="form-label-modern" />
                                <asp:TextBox ID="TextEstado" runat="server" Enabled="false" CssClass="form-control-modern" />
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group-modern">
                                <asp:Label runat="server" Text="Especialidad" CssClass="form-label-modern" />
                                <asp:TextBox runat="server" Enabled="false" CssClass="form-control-modern" placeholder="Medicina General" />
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-12">
                            <div class="form-group-modern">
                                <asp:Label ID="Label4" runat="server" Text="Motivo de Consulta" CssClass="form-label-modern" />
                                <asp:TextBox ID="TextMotivo" runat="server" Enabled="false" CssClass="form-control-modern" TextMode="MultiLine" Rows="3" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            

            <!-- Botones de Navegación -->
            <div class="button-container">
                <asp:LinkButton ID="btnRegresar" runat="server" CssClass="btn btn-secondary-modern btn-modern" OnClick="btnRegresar_Click">
                    <i class="fa-solid fa-arrow-left pe-2"></i>Regresar
                </asp:LinkButton>
                
                <div class="d-flex gap-2">
                    <asp:LinkButton runat="server" CssClass="btn btn-outline-modern btn-modern">
                        <i class="fa-solid fa-print pe-2"></i>Imprimir
                    </asp:LinkButton>
                    
                    <asp:LinkButton ID="btnContinuar" runat="server" CssClass="btn btn-primary-modern btn-modern" OnClick="btnContinuar_Click">
                        Continuar<i class="fa-solid fa-arrow-right ps-2"></i>
                    </asp:LinkButton>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
