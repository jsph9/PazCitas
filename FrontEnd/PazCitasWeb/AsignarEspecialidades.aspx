<%@ Page Title="" Language="C#" MasterPageFile="~/PazCitasAdmin.Master" AutoEventWireup="true" CodeBehind="AsignarEspecialidades.aspx.cs" Inherits="PazCitasWA.AsignarEspecialidades" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cph_Title" runat="server">
    Asignar Especialidades
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph_Scripts" runat="server">
    <style>
        /* Contenedor principal */
        .asignar-container {
            background: linear-gradient(135deg, #f0f9f0 0%, #e8f5e8 100%);
            min-height: 100vh;
            padding: 2rem 0;
        }

        /* Card principal */
        .asignar-card {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
            border: none;
            overflow: hidden;
            max-width: 1000px;
            margin: 0 auto;
        }

        /* Header del card */
        .asignar-header {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
            padding: 2rem;
            position: relative;
        }

        .sede-info {
            position: relative;
            z-index: 1;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .sede-details h4 {
            margin: 0;
            font-size: 1.8rem;
            font-weight: 600;
        }

        .sede-details .subtitle {
            opacity: 0.9;
            margin-top: 0.5rem;
            font-size: 1rem;
        }

        /* Body del formulario */
        .asignar-body {
            padding: 2.5rem;
        }

        /* Sección de especialidades */
        .especialidades-section {
            margin-bottom: 2rem;
        }

        .section-title {
            color: #495057;
            font-weight: 600;
            font-size: 1.2rem;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            padding-bottom: 0.5rem;
            border-bottom: 2px solid #e9ecef;
        }

        .section-title i {
            margin-right: 0.5rem;
            color: #28a745;
        }

        /* Grid de especialidades */
        .especialidades-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 1rem;
            margin-top: 1.5rem;
        }

        /* Card de especialidad */
        .especialidad-card {
            background: #f8f9fa;
            border: 2px solid #e9ecef;
            border-radius: 12px;
            padding: 1.25rem;
            transition: all 0.3s ease;
            cursor: pointer;
            position: relative;
        }

        .especialidad-card:hover {
            border-color: #28a745;
            background: #f0fff0;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(40, 167, 69, 0.15);
        }

        .especialidad-card.selected {
            border-color: #28a745;
            background: linear-gradient(135deg, #d4edda 0%, #c3e6cb 100%);
        }

        .especialidad-info {
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .especialidad-details h6 {
            margin: 0;
            font-weight: 600;
            color: #2c3e50;
            font-size: 1.1rem;
        }

        .especialidad-details .description {
            color: #6c757d;
            font-size: 0.9rem;
            margin-top: 0.25rem;
        }

        /* Toggle switch moderno - CORREGIDO */
        .toggle-container {
            position: relative;
            width: 60px;
            height: 30px;
        }

        .toggle-container input[type="checkbox"] {
            position: absolute;
            opacity: 0;
            width: 100%;
            height: 100%;
            margin: 0;
            cursor: pointer;
            z-index: 2;
        }

        .toggle-slider {
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: #ccc;
            transition: 0.3s;
            border-radius: 30px;
            cursor: pointer;
        }

        .toggle-slider:before {
            position: absolute;
            content: "";
            height: 22px;
            width: 22px;
            left: 4px;
            bottom: 4px;
            background-color: white;
            transition: 0.3s;
            border-radius: 50%;
            box-shadow: 0 2px 4px rgba(0,0,0,0.2);
        }

        .toggle-container input:checked + .toggle-slider {
            background-color: #28a745;
        }

        .toggle-container input:checked + .toggle-slider:before {
            transform: translateX(30px);
        }

        /* Estadísticas */
        .stats-container {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
            padding: 1.5rem;
            border-radius: 12px;
            margin-bottom: 2rem;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 1rem;
            text-align: center;
        }

        .stat-item h3 {
            margin: 0;
            font-size: 2rem;
            font-weight: 700;
        }

        .stat-item p {
            margin: 0;
            opacity: 0.9;
            font-size: 0.9rem;
        }

        /* Footer */
        .asignar-footer {
            background: #f8f9fa;
            padding: 1.5rem 2.5rem;
            border-top: 1px solid #e9ecef;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        /* Botones */
        .btn-moderno {
            padding: 0.75rem 2rem;
            border-radius: 10px;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.3s ease;
            border: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .btn-regresar {
            background: #6c757d;
            color: white;
        }

        .btn-regresar:hover {
            background: #5a6268;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(108, 117, 125, 0.3);
            color: white;
        }

        .btn-guardar {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
        }

        .btn-guardar:hover {
            background: linear-gradient(135deg, #218838 0%, #1ea080 100%);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(40, 167, 69, 0.3);
            color: white;
        }

        /* Botones de acción adicionales */
        .btn-seleccionar-todo {
            background: linear-gradient(135deg, #17a2b8 0%, #138496 100%);
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 8px;
            font-size: 0.9rem;
            margin-right: 0.5rem;
        }

        .btn-seleccionar-todo:hover {
            background: linear-gradient(135deg, #138496 0%, #117a8b 100%);
            transform: translateY(-1px);
            color: white;
        }

        .btn-limpiar-todo {
            background: linear-gradient(135deg, #ffc107 0%, #e0a800 100%);
            color: #212529;
            padding: 0.5rem 1rem;
            border-radius: 8px;
            font-size: 0.9rem;
        }

        .btn-limpiar-todo:hover {
            background: linear-gradient(135deg, #e0a800 0%, #d39e00 100%);
            transform: translateY(-1px);
            color: #212529;
        }

        /* Acciones rápidas */
        .acciones-rapidas {
            background: #f8f9fa;
            padding: 1rem;
            border-radius: 10px;
            margin-bottom: 1.5rem;
            border-left: 4px solid #28a745;
        }

        .acciones-rapidas h6 {
            margin: 0 0 0.75rem 0;
            color: #495057;
            font-weight: 600;
        }

        /* Badge personalizado */
        .badge-verde {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-size: 0.9rem;
            font-weight: 500;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .asignar-container {
                padding: 1rem;
            }

            .asignar-body {
                padding: 1.5rem;
            }

            .especialidades-grid {
                grid-template-columns: 1fr;
            }

            .asignar-footer {
                flex-direction: column;
                gap: 1rem;
            }

            .sede-info {
                flex-direction: column;
                text-align: center;
                gap: 1rem;
            }
        }

        /* Animaciones */
        .especialidad-card {
            animation: slideInUp 0.6s ease-out;
        }

        @keyframes slideInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
    </style>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="cph_Contenido" runat="server">
    <div class="asignar-container">
        <div class="container">
            <div class="asignar-card">
                <!-- Header -->
                <div class="asignar-header">
                    <div class="sede-info">
                        <div class="sede-details">
                            <h4>
                                <i class="fa-solid fa-building me-2"></i>
                                <asp:Label ID="lblNombreSede" runat="server" Text="Nombre de la Sede"></asp:Label>
                            </h4>
                            <div class="subtitle">
                                <i class="fa-solid fa-map-marker-alt me-1"></i>
                                <asp:Label ID="lblDireccionSede" runat="server" Text="Dirección de la sede"></asp:Label>
                            </div>
                        </div>
                        <div class="text-end">
                            <div class="badge-verde">
                                ID: <asp:Label ID="lblIdSede" runat="server"></asp:Label>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Body -->
                <div class="asignar-body">
                    <!-- Estadísticas -->
                    <div class="stats-container">
                        <div class="stats-grid">
                            <div class="stat-item">
                                <h3><asp:Label ID="lblTotalEspecialidades" runat="server" Text="0"></asp:Label></h3>
                                <p>Total Especialidades</p>
                            </div>
                            <div class="stat-item">
                                <h3><asp:Label ID="lblEspecialidadesAsignadas" runat="server" Text="0"></asp:Label></h3>
                                <p>Asignadas</p>
                            </div>
                            <div class="stat-item">
                                <h3><asp:Label ID="lblEspecialidadesDisponibles" runat="server" Text="0"></asp:Label></h3>
                                <p>Disponibles</p>
                            </div>
                        </div>
                    </div>

                    <!-- Acciones Rápidas -->
                    <div class="acciones-rapidas">
                        <h6>
                            <i class="fa-solid fa-bolt me-1"></i>
                            Acciones Rápidas
                        </h6>
                        <asp:LinkButton ID="btnSeleccionarTodo" runat="server" CssClass="btn-moderno btn-seleccionar-todo"
                            OnClientClick="seleccionarTodas(true); return false;">
                            <i class="fa-solid fa-check-double"></i>
                            Seleccionar Todas
                        </asp:LinkButton>
                        <asp:LinkButton ID="btnLimpiarTodo" runat="server" CssClass="btn-moderno btn-limpiar-todo"
                            OnClientClick="seleccionarTodas(false); return false;">
                            <i class="fa-solid fa-times"></i>
                            Limpiar Selección
                        </asp:LinkButton>
                    </div>

                    <!-- Sección de Especialidades -->
                    <div class="especialidades-section">
                        <div class="section-title">
                            <i class="fa-solid fa-stethoscope"></i>
                            Especialidades Médicas
                        </div>

                        <!-- Grid de Especialidades -->
                        <div class="especialidades-grid">
                            <asp:Repeater ID="rptEspecialidades" runat="server">
                                <ItemTemplate>
                                    <div class="especialidad-card" data-especialidad-id='<%# Eval("idEspecialidad") %>'>
                                        <div class="especialidad-info">
                                            <div class="especialidad-details">
                                                <h6><%# Eval("nombre") %></h6>
                                                <div class="description">
                                                    <%# Eval("descripcion") ?? "Especialidad médica" %>
                                                </div>
                                            </div>
                                            <div class="toggle-container">
                                                <asp:CheckBox ID="chkEspecialidad" runat="server" 
                                                    Checked='<%# Convert.ToBoolean(Eval("asignada")) %>'
                                                    data-especialidad-id='<%# Eval("idEspecialidad") %>' />
                                                <span class="toggle-slider"></span>
                                            </div>
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>

                        <!-- Mensaje si no hay especialidades -->
                        <asp:Panel ID="pnlSinEspecialidades" runat="server" Visible="false" CssClass="text-center py-5">
                            <i class="fa-solid fa-stethoscope fa-3x text-muted mb-3"></i>
                            <h5 class="text-muted">No hay especialidades disponibles</h5>
                            <p class="text-muted">Contacte al administrador para agregar especialidades</p>
                        </asp:Panel>
                    </div>
                </div>

                <!-- Footer -->
                <div class="asignar-footer">
                    <asp:LinkButton ID="btnRegresar" runat="server" CssClass="btn-moderno btn-regresar" 
                        OnClick="btnRegresar_Click">
                        <i class="fa-solid fa-arrow-left"></i>
                        Regresar a Sedes
                    </asp:LinkButton>
                    <asp:LinkButton ID="btnGuardar" CssClass="btn-moderno btn-guardar" runat="server" 
                        OnClick="btnGuardar_Click">
                        <i class="fa-solid fa-save"></i>
                        Guardar Asignaciones
                    </asp:LinkButton>
                </div>
            </div>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function () {
            initializeToggles();
            updateStats();
        });

        function initializeToggles() {
            // Obtener todos los checkboxes
            const checkboxes = document.querySelectorAll('.toggle-container input[type="checkbox"]');

            checkboxes.forEach(function (checkbox) {
                // Inicializar estado visual
                updateCardState(checkbox);

                // Agregar event listener
                checkbox.addEventListener('change', function () {
                    updateCardState(this);
                    updateStats();
                });
            });

            // Manejar clicks en las cards (excluyendo el toggle)
            const cards = document.querySelectorAll('.especialidad-card');
            cards.forEach(function (card) {
                card.addEventListener('click', function (e) {
                    // No hacer nada si se clickeó el toggle
                    if (e.target.closest('.toggle-container')) {
                        return;
                    }

                    // Encontrar el checkbox y cambiarlo
                    const checkbox = this.querySelector('.toggle-container input[type="checkbox"]');
                    if (checkbox) {
                        checkbox.checked = !checkbox.checked;

                        // Disparar evento change manualmente
                        const event = new Event('change', { bubbles: true });
                        checkbox.dispatchEvent(event);
                    }
                });
            });
        }

        function updateCardState(checkbox) {
            const card = checkbox.closest('.especialidad-card');
            if (card) {
                if (checkbox.checked) {
                    card.classList.add('selected');
                } else {
                    card.classList.remove('selected');
                }
            }
        }

        function updateStats() {
            const checkboxes = document.querySelectorAll('.toggle-container input[type="checkbox"]');
            const total = checkboxes.length;
            const asignadas = Array.from(checkboxes).filter(cb => cb.checked).length;
            const disponibles = total - asignadas;

            // Actualizar los labels
            const totalLabel = document.querySelector('[id$="lblTotalEspecialidades"]');
            const asignadasLabel = document.querySelector('[id$="lblEspecialidadesAsignadas"]');
            const disponiblesLabel = document.querySelector('[id$="lblEspecialidadesDisponibles"]');

            if (totalLabel) totalLabel.textContent = total;
            if (asignadasLabel) asignadasLabel.textContent = asignadas;
            if (disponiblesLabel) disponiblesLabel.textContent = disponibles;
        }

        // Función para seleccionar/deseleccionar todas las especialidades
        function seleccionarTodas(seleccionar) {
            const checkboxes = document.querySelectorAll('.toggle-container input[type="checkbox"]');
            checkboxes.forEach(function (checkbox) {
                checkbox.checked = seleccionar;
                updateCardState(checkbox);
            });
            updateStats();
        }
    </script>
</asp:Content>
