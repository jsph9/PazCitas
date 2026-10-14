<%@ Page Title="" Language="C#" MasterPageFile="~/PazCitasPaciente.Master" AutoEventWireup="true" CodeBehind="ListarMedicosPaciente.aspx.cs" Inherits="PazCitasWA.ListarMedicosPaciente" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cph_Title" runat="server">
    Encuentra tu Médico
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="cph_Scripts" runat="server">
    <style>
        .hero-search-section {
            background-color: #e0f2fe;
            padding: 40px 20px;
            text-align: center;
            border-radius: 1rem;
            margin-bottom: 2rem;
        }
        .hero-search-section .main-title {
            font-size: 2.2rem;
            font-weight: 700;
            color: #1e3a8a;
        }
        .hero-search-section .highlight-title {
            color: #2563eb;
        }
        .search-bar-container {
            max-width: 600px;
            margin: 20px auto 0;
            position: relative;
        }
        .search-bar-container .form-control {
            border-radius: 30px;
            padding: 12px 20px 12px 45px;
            font-size: 1rem;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            border: 1px solid #ced4da;
            height: 48px;
        }
        .search-bar-container .search-icon {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #6c757d;
        }
        .doctors-grid-container {
            padding: 0;
        }
        .doctor-card {
            background-color: #fff;
            border: none;
            border-radius: 15px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            text-align: left;
            height: 100%;
            display: flex;
            flex-direction: column;
            transition: transform 0.2s ease-in-out, box-shadow 0.2s ease-in-out;
        }
        .doctor-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.12);
        }
        .doctor-card .card-img-top-wrapper {
            aspect-ratio: 532 / 572; /* proporcion real de genericDoctor.png: se ve completa */
            overflow: hidden;
            border-top-left-radius: 15px;
            border-top-right-radius: 15px;
            background-color: #f0f4f7;
        }
        .doctor-card .card-img-top {
            width: 100%;
            height: 100%;
            object-fit: contain;
        }
        .doctor-card .card-body {
            padding: 1rem 1.25rem;
            flex-grow: 1;
            display: flex;
            flex-direction: column;
        }
        .doctor-card .specialty-tag {
            font-size: 0.75rem;
            padding: 0.25rem 0.6rem;
            background-color: var(--color-principal-claro);
            color: var(--color-principal-hover);
            border-radius: 20px;
            display: inline-block;
            margin-bottom: 0.5rem;
            font-weight: 600;
        }
        .doctor-card .card-title {
            font-size: 1.1rem;
            font-weight: 600;
            color: var(--color-texto-primario);
            margin-bottom: 0.25rem;
        }
        .doctor-card .cmp-text {
            font-size: 0.85rem;
            color: #6c757d;
            margin-bottom: 1rem;
        }
        .doctor-card .btn-know-doctor {
            color: #007bff;
            font-weight: 500;
            text-decoration: none;
            margin-top: auto;
            align-self: flex-start;
        }
        .doctor-card .btn-know-doctor:hover { text-decoration: underline; }
        .doctor-card .btn-know-doctor .arrow-icon { margin-left: 5px; transition: transform 0.2s ease-in-out; }
        .doctor-card .btn-know-doctor:hover .arrow-icon { transform: translateX(3px); }

        /* Estilo para el mensaje de "No hay resultados" */
        .no-results-message {
            text-align: center;
            padding: 3rem;
            font-size: 1.2rem;
            color: #6c757d;
            background-color: #f8f9fa;
            border-radius: 1rem;
            border: 2px dashed #e2e8f0;
            margin-top: 2rem;
        }
        .error-message {
            display: block;
            text-align: center;
            margin-top: 1rem;
        }

    </style>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="cph_Contenido" runat="server">
    <div class="container mt-4 pb-5">

    <div class="hero-search-section">
        <h1 class="main-title">Encuentra a tu <span class="highlight-title">Especialista</span></h1>
        <div class="search-bar-container">
            <i class="fas fa-search search-icon"></i>
            <asp:TextBox ID="txtBusqueda" runat="server" 
                CssClass="form-control" 
                placeholder="Escribe el nombre, apellido o la especialidad"
                AutoPostBack="true" 
                OnTextChanged="txtBusqueda_TextChanged"></asp:TextBox>
        </div>
    </div>

    <div class="doctors-grid-container">
        
        <asp:UpdatePanel ID="updMedicos" runat="server">
            <ContentTemplate>
                <asp:Repeater ID="rptMedicos" runat="server">
                    <HeaderTemplate>
                        <div class="row g-4">
                    </HeaderTemplate>
                    <ItemTemplate>
                        <div class="col-12 col-md-6 col-lg-4 col-xl-3">
                            <div class="doctor-card">
                                <div class="card-img-top-wrapper">
                                    <img src="/images/genericDoctor.png" class="card-img-top" alt='<%# "Foto de " + Eval("nombre") %>' />
                                </div>
                                <div class="card-body">
                                    <div>
                                        <span class="specialty-tag"><%# Eval("especialidad.nombre") %></span>
                                        <h5 class="card-title"><%# "Dr. " + Eval("nombre") + " " + Eval("apellidoPaterno") %></h5>
                                        <p class="cmp-text">CMP: <%# Eval("codigoMedico") %></p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </ItemTemplate>
                    <FooterTemplate>
                        </div> <%-- Cierre de .row.g-4 --%>
                    </FooterTemplate>
                </asp:Repeater>
                
                <asp:Panel ID="pnlNoResultados" runat="server" Visible="false">
                    <div class="no-results-message">
                        <i class="far fa-sad-tear fa-2x mb-3"></i>
                        <p>No se encontraron médicos que coincidan con "<asp:Literal ID="litTerminoBusqueda" runat="server" />".</p>
                    </div>
                </asp:Panel>

            </ContentTemplate>
            <Triggers>
                <asp:AsyncPostBackTrigger ControlID="txtBusqueda" EventName="TextChanged" />
            </Triggers>
        </asp:UpdatePanel>

        <asp:Label ID="lblMensaje" runat="server" CssClass="text-danger error-message" Visible="false"></asp:Label>
    </div>

    </div> <%-- Cierre de .container --%>
</asp:Content>