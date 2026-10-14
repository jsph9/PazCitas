<%@ Page Title="" Language="C#" MasterPageFile="~/PazCitasPaciente.Master" AutoEventWireup="true" CodeBehind="ListarCitasPaciente.aspx.cs" Inherits="PazCitasWA.ListarCitasPaciente" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cph_Title" runat="server">
    Mis Citas
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph_Scripts" runat="server">
    <style>
        .page-main-title {
            font-size: 2.2rem;
            font-weight: 700;
            color: #2d3748; /* Dark gray-blue */
            margin-bottom: 1.5rem;
        }

        .appointments-container {
            font-family: 'Inter', sans-serif; /* Un buen sans-serif moderno, asegúrate de tenerlo o usa 'Arial', sans-serif */
        }

        .appointments-header-row {
            display: flex;
            padding: 0.75rem 1.5rem;
            margin-bottom: 0.75rem;
            color: #718096; /* Medium gray */
            font-size: 0.875rem;
            font-weight: 500;
            border-bottom: 1px solid #e2e8f0; /* Light gray border */
        }

        .header-column {
            text-align: left;
        }
            .header-column.col-medico { flex: 0 0 30%; max-width: 30%; }
            .header-column.col-especialidad { flex: 0 0 16%; max-width: 16%; }
            .header-column.col-estado { flex: 0 0 15%; max-width: 15%; }
            .header-column.col-fecha { flex: 0 0 14%; max-width: 14%; }
            .header-column.col-hora { flex: 0 0 12%; max-width: 12%; }
            .header-column.col-acciones { flex: 0 0 13%; max-width: 13%; text-align:center; }


        .appointment-row {
            display: flex;
            align-items: center;
            background-color: #f7fafc; /* Very light gray, similar to image */
            border-radius: 25px; /* Highly rounded corners */
            padding: 1rem 1.5rem;
            margin-bottom: 1rem;
            box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05), 0 2px 4px -1px rgba(0,0,0,0.03);
            transition: all 0.2s ease-in-out;
        }
        .appointment-row:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 15px -3px rgba(0,0,0,0.07), 0 4px 6px -2px rgba(0,0,0,0.04);
        }

        .appointment-cell {
            padding-right: 1rem; /* Espacio entre celdas */
            display: flex;
            align-items: center;
            font-size: 0.95rem;
            color: #4a5568; /* Darker gray for content */
        }
            /* Tamaños de columna para las celdas de datos, deben coincidir con los headers */
            .appointment-cell.col-medico { flex: 0 0 30%; max-width: 30%; }
            .appointment-cell.col-especialidad { flex: 0 0 16%; max-width: 16%; }
            .appointment-cell.col-estado { flex: 0 0 15%; max-width: 15%; }
            .appointment-cell.col-fecha { flex: 0 0 14%; max-width: 14%; }
            .appointment-cell.col-hora { flex: 0 0 12%; max-width: 12%; }
            .appointment-cell.col-acciones { flex: 0 0 13%; max-width: 13%; justify-content: center; padding-right:0;}


        .doctor-info {
            display: flex;
            align-items: center;
            min-width: 0;
            width: 100%;
        }
        .doctor-text {
            min-width: 0; /* permite que el texto se recorte dentro de la columna */
        }
        .doctor-name, .doctor-role {
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        .doctor-avatar img, .doctor-avatar-placeholder {
            width: 48px;
            height: 48px;
            border-radius: 50%;
            object-fit: cover;
            margin-right: 0.75rem;
            flex-shrink: 0;
            background-color: #e2e8f0; /* Placeholder bg */
        }
        .doctor-avatar-placeholder {
            display:flex;
            align-items:center;
            justify-content:center;
            font-size:1.5rem;
            color: #a0aec0; /* Icon color for placeholder */
        }

        .doctor-name {
            font-weight: 600;
            color: #2d3748;
            font-size: 1rem;
        }
        .doctor-role {
            font-size: 0.8rem;
            color: #718096;
        }

        .status-pill {
            display: inline-flex;
            align-items: center;
            padding: 0.3rem 0.75rem;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 500;
            background-color: #ffffff; /* White background for pill */
            border: 1px solid #e2e8f0;
        }
        .status-pill .pill-icon { margin-right: 0.4rem; }

        /* Etiqueta de especialidad: gris oscuro como "Mis" del titulo */
        .specialty-pill {
            display: inline-block;
            max-width: 100%;
            padding: 0.3rem 0.75rem;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 500;
            color: #ffffff;
            background-color: #2d3748;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        /* Colores por estado (clases asignadas en ListarCitasPaciente.aspx.cs) */
        .status-pill.programada { color: #b7791f; border-color: #FFE082; background-color: var(--color-principal-claro); } /* Amarillo PazCitas */
        .status-pill.atendida { color: #38a169; border-color: #9ae6b4; background-color:#f0fff4; } /* Verde */
        .status-pill.cancelada { color: #e53e3e; border-color: #feb2b2; background-color:#fff5f5; } /* Rojo */

        /* Titulo con el amarillo de la marca (igual que Sedes) */
        .page-main-title .title-highlight {
            background: linear-gradient(90deg, #E6B000, var(--color-principal));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        /* Filtros por estado */
        .estado-filtros {
            display: flex;
            flex-wrap: wrap;
            gap: 0.5rem;
            margin-bottom: 1.5rem;
        }
        .filtro-btn {
            background-color: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 20px;
            padding: 0.4rem 1rem;
            font-size: 0.875rem;
            font-weight: 500;
            color: #4a5568;
            cursor: pointer;
            transition: all 0.2s ease-in-out;
        }
        .filtro-btn:hover { border-color: var(--color-principal); }
        .filtro-btn.active {
            background-color: var(--color-principal);
            border-color: var(--color-principal);
            color: #343a40;
        }
        .filtro-count {
            display: inline-block;
            min-width: 1.5rem;
            margin-left: 0.35rem;
            padding: 0 0.4rem;
            border-radius: 10px;
            background-color: #edf2f7;
            font-size: 0.75rem;
            text-align: center;
        }
        .filtro-btn.active .filtro-count { background-color: rgba(255,255,255,0.6); }


        .appointment-cell .icon {
            margin-right: 0.5rem;
            color: #a0aec0; /* Light gray for icons */
            font-size: 1.1rem;
        }
        
        .actions-btn {
            background: none;
            border: none;
            color: #718096;
            font-size: 1.2rem;
            cursor: pointer;
            padding: 0.25rem;
        }
        .actions-btn:hover { color: var(--color-principal-hover); }

        /* Responsive: en pantallas pequeñas, las cabeceras podrían ocultarse y las filas tener más estructura vertical */
        @media (max-width: 992px) {
            .appointments-header-row { display: none; } /* Ocultar cabeceras en móvil */
            .appointment-row {
                flex-direction: column;
                align-items: flex-start;
                padding: 1rem;
            }
            .appointment-cell {
                flex-basis: auto !important; /* Reset flex-basis */
                width: 100% !important;     /* Full width */
                max-width: 100% !important;  /* Full width */
                padding-right: 0;
                margin-bottom: 0.75rem;
                border-bottom: 1px dashed #e2e8f0; /* Separador entre campos en vista móvil */
            }
            .appointment-cell:last-child {
                margin-bottom: 0;
                border-bottom: none;
            }
            .appointment-cell.col-acciones {
                justify-content: flex-end; /* Acciones a la derecha en móvil */
            }
            .page-main-title { font-size: 1.8rem; }
        }
        .no-appointments-message {
            text-align: center;
            padding: 40px 20px;
            font-size: 1.1rem;
            color: #718096;
            background-color: #f7fafc;
            border-radius: 15px;
        }
    </style>
    <script>
        // Filtro de citas por estado (solo en el navegador, sin recargar la pagina)
        document.addEventListener('DOMContentLoaded', function () {
            var barra = document.querySelector('.estado-filtros');
            var botones = document.querySelectorAll('.filtro-btn');
            var filas = document.querySelectorAll('.appointment-row');
            var vacio = document.getElementById('sinResultadosFiltro');
            if (!barra) return;
            if (filas.length === 0) { barra.style.display = 'none'; return; }

            botones.forEach(function (boton) {
                var filtro = boton.getAttribute('data-filtro');
                var total = filtro === 'TODAS' ? filas.length
                    : document.querySelectorAll('.appointment-row[data-estado="' + filtro + '"]').length;
                boton.querySelector('.filtro-count').textContent = total;

                boton.addEventListener('click', function () {
                    botones.forEach(function (b) { b.classList.remove('active'); });
                    boton.classList.add('active');
                    var visibles = 0;
                    filas.forEach(function (fila) {
                        var mostrar = filtro === 'TODAS' || fila.getAttribute('data-estado') === filtro;
                        fila.style.display = mostrar ? '' : 'none';
                        if (mostrar) visibles++;
                    });
                    vacio.style.display = visibles === 0 ? '' : 'none';
                });
            });
        });
    </script>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="cph_Contenido" runat="server">
    <div class="container mt-4 appointments-container">
        <h1 class="page-main-title">Mis <span class="title-highlight">Citas</span></h1>

        <div class="estado-filtros">
            <button type="button" class="filtro-btn active" data-filtro="TODAS">Todas<span class="filtro-count"></span></button>
            <button type="button" class="filtro-btn" data-filtro="PROGRAMADA">Programadas<span class="filtro-count"></span></button>
            <button type="button" class="filtro-btn" data-filtro="ATENDIDA">Atendidas<span class="filtro-count"></span></button>
            <button type="button" class="filtro-btn" data-filtro="CANCELADA">Canceladas<span class="filtro-count"></span></button>
        </div>

        <!-- Cabeceras de la "tabla" -->
        <div class="appointments-header-row d-none d-lg-flex"> <%-- d-lg-flex para mostrar solo en LG y superior --%>
            <div class="header-column col-medico">Médico</div>
            <div class="header-column col-especialidad">Especialidad</div>
            <div class="header-column col-estado">Estado</div>
            <div class="header-column col-fecha">Fecha</div>
            <div class="header-column col-hora">Hora</div>
            <div class="header-column col-acciones">Acciones</div>
        </div>
        
        <asp:Repeater ID="rptMisCitas" runat="server" OnItemDataBound="rptMisCitas_ItemDataBound">
            <ItemTemplate>
                <div class="appointment-row" data-estado='<%# Eval("estadoCita") %>'>
                    <div class="appointment-cell col-medico">
                        <div class="doctor-info">
                            <%--<asp:PlaceHolder ID="phDoctorAvatar" runat="server">
                                <asp:Image ID="imgDoctorAvatar" runat="server" CssClass="doctor-avatar" />
                            </asp:PlaceHolder>--%>
                            <asp:PlaceHolder ID="phDoctorAvatarPlaceholder" runat="server" Visible="true">
                                <%--<div class="doctor-avatar-placeholder"><i class="fas fa-user-md"></i></div>--%>
                                 <div class="doctor-avatar-placeholder">
                                    <i class="fas fa-user-md"></i> <!-- Icono FontAwesome de doctor -->
                                </div>
                            </asp:PlaceHolder>
                            <div class="doctor-text">
                                <div class="doctor-name">
                                    <asp:Literal ID="litNombreMedico" runat="server" />
                                </div>
                                <div class="doctor-role">
                                    <asp:Literal ID="litSubNom" runat="server" />
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="appointment-cell col-especialidad">
                        <asp:Literal ID="litEspecialidadMedico" runat="server" />
                    </div>
                    <div class="appointment-cell col-estado">
                        <asp:Literal ID="litEstadoCita" runat="server"></asp:Literal>
                    </div>
                    <div class="appointment-cell col-fecha">
                        <i class="fas fa-calendar-alt icon"></i>
                        <asp:Literal ID="litFecha" runat="server" />
                    </div>
                    <div class="appointment-cell col-hora">
                        <i class="fas fa-clock icon"></i>
                        <asp:Literal ID="litHora" runat="server" />
                    </div>
                    <div class="appointment-cell col-acciones">
                        <%-- Ejemplo de botón de acción --%>
                        <asp:LinkButton ID="btnVerDetalle" runat="server"
                            CssClass="actions-btn"
                            CommandName="Detalle" CommandArgument='<%# Eval("idCita") %>'
                            OnClick="btnVerDetalle_Click"
                            ToolTip="Ver Detalle">
                            <i class="fa-solid fa-eye"></i>
                        </asp:LinkButton>
                    </div>
                </div>
            </ItemTemplate>

        </asp:Repeater>

        <div id="sinResultadosFiltro" class="no-appointments-message" style="display:none;">
            No tienes citas en este estado.
        </div>
        
        <asp:Label ID="lblMensajeGeneral" runat="server" CssClass="text-danger mt-3 d-block text-center" Visible="false"></asp:Label>

    </div>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="cph_PageTitle" runat="server">
</asp:Content>