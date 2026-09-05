<%@ Page Title="" Language="C#" MasterPageFile="~/PazCitasAdmin.Master" AutoEventWireup="true" CodeBehind="RegistrarTurnosMedico.aspx.cs" Inherits="PazCitasWA.RegistrarTurnosMedico" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cph_Title" runat="server">
    Registrar Turnos a Médico
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="cph_Scripts" runat="server">
    <style>
        /* Estilos para la grilla de turnos */
        .turnos-grid {
            border-collapse: collapse;
            width: 100%;
            margin: 20px 0;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            border-radius: 8px;
            overflow: hidden;
        }

            .turnos-grid th {
                background: linear-gradient(135deg, #48bb78 0%, #38a169 100%);
                color: white;
                padding: 15px 10px;
                text-align: center;
                font-weight: 600;
                border: 1px solid #38a169;
            }

            .turnos-grid td {
                border: 1px solid #e2e8f0;
                padding: 0;
                text-align: center;
                vertical-align: middle;
            }

        .hora-label {
            background: #f8f9fa;
            font-weight: 600;
            color: #2d3748;
            padding: 12px 15px;
            border-right: 2px solid #e2e8f0;
            font-family: 'Courier New', monospace;
            min-width: 80px;
        }

        /* Celdas de turnos clickeables */
        .turno-cell {
            width: 120px;
            height: 50px;
            cursor: pointer;
            transition: all 0.3s ease;
            position: relative;
            border: 2px solid transparent;
        }

            .turno-cell:hover {
                transform: scale(1.05);
                z-index: 10;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
            }

        /* Estados de los turnos */
        .turno-disponible {
            background: #e2e8f0;
            color: #64748b;
        }

            .turno-disponible:hover {
                background: #cbd5e0;
            }

        .turno-seleccionado {
            background: linear-gradient(135deg, #48bb78 0%, #38a169 100%);
            color: white;
            font-weight: 600;
        }

            .turno-seleccionado:hover {
                background: linear-gradient(135deg, #38a169 0%, #2f855a 100%);
            }

        .turno-no-disponible {
            background: #f8f9fa;
            cursor: not-allowed;
            color: #adb5bd;
        }

        /* Iconos en las celdas */
        .turno-cell i {
            font-size: 16px;
            margin-bottom: 2px;
        }

        .turno-cell .turno-text {
            font-size: 11px;
            font-weight: 500;
        }

        /* Información del médico */
        .doctor-card {
            background: linear-gradient(135deg, #48bb78 0%, #38a169 100%);
            border: none !important;
            border-radius: 12px;
            box-shadow: 0 6px 20px rgba(72, 187, 120, 0.3);
            color: white;
        }

            .doctor-card .card-header {
                background: rgba(255, 255, 255, 0.1) !important;
                border: none !important;
                color: white !important;
                border-radius: 12px 12px 0 0 !important;
            }

            .doctor-card .card-body {
                background: rgba(255, 255, 255, 0.95);
                color: #1f2937;
                border-radius: 0 0 12px 12px;
            }

        /* Card de la grilla */
        .grid-card {
            border: none !important;
            border-radius: 12px;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.1);
        }

            .grid-card .card-header {
                background: linear-gradient(135deg, #4fd1c7 0%, #14b8a6 100%) !important;
                border: none !important;
                color: white !important;
                border-radius: 12px 12px 0 0 !important;
            }

        /* Leyenda */
        .legend {
            display: flex;
            justify-content: center;
            gap: 30px;
            margin: 20px 0;
            flex-wrap: wrap;
        }

        .legend-item {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 14px;
            font-weight: 500;
        }

        .legend-color {
            width: 20px;
            height: 20px;
            border-radius: 4px;
            border: 1px solid #ccc;
        }

        .legend-disponible {
            background: #e2e8f0;
        }

        .legend-seleccionado {
            background: linear-gradient(135deg, #48bb78 0%, #38a169 100%);
        }

        .legend-no-disponible {
            background: #f8f9fa;
        }

        /* Contador */
        .counter-info {
            background: linear-gradient(135deg, #3b82f6 0%, #1d4ed8 100%);
            color: white;
            padding: 15px;
            border-radius: 8px;
            text-align: center;
            font-weight: 600;
            margin-bottom: 20px;
        }

        /* Botones */
        .btn-save {
            background: linear-gradient(135deg, #48bb78 0%, #38a169 100%) !important;
            border: none !important;
            border-radius: 20px !important;
            padding: 12px 30px !important;
            font-weight: 600;
            transition: all 0.3s ease;
            box-shadow: 0 4px 12px rgba(72, 187, 120, 0.3);
        }

            .btn-save:hover {
                transform: translateY(-2px);
                box-shadow: 0 6px 18px rgba(72, 187, 120, 0.4);
            }

        .btn-cancel {
            background: #6b7280 !important;
            border: none !important;
            border-radius: 20px !important;
            padding: 12px 30px !important;
            font-weight: 600;
            transition: all 0.3s ease;
        }

            .btn-cancel:hover {
                background: #4b5563 !important;
                transform: translateY(-2px);
            }

        /* Responsive */
        @media (max-width: 768px) {
            .turnos-grid {
                font-size: 12px;
            }

            .turno-cell {
                width: 80px;
                height: 40px;
            }

            .hora-label {
                padding: 8px 10px;
                font-size: 12px;
            }

            .legend {
                gap: 15px;
            }
        }
    </style>

    <script type="text/javascript">
        var turnosSeleccionados = new Set();

        function toggleTurno(button, idTurno) {
            if (turnosSeleccionados.has(idTurno)) {
                // Deseleccionar
                turnosSeleccionados.delete(idTurno);
                button.classList.remove('turno-seleccionado');
                button.classList.add('turno-disponible');
                button.innerHTML = '<i class="fa fa-plus"></i><br><div class="turno-text">Disponible</div>';
            } else {
                // Seleccionar
                turnosSeleccionados.add(idTurno);
                button.classList.remove('turno-disponible');
                button.classList.add('turno-seleccionado');
                button.innerHTML = '<i class="fa fa-check"></i><br><div class="turno-text">Asignado</div>';
            }

            updateCounter();
            updateHiddenField();
        }

        function updateCounter() {
            var counter = document.getElementById('selectedCounter');
            if (counter) {
                counter.textContent = turnosSeleccionados.size + ' turnos seleccionados';
            }
        }

        function updateHiddenField() {
            var hiddenField = document.getElementById('<%= hfTurnosSeleccionados.ClientID %>');
            if (hiddenField) {
                hiddenField.value = Array.from(turnosSeleccionados).join(',');
            }
        }

        function initializeGrid() {
            // Inicializar turnos ya asignados
            var turnosAsignados = '<%= GetTurnosAsignadosJS() %>';
            if (turnosAsignados) {
                var ids = turnosAsignados.split(',');
                ids.forEach(function (id) {
                    if (id.trim()) {
                        turnosSeleccionados.add(parseInt(id.trim()));
                    }
                });
            }

            // Actualizar interfaz
            turnosSeleccionados.forEach(function (idTurno) {
                var button = document.querySelector('[data-turno="' + idTurno + '"]');
                if (button) {
                    button.classList.remove('turno-disponible');
                    button.classList.add('turno-seleccionado');
                    button.innerHTML = '<i class="fa fa-check"></i><br><div class="turno-text">Asignado</div>';
                }
            });

            updateCounter();
            updateHiddenField();
        }

        // Inicializar cuando la página esté lista
        document.addEventListener('DOMContentLoaded', function () {
            initializeGrid();
        });
    </script>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="cph_Contenido" runat="server">
    <div class="container mt-4">
        <!-- Información del Médico -->
        <asp:Panel runat="server" ID="pnlDatosMedico" CssClass="card doctor-card mb-4">
            <div class="card-header fw-bold text-center">
                <i class="fa fa-user-md me-2"></i>Información del Médico
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-4">
                        <p class="mb-2">
                            <i class="fa fa-user me-2 text-success"></i>
                            <strong>Nombre:</strong><br>
                            <asp:Label ID="lblNombreMedico" runat="server" CssClass="ms-4" />
                        </p>
                    </div>
                    <div class="col-md-4">
                        <p class="mb-2">
                            <i class="fa fa-id-card me-2 text-success"></i>
                            <strong>DNI:</strong><br>
                            <asp:Label ID="lblDNIMedico" runat="server" CssClass="ms-4" />
                        </p>
                    </div>
                    <div class="col-md-4">
                        <p class="mb-2">
                            <i class="fa fa-certificate me-2 text-success"></i>
                            <strong>CMP:</strong><br>
                            <asp:Label ID="lblCMPMedico" runat="server" CssClass="ms-4" />
                        </p>
                    </div>
                </div>
            </div>
        </asp:Panel>

        <!-- Grilla de Turnos -->
        <asp:Panel runat="server" ID="pnlTurnos" CssClass="card grid-card">
            <div class="card-header fw-bold text-center">
                <i class="fa fa-calendar-alt me-2"></i>Asignar Turnos de Trabajo - Vista Semanal
            </div>
            <div class="card-body">
                <!-- Contador de seleccionados -->
                <div class="counter-info">
                    <i class="fa fa-info-circle me-2"></i>
                    <span id="selectedCounter">0 turnos seleccionados</span>
                </div>

                <!-- Leyenda -->
                <div class="legend">
                    <div class="legend-item">
                        <div class="legend-color legend-disponible"></div>
                        <span>Disponible</span>
                    </div>
                    <div class="legend-item">
                        <div class="legend-color legend-seleccionado"></div>
                        <span>Asignado</span>
                    </div>
                    <div class="legend-item">
                        <div class="legend-color legend-no-disponible"></div>
                        <span>No disponible</span>
                    </div>
                </div>

                <!-- Grilla de Turnos -->
                <div class="table-responsive">
                    <table class="turnos-grid">
                        <thead>
                            <tr>
                                <th>Hora</th>
                                <th><i class="fa fa-calendar-day me-1"></i>Lunes</th>
                                <th><i class="fa fa-calendar-day me-1"></i>Martes</th>
                                <th><i class="fa fa-calendar-day me-1"></i>Miércoles</th>
                                <th><i class="fa fa-calendar-day me-1"></i>Jueves</th>
                                <th><i class="fa fa-calendar-day me-1"></i>Viernes</th>
                            </tr>
                        </thead>
                        <tbody>
                            <asp:Repeater ID="rptHorarios" runat="server">
                                <ItemTemplate>
                                    <tr>
                                        <td class="hora-label">
                                            <i class="fa fa-clock me-1"></i>
                                            <%# Eval("Hora") %>
                                        </td>
                                        <asp:Repeater ID="rptDias" runat="server" DataSource='<%# Eval("TurnosPorDia") %>'>
                                            <ItemTemplate>
                                                <td>
                                                    <%# (bool)Eval("Disponible") ? 
    "<button type='button' class='turno-cell turno-disponible' data-turno='" + Eval("IdTurno") + 
    "' onclick='toggleTurno(this, " + Eval("IdTurno") + ")'>" +
    "<i class='fa fa-plus'></i><br><div class='turno-text'>Disponible</div></button>" :
    "<div class='turno-cell turno-no-disponible'><i class='fa fa-ban'></i><br><div class='turno-text'>No disponible</div></div>" %>

                                                </td>
                                            </ItemTemplate>
                                        </asp:Repeater>
                                    </tr>
                                </ItemTemplate>
                            </asp:Repeater>
                        </tbody>
                    </table>
                </div>

                <!-- Campo oculto para almacenar selecciones -->
                <asp:HiddenField ID="hfTurnosSeleccionados" runat="server" />

                <div class="mt-4 text-end">
                    <asp:Button ID="btnGuardar" runat="server"
                        Text="💾 Guardar Asignaciones"
                        CssClass="btn btn-save me-3"
                        OnClick="btnGuardar_Click" />
                    <asp:Button ID="btnCancelar" runat="server"
                        Text="❌ Cancelar"
                        CssClass="btn btn-cancel"
                        OnClientClick="window.history.back(); return false;" />
                </div>
            </div>
        </asp:Panel>
    </div>
</asp:Content>
