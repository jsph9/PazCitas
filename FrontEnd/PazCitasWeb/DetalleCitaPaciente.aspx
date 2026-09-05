<%@ Page Title="" Language="C#" MasterPageFile="~/PazCitasPaciente.Master" AutoEventWireup="true" CodeBehind="DetalleCitaPaciente.aspx.cs" Inherits="PazCitasWA.DetalleCitaPaciente" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cph_Title" runat="server">
    Detalles de mi Cita
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph_Scripts" runat="server">
    <script type="text/javascript">
        // Funciones básicas para mostrar/ocultar el modal
        function openModal(modalId) {
            const modal = document.getElementById(modalId);
            if (modal) {
                modal.classList.add('show');
                document.body.style.overflow = 'hidden';
            }
        }

        function closeModal(modalId) {
            const modal = document.getElementById(modalId);
            if (modal) {
                modal.classList.remove('show');
                document.body.style.overflow = 'auto';
            }
        }

        // Función que se llama al hacer clic en una fecha
        function selectDate(dateValue, hdnDateId, hdnTimeId, refreshButtonId) {
            // Guarda la fecha en el campo oculto
            document.getElementById(hdnDateId).value = dateValue;
            // Resetea la hora seleccionada, ya que cambiamos de día
            document.getElementById(hdnTimeId).value = '';
            // Dispara el postback parcial del botón invisible
            document.getElementById(refreshButtonId).click();
        }

        // Función que se llama al hacer clic en una hora
        function selectTime(timeValue, hdnTimeId, refreshButtonId) {
            // Guarda la hora en el campo oculto
            document.getElementById(hdnTimeId).value = timeValue;
            // Dispara el postback parcial
            document.getElementById(refreshButtonId).click();
        }

        // Funcion para las flechas del modal de modificación (CON LÍMITES)
        function navigateDates(direction, hdnOffsetId, refreshButtonId) {
            const offsetField = document.getElementById(hdnOffsetId);
            let currentOffset = parseInt(offsetField.value, 10);
            const originalOffset = currentOffset;

            // Lógica para limitar la navegación
            if (direction === -1 && currentOffset > 0) {
                // Solo podemos ir hacia atrás si no estamos en la primera página (offset > 0).
                currentOffset += direction; // Resta 1
            }
            else if (direction === 1 && currentOffset < 2) { // El límite es 3 (página 0, 1, 2, 3)
                // Solo podemos ir hacia adelante si no hemos llegado a la página 3.
                currentOffset += direction; // Suma 1
            }

            // Solo hacemos el postback si el offset realmente cambió.
            if (originalOffset !== currentOffset) {
                offsetField.value = currentOffset;
                document.getElementById(refreshButtonId).click();
            }
        }
    </script>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="cph_PageTitle" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="cph_Contenido" runat="server">
    <style>
        :root {
            /* --- Parámetros de Diseño del Dashboard --- */
            --dashboard-card-bg-color: 255, 255, 255;
            --dashboard-card-opacity: 0.85;
            --dashboard-card-shadow: 0 8px 25px rgba(0, 0, 0, 0.08);
            --dashboard-card-shadow-hover: 0 12px 35px rgba(0, 0, 0, 0.12);
            --positive-accent-color: #16a34a;
            --positive-accent-bg: #f0fdf4;
            --negative-accent-color: #dc2626;
            --negative-accent-bg: #fef2f2;
        }

        .dashboard-container {
            width: 100%;
            max-width: 1400px; /* Ancho máximo del dashboard completo */
            margin: 1rem auto; /* Centrado horizontal y margen vertical */
            padding: 0 1rem; /* Espaciado lateral para pantallas pequeñas */
            box-sizing: border-box; /* Asegura que el padding no afecte el ancho total */
            color: var(--color-texto-primario);
        }

        .dashboard-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            grid-template-areas: "main main sidebar"; 
            gap: var(--layout-gap, 1.25rem);
        }

        .dashboard-main-content {
            grid-area: main;
            display: flex;
            flex-direction: column;
            gap: var(--layout-gap, 1.25rem);
        }

        .dashboard-sidebar-content {
            grid-area: sidebar;
            display: flex;
            flex-direction: column;
            gap: var(--layout-gap, 1.25rem);
        }

        .dashboard-card {
            background-color: rgba(var(--dashboard-card-bg-color), var(--dashboard-card-opacity));
            border-radius: var(--contenedor-border-radius, 1.25rem);
            box-shadow: var(--dashboard-card-shadow);
            padding: 1.5rem;
            border: none;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

            .dashboard-card:hover {
                transform: translateY(-8px);
                box-shadow: var(--dashboard-card-shadow-hover);
            }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: var(--layout-gap, 1.25rem);
        }

        .stat-card {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .stat-card-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            color: var(--color-texto-secundario);
        }

            .stat-card-header i {
                font-size: 24px;
            }

        .stat-card .value {
            font-size: 1.5rem;
            font-weight: 700;
        }

        .stat-card .label {
            font-size: 1rem;
            color: var(--color-texto-secundario);
        }

        .mid-section {
            display: grid;
            grid-template-columns: 1fr 2fr;
            gap: var(--layout-gap, 1.25rem);
        }

        .metrics-stack {
            display: flex;
            flex-direction: column;
            gap: var(--layout-gap, 1.25rem);
        }

        .metric-card .value {
            font-size: 3rem;
            font-weight: 700;
            line-height: 1;
        }

        .metric-card .label {
            font-weight: 600;
            margin-bottom: 16px;
        }

        .metric-card .change {
            display: inline-block;
            padding: 4px 10px;
            border-radius: 999px;
            font-size: 0.8rem;
            font-weight: 600;
            margin-left: 12px;
        }

        .change.positive {
            background-color: var(--positive-accent-bg);
            color: var(--positive-accent-color);
        }

        .change.negative {
            background-color: var(--negative-accent-bg);
            color: var(--negative-accent-color);
        }

        .revenue-card .card-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .revenue-card .title {
            font-weight: 600;
        }

        .revenue-card .subtitle {
            font-size: 0.875rem;
            color: var(--color-texto-secundario);
        }

        .revenue-chart-container {
            position: relative;
        }

            .revenue-chart-container svg {
                width: 100%;
                height: auto;
            }

        .revenue-tooltip {
            position: absolute;
            top: 25%;
            left: 20%;
            background-color: var(--color-texto-primario);
            color: white;
            padding: 8px 12px;
            border-radius: 8px;
            font-size: 0.8rem;
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
        }

            .revenue-tooltip div span {
                color: #ccc;
            }

        .email-list ul {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        .email-list li {
            display: flex;
            align-items: center;
            padding: 16px 0;
            border-bottom: 1px solid var(--color-borde-suave);
        }

            .email-list li:last-child {
                border-bottom: none;
            }

        .email-list .avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            margin-right: 12px;
        }

        .email-list .sender {
            font-weight: 600;
        }

        .email-list .subject {
            color: var(--color-texto-secundario);
            flex-grow: 1;
            margin-left: 20px;
        }

        .email-list .time {
            font-size: 0.875rem;
            color: var(--color-texto-secundario);
            white-space: nowrap;
        }

        .card--highlight {
            background-color: var(--color-principal);
            color: white;
        }

            .card--highlight .subtitle, .card--highlight p {
                color: rgba(255, 255, 255, 0.85);
            }

        .progress-bar {
            width: 100%;
            height: 8px;
            background-color: rgba(255, 255, 255, 0.3);
            border-radius: 4px;
            overflow: hidden;
            margin: 16px 0;
        }

        .progress-bar-fill {
            width: 75%;
            height: 100%;
            background-color: white;
            border-radius: 4px;
        }

        .view-status-btn {
            width: 100%;
            padding: 12px;
            background-color: white;
            color: var(--color-principal-hover);
            border: none;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            margin-top: 16px;
            transition: all 0.2s ease;
        }

            .view-status-btn:hover {
                background-color: var(--color-principal-claro);
            }

        .todo-list ul {
            list-style: none;
            padding: 0;
            margin-top: 20px;
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        .todo-list li {
            display: flex;
            align-items: center;
            gap: 16px;
        }

        .todo-list .icon-wrapper {
            color: var(--color-texto-secundario);
            width: 40px;
            height: 40px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
        }

        .todo-list .task-title {
            font-weight: 600;
        }

        .todo-list .task-date {
            font-size: 0.875rem;
            color: var(--color-texto-secundario);
        }

        /* ========================================================== */
        /* ====== ESTILOS PARA TARJETA OSCURA (MOTIVO DE CITA) ====== */
        /* ========================================================== */
        .dark-info-card {
            background-color: var(--color-texto-primario);
            color: white; /* Color de texto por defecto para los hijos */
            display: flex;
            flex-direction: column;
            gap: 0.75rem; /* Espacio entre título y texto */
        }

        .dark-card-title {
            display: flex;
            align-items: center;
            gap: 0.6rem;
            font-size: 1.1rem;
            font-weight: 600;
            color: rgba(255, 255, 255, 0.95); /* Blanco brillante pero no puro */
        }

        .dark-card-text {
            font-size: 0.9rem;
            line-height: 1.6;
            color: rgba(255, 255, 255, 0.8); /* Blanco más tenue para el cuerpo del texto */
            padding-left: 1.8rem; /* Alinea el texto con el título, dejando espacio para el icono */
        }

        @media (max-width: 1200px) {
            .dashboard-grid {
                grid-template-columns: 2fr 1fr;
            }

            .stats-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media (max-width: 992px) {
            .dashboard-grid {
                grid-template-columns: 1fr;
                grid-template-areas:
                    "main"
                    "sidebar";
            }

            .mid-section {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 767.98px) {
            .stats-grid {
                grid-template-columns: 1fr;
            }
        }
        .doctor-profile-card {
            display: flex;
            align-items: center;
            gap: 1.25rem;
        }

        .doctor-profile-image-container {
            flex-shrink: 0;
        }

        .doctor-profile-img {
            width: 72px;
            height: 72px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid var(--color-principal-claro);
        }

        .doctor-profile-body {
            display: flex;
            flex-direction: column;
        }

        .doctor-profile-email-tag {
            display: inline-block; /* Se ajusta al contenido */
            width: fit-content;
            font-size: 0.75rem; 
            font-weight: 600;
            color: var(--color-principal-hover); /* Usa el color de la marca */
            background-color: var(--color-principal-claro); /* Fondo claro de la marca */
            padding: 4px 10px;
            border-radius: 999px; /* Forma de píldora */
            margin-bottom: 8px; /* Espacio debajo del tag */
        }

        .doctor-profile-name {
            font-size: 1.1rem;
            font-weight: 600;
            line-height: 1.2;
            color: var(--color-texto-primario);
        }

        .doctor-profile-code {
            font-size: 0.8rem;
            font-weight: 500;
            color: var(--color-texto-secundario);
            margin-top: 2px;
        }

        /* ====== ESTILOS PARA EL CALENDARIO (DISEÑO AMARILLO/OSCURO) ====== */
        .calendar-widget-card {
            background: linear-gradient( to bottom right, rgba(255, 217, 102, 0.85), /* #FFD966 con 85% de opacidad */
            rgba(255, 195, 0, 0.90) /* #FFC300 con 90% de opacidad */
            );
            color: var(--color-texto-primario);
            padding: 1.5rem;
            -webkit-backdrop-filter: blur(10px);
            backdrop-filter: blur(10px);
        }

        .calendar-header {
            display: flex;
            justify-content: center;
            align-items: center;
            margin-bottom: 1.5rem;
        }

            .calendar-header .month-year {
                font-size: 1.25rem;
                font-weight: 600;
            }

        .calendar-grid {
            display: grid;
            grid-template-columns: repeat(7, 1fr);
            gap: 0.5rem;
            text-align: center;
        }

        .calendar-day-header {
            font-size: 0.8rem;
            font-weight: 600;
            /* Un color de texto que se vea bien sobre amarillo */
            color: rgba(52, 58, 64, 0.7);
        }

        .calendar-day-cell {
            font-size: 0.9rem;
            font-weight: 500;
            padding: 0.5rem; /* Padding uniforme para centrar mejor el número */
            position: relative;
            border-radius: 8px; /* Mantenemos las esquinas redondeadas */
            cursor: default;
            transition: all 0.2s ease;
            background-color: var(--color-principal-claro); /* El color amarillo suave de tu marca */
        }

            .calendar-day-cell.other-month {
                color: rgba(52, 58, 64, 0.4);
                background-color: rgba(255, 249, 230, 0.5); /* El mismo amarillo suave pero con 50% de opacidad */
            }

            .calendar-day-cell.today-day {
                /* Marco oscuro sin fondo */
                box-shadow: 0 0 0 2px var(--color-texto-primario) inset;
                font-weight: 700;
            }

            .calendar-day-cell.selected-day {
                /* El color oscuro de tu tarjeta de "Board Meeting" */
                background-color: var(--color-texto-primario);
                color: white; /* Texto blanco para contraste */
                font-weight: 700;
                box-shadow: none;
            }

        .calendar-divider {
            border: 0;
            border-top: 1px solid rgba(52, 58, 64, 0.2);
            margin: 1.5rem 0;
        }

        .calendar-time-display {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            font-size: 1rem;
            font-weight: 500;
        }

        .calendar-header {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 0.75rem; /* Añadimos espacio entre el icono y el texto */
            margin-bottom: 1.5rem;
        }

            .calendar-header .month-year {
                font-size: 1.3rem; /* Un poco más grande para mayor impacto */
                font-weight: 700; /* Cambiado a 700 para que sea más negrita */
            }


        .calendar-divider {
            border: 0;
            border-top: 1px solid rgba(52, 58, 64, 0.2);
            margin: 1.5rem 0;
        }

        .calendar-time-wrapper {
            display: flex;
            justify-content: center; /* Centra el contenedor blanco */
        }

        .calendar-time-display {
            display: inline-flex; /* Se ajusta al contenido */
            align-items: center;
            gap: 0.6rem;
            background-color: white; /* Fondo blanco sólido */
            color: var(--color-texto-primario);
            padding: 8px 16px; /* Padding interno para darle cuerpo */
            border-radius: 12px; /* Esquinas redondeadas */
            font-size: 1rem;
            font-weight: 600;
        }

        /*     ESTILOS FINALES PARA TIMELINE   */

        .timeline-stepper-card {
            padding: 1.5rem;
            display: flex;
            flex-direction: column;
            align-items: center;
            padding-bottom: 5rem;
            position: relative; 
        }

        .timeline-main-title {
            font-size: 1.2rem; 
            font-weight: 700;
            color: var(--color-texto-primario); 
            margin-bottom: 2.5rem;
            display: flex;
            align-items: center;
            gap: 0.6rem; 
        }

        .timeline-container {
            display: flex;
            align-items: flex-start;
            width: 100%;
        }

        .timeline-step {
            display: flex;
            flex-direction: column;
            align-items: center;
            text-align: center;
            width: 120px;
            position: relative;
        }

        .step-icon {
            width: 36px;
            height: 36px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            background-color: white;
            border: 2px solid #e5e7eb;
            color: #9ca3af;
            font-size: 1rem;
            transition: all 0.3s ease;
            z-index: 1;
        }

        .step-details {
            margin-top: 1rem;
        }

            .step-details .round-title {
                font-size: 0.75rem;
                font-weight: 700;
                color: var(--color-texto-secundario);
                text-transform: uppercase;
            }

            .step-details .step-description {
                font-size: 0.9rem;
                font-weight: 600;
                color: var(--color-texto-primario);
                margin: 4px 0;
            }

            .step-details .step-date {
                font-size: 0.8rem;
                color: var(--color-texto-secundario);
            }

        .timeline-connector {
            flex-grow: 1;
            height: 2px;
            margin-top: 18px;
            background-image: linear-gradient(to right, #e5e7eb 50%, transparent 50%);
            background-position: center;
            background-size: 8px 2px;
            background-repeat: repeat-x;
        }

        .step-status-tag {
            position: absolute;
            top: 150px; 
            left: 50%;
            transform: translateX(-50%);
            display: inline-block;
            font-size: 0.75rem;
            font-weight: 600;
            padding: 6px 16px;
            border-radius: 999px;
            white-space: nowrap;
        }

        .tag-completed {
            background-color: #d1fae5;
            color: #065f46;
        }

        .tag-in-progress {
            background-color: #dbeafe;
            color: #1e40af;
        }

        .timeline-step.completed .step-icon,
        .timeline-step.active .step-icon {
            color: white;
        }

        .timeline-step.completed .step-icon {
            background-color: #10b981;
            border-color: #10b981;
        }

        .timeline-step.active .step-icon {
            background-color: #3b82f6;
            border-color: #3b82f6;
        }

        .timeline-step.completed + .timeline-connector {
            background-image: linear-gradient(to right, #10b981 100%, #10b981 100%);
            background-size: 100% 2px;
        }

        .timeline-step.active + .timeline-connector {
            background-image: linear-gradient(to right, #3b82f6 50%, #e5e7eb 50%);
            background-size: 100% 2px;
        }

        /* ====== ESTILOS PARA LA TARJETA DE PAGO DE CITA   ====== */
        .payment-overview-card {
            display: flex;
            flex-direction: column;
            gap: 1.5rem; 
        }

        .payment-overview-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .payment-overview-title {
            font-size: 1.2rem;
            font-weight: 600;
            color: var(--color-texto-primario);
        }

        .payment-status-tag {
            font-size: 0.75rem;
            font-weight: 600;
            padding: 6px 16px;
            border-radius: 999px;
            white-space: nowrap;
        }
        /* Colores para la píldora de estado */
        .tag-payment-paid {
            background-color: #d1fae5;
            color: #065f46;
        }
        /* Verde */
        .tag-payment-pending {
            background-color: #fee2e2;
            color: #991b1b;
        }
        /* Rojo */
        .tag-payment-partial {
            background-color: #dbeafe;
            color: #1e40af;
        }
        /* Azul */

        .payment-overview-body {
            display: flex;
            justify-content: space-between;
            align-items: flex-end; /* Alinea las barras y la leyenda abajo */
            gap: 2rem;
        }

        .payment-bars-container {
            display: flex;
            gap: 1.5rem; /* Espacio entre las barras de progreso */
        }

        .payment-bar-wrapper {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 0.5rem;
            width: 60px; /* Ancho fijo para cada barra */
        }

        .payment-bar-amount {
            font-size: 0.9rem;
            font-weight: 600;
            color: var(--color-texto-primario);
        }

        .payment-bar-background {
            width: 100%;
            height: 100px;
            background-color: #f3f4f6; /* Gris claro de fondo */
            border-radius: 12px;
            display: flex;
            flex-direction: column-reverse; /* Hace que el relleno empiece desde abajo */
        }

        .payment-bar-fill {
            width: 100%;
            border-radius: 12px;
            transition: height 0.8s ease-in-out; /* Animación suave */
        }

        /* Colores específicos para cada barra */
        .bar-total {
            background-color: #8b5cf6;
        }
        /* Morado */
        .bar-insurance {
            background-color: #84cc16;
        }
        /* Verde-Lima */
        .bar-patient {
            background-color: #f97316;
        }
        /* Naranja */

        .payment-legend {
            display: flex;
            flex-direction: column;
            gap: 0.75rem;
            padding-bottom: 0.5rem; /* Alinea con la parte inferior de las barras */
        }

        .legend-item {
            display: flex;
            align-items: center;
            gap: 0.6rem;
            font-size: 0.85rem;
            font-weight: 500;
            color: var(--color-texto-secundario);
        }

        .legend-dot {
            width: 10px;
            height: 10px;
            border-radius: 50%;
        }
        /* ====== ESTILOS PARA TARJETA DE PAGO (ULTRA-COMPACTA) ====== */
        .payment-overview-card {
            display: flex;
            flex-direction: column;
            gap: 1rem; /* Espacio reducido entre header y body */
        }

        .payment-overview-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .payment-overview-title {
            font-size: 1.2rem;
            font-weight: 600;
            color: var(--color-texto-primario);
        }

        .payment-status-tag {
            font-size: 0.75rem;
            font-weight: 600;
            padding: 6px 16px;
            border-radius: 999px;
            white-space: nowrap;
        }
        /* Colores de las píldoras usando la paleta de la marca */
        .tag-payment-paid {
            background-color: var(--positive-accent-bg);
            color: var(--positive-accent-color);
        }
        /* Verde */
        .tag-payment-pending {
            background-color: var(--negative-accent-bg);
            color: var(--negative-accent-color);
        }
        /* Rojo */
        .tag-payment-partial {
            background-color: #dbeafe;
            color: #1e40af;
        }
        /* Azul (se mantiene) */

        .payment-overview-body {
            display: flex;
            justify-content: space-around; /* Distribuye las barras equitativamente */
            align-items: flex-start;
        }

        .payment-bar-wrapper {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 0.5rem;
            width: 60px; /* Ancho de cada conjunto (monto+barra+label) */
        }

        .payment-bar-amount {
            font-size: 0.85rem;
            font-weight: 600;
            color: var(--color-texto-primario);
        }

        .payment-bar-background {
            width: 100%;
            height: 60px; /* Altura de las barras */
            background-color: #f3f4f6;
            border-radius: 10px;
            display: flex;
            flex-direction: column-reverse;
        }

        .payment-bar-fill {
            width: 100%;
            border-radius: 10px;
            transition: height 0.8s ease-in-out;
        }

        /* --- COLORES CONSISTENTES CON LA PÁGINA --- */
        .bar-total {
            background-color: var(--color-principal);
        }
        /* Amarillo de la marca */
        .bar-insurance {
            background-color: var(--positive-accent-color);
        }
        /* Verde de acento */
        .bar-patient {
            background-color: var(--negative-accent-color);
        }
        /* Rojo de acento */

        .bar-label {
            font-size: 0.75rem;
            font-weight: 500;
            color: var(--color-texto-secundario);
            margin-top: 0.25rem; /* Pequeño espacio sobre el texto */
        }
        /* ======   ESTILOS PARA LA TARJETA MOTIVO DE CITA  ====== */
        .consultation-info-card {
            display: flex;
            flex-direction: column; /* Cambiado a columna para layout vertical */
            gap: 0.75rem; /* Espacio entre el título y el texto del motivo */
        }

        .consultation-info-title {
            display: flex;
            align-items: center;
            gap: 0.6rem;
            font-size: 1.1rem;
            font-weight: 600;
            color: var(--color-texto-secundario);
        }

        .consultation-info-text {
            font-size: 0.95rem;
            line-height: 1.6;
            font-weight: 500;
            color: var(--color-texto-primario);
            padding-left: 2rem; /* Añadimos un padding para alinear con el texto del título, no con el ícono */
        }

        .actions-card {
            background-color: var(--color-texto-primario);
            color: white;
            display: flex;
            flex-direction: column;
            gap: 1rem;
        }

        .actions-card-title {
            display: flex;
            align-items: center;
            gap: 0.6rem;
            font-size: 1.1rem;
            font-weight: 600;
            color: rgba(255, 255, 255, 0.95);
        }

        .action-item {
            display: flex;
            flex-direction: column;
        }

            .action-item + .action-item {
                margin-top: 0.75rem;
            }

        .action-button {
            width: 100%;
            padding: 12px;
            background-color: white;
            color: var(--color-texto-primario);
            border: none;
            border-radius: 10px;
            font-weight: 600;
            font-size: 0.9rem;
            cursor: pointer;
            transition: background-color 0.2s ease, color 0.2s ease;
            text-align: center;
            text-decoration: none;
        }

            /* Hover para el botón de Modificar (Amarillo) */
            .action-button.modify-button:hover {
                background-color: var(--color-principal);
                color: white;
            }

            /* Hover para el botón de Cancelar (Rojo) */
            .action-button.cancel-button:hover {
                background-color: #ef4444;
                color: white;
            }

            /* Estilo para un botón deshabilitado */
            .action-button[disabled],
            .action-button.aspNetDisabled { 
                background-color: #4b5563 !important; 
                color: #9ca3af !important; 
                cursor: not-allowed !important; 
                pointer-events: none;
            }

       
        .action-warning-message {
            font-size: 0.8rem;
            color: #ffc107;
            text-align: center;
            margin-top: 0.75rem;
        }

        

        .modal-wrapper {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: 1050;
            display: none; /* Oculto por defecto */
            align-items: center;
            justify-content: center;
            background-color: rgba(30, 30, 30, 0.6);
            backdrop-filter: blur(5px);
            -webkit-backdrop-filter: blur(5px);
        }

            .modal-wrapper.show {
                display: flex; /* Se muestra con JS */
            }

        .modal-content {
            background-color: #fff;
            color: var(--color-texto-primario);
            border-radius: 1rem;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
            width: 100%;
            max-width: 500px;
            transform: translateY(-30px);
            opacity: 0;
            transition: transform 0.3s ease-out, opacity 0.3s ease-out;
            display: flex;
            flex-direction: column;
        }

        .modal-wrapper.show .modal-content {
            transform: translateY(0);
            opacity: 1;
        }

        .modal-header {
            padding: 1.25rem 1.5rem;
            border-bottom: 1px solid var(--color-borde-suave);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .modal-title {
            font-size: 1.25rem;
            font-weight: 600;
        }

        .modal-close-button {
            background: transparent;
            border: none;
            font-size: 1.75rem;
            cursor: pointer;
            color: #6c757d;
        }

        .modal-body {
            padding: 1.5rem;
            font-size: 1rem;
            line-height: 1.6;
            color: var(--color-texto-secundario);
        }

        .modal-footer {
            padding: 1.25rem 1.5rem;
            background-color: #f8f9fa;
            border-top: 1px solid var(--color-borde-suave);
            border-bottom-left-radius: 1rem;
            border-bottom-right-radius: 1rem;
            display: flex;
            justify-content: flex-end;
            gap: 0.75rem;
        }

            .modal-footer .btn {
                padding: 10px 24px;
                font-weight: 600;
                border-radius: 8px;
                border: none;
                cursor: pointer;
            }

            .modal-footer .btn-secondary {
                background-color: #e9ecef;
                color: var(--color-texto-primario);
            }

            .modal-footer .btn-danger {
                background-color: var(--negative-accent-color);
                color: white;
            }

            .modal-footer .btn-primary {
                background-color: var(--color-principal);
                color: var(--color-texto-primario);
            }

        /* ====== ESTILOS PERSONALIZADOS PARA EL MODAL DE CANCELACIÓN ====== */

        /* 1. Header rojo para el modal de cancelación */
        #modalCancel .modal-header {
            background-color: var(--negative-accent-color);
            color: white;
            border-bottom: none;
            border-top-left-radius: 1rem;
            border-top-right-radius: 1rem;
        }

        /* El título y el botón de cerrar ahora deben ser blancos */
        #modalCancel .modal-title,
        #modalCancel .modal-close-button {
            color: white;
        }

        /* 2. Cuerpo del modal con layout de imagen y texto */
        #modalCancel .modal-body {
            display: flex;
            align-items: center;
            gap: 1.5rem; 
        }

        /* Estilos para la imagen de advertencia */
        .modal-warning-image {
            flex-shrink: 0; /* Evita que la imagen se encoja */
            width: 200px; /* Tamaño de la imagen */
            height: 200px;
        }

        /* Contenedor para el texto descriptivo */
        .modal-text-content p {
            margin: 0; /* Reseteamos márgenes por si acaso */
            line-height: 1.6;
        }

            .modal-text-content p:first-child { 
                font-weight: 600;
                font-size: 1.1rem;
                color: var(--color-texto-primario);
                margin-bottom: 0.5rem;
            }

            .modal-text-content p:last-child { /* El texto secundario */
                font-size: 0.95rem;
                color: var(--color-texto-secundario);
            }


        /* 3. Footer oscuro y botones interactivos */
        #modalCancel .modal-footer {
            background-color: var(--color-texto-primario); /* El color oscuro de la marca */
            border-top: 1px solid #4b5563; /* Un borde sutil un poco más claro que el fondo */
        }

            /* Ajuste general para los botones en este footer específico */
            #modalCancel .modal-footer .btn {
                transition: transform 0.2s ease-out, box-shadow 0.2s ease-out; /* Animación suave */
            }

                /* Efecto hover para TODOS los botones en este footer */
                #modalCancel .modal-footer .btn:hover {
                    transform: translateY(-4px); /* El "salto" hacia arriba */
                    box-shadow: 0 6px 15px rgba(0, 0, 0, 0.25); /* Sombra para dar profundidad */
                }

            /* Colores específicos para los botones en el footer oscuro */
            #modalCancel .modal-footer .btn-secondary {
                background-color: #4b5563; /* Un gris oscuro para el botón de "No" */
                color: white;
                border: none;
            }

                #modalCancel .modal-footer .btn-secondary:hover {
                    background-color: #6b7280; /* Un gris un poco más claro al pasar el cursor */
                }

            /* El botón de peligro ya tiene su color, solo nos aseguramos */
            #modalCancel .modal-footer .btn-danger {
                background-color: var(--negative-accent-color);
                color: white;
            }

                #modalCancel .modal-footer .btn-danger:hover {
                    background-color: #b91c1c; /* Rojo más oscuro para el hover */
                }
        
        /* ====== ESTILOS PERSONALIZADOS PARA EL MODAL DE MODIFICACIÓN ====== */

        /* 1. Header amarillo con bordes redondeados */
        #modalModify .modal-header {
            background-color: var(--color-principal); /* Amarillo de la marca */
            color: var(--color-texto-primario); /* Texto oscuro para contraste */
            border-bottom: none;
            border-top-left-radius: 1rem;
            border-top-right-radius: 1rem;
        }

        /* Título y botón de cerrar ahora usan texto oscuro */
        #modalModify .modal-title,
        #modalModify .modal-close-button {
            color: var(--color-texto-primario);
        }

        /* 2. Cuerpo del modal sin imagen, solo texto */
        #modalModify .modal-body {
            padding: 2rem 1.5rem; /* Un poco más de padding vertical para compensar la falta de imagen */
        }

            /* Estilos para el texto dentro del body */
            #modalModify .modal-body p {
                margin: 0;
                line-height: 1.6;
            }

                #modalModify .modal-body p:first-child { /* El título "Estás a punto de..." */
                    font-weight: 600;
                    font-size: 1.1rem;
                    color: var(--color-texto-primario);
                    margin-bottom: 0.75rem;
                }

                #modalModify .modal-body p:not(:first-child) { /* El resto del texto */
                    font-size: 0.95rem;
                    color: var(--color-texto-secundario);
                }

        /* 3. Footer oscuro y botones interactivos, similar al de cancelar */
        #modalModify .modal-footer {
            background-color: var(--color-texto-primario);
            border-top: 1px solid #4b5563;
        }

            /* Efecto hover para TODOS los botones en este footer */
            #modalModify .modal-footer .btn {
                transition: transform 0.2s ease-out, box-shadow 0.2s ease-out;
            }

                #modalModify .modal-footer .btn:hover {
                    transform: translateY(-4px);
                    box-shadow: 0 6px 15px rgba(0, 0, 0, 0.25);
                }

            /* Colores específicos para los botones en el footer oscuro */
            #modalModify .modal-footer .btn-secondary {
                background-color: #4b5563; /* Gris oscuro para el botón de "Salir" */
                color: white;
                border: none;
            }

                #modalModify .modal-footer .btn-secondary:hover {
                    background-color: #6b7280;
                }

            #modalModify .modal-footer .btn-primary {
                background-color: var(--color-principal);
                color: var(--color-texto-primario);
            }

                #modalModify .modal-footer .btn-primary:hover {
                    background-color: var(--color-principal-hover);
                }
        /* ====== ESTILOS PARA EL SCHEDULER DENTRO DEL MODAL DE MODIFICACIÓN ====== */

        /* Contenedor principal del cuerpo del modal */
        #modalModify .modal-body {
            display: flex;
            flex-direction: column;
            gap: 1.5rem; /* Espacio entre el selector de fecha y el de hora */
        }

        /* Título de las secciones (ej. "Selecciona un día") */
        .scheduler-section-title {
            font-size: 1rem;
            font-weight: 600;
            color: var(--color-texto-secundario);
            padding-bottom: 0.5rem;
            border-bottom: 1px solid var(--color-borde-suave);
            margin-bottom: 0.5rem;
        }

        /* Contenedor del carrusel de fechas */
        .date-selector-container {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .date-selector {
            display: flex;
            gap: 0.75rem;
            overflow-x: auto; /* Permite scroll horizontal si hay muchas fechas */
            padding: 0.5rem;
            flex-grow: 1;
            /* Ocultar la barra de scroll */
            scrollbar-width: none; /* Firefox */
            -ms-overflow-style: none; /* IE y Edge */
        }

            .date-selector::-webkit-scrollbar {
                display: none; /* Chrome, Safari y Opera */
            }

        .date-nav-btn {
            background-color: #f3f4f6;
            border: 1px solid #e5e7eb;
            border-radius: 50%;
            width: 32px;
            height: 32px;
            flex-shrink: 0;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--color-texto-secundario);
        }

        /* Estilo de cada item de fecha */
        .date-item {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 0.75rem 1rem;
            border: 2px solid var(--color-borde-suave);
            border-radius: 10px;
            text-decoration: none;
            color: var(--color-texto-secundario);
            transition: all 0.2s ease;
            flex-shrink: 0;
        }

            .date-item .day-number {
                font-size: 1.25rem;
                font-weight: 700;
                color: var(--color-texto-primario);
            }

            .date-item .day-month {
                font-size: 0.8rem;
                font-weight: 500;
            }

            .date-item:hover {
                border-color: var(--color-principal-hover);
            }

            /* Estilo del item de fecha SELECCIONADO */
            .date-item.selected {
                background-color: var(--color-principal);
                border-color: var(--color-principal);
                color: white;
            }

                .date-item.selected .day-number,
                .date-item.selected .day-month {
                    color: var(--color-texto-primario);
                }


        /* Grilla para los horarios */
        .time-slots-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(130px, 1fr));
            gap: 0.75rem;
        }

        /* Estilo de cada botón de hora */
        .time-slot-button {
            padding: 0.75rem;
            border: 2px solid var(--color-borde-suave);
            border-radius: 10px;
            text-align: center;
            font-weight: 600;
            color: var(--color-texto-primario);
            text-decoration: none;
            transition: all 0.2s ease;
        }

            .time-slot-button:hover {
                border-color: var(--color-principal-hover);
            }

            /* Estilo del botón de hora SELECCIONADO */
            .time-slot-button.selected {
                background-color: var(--color-principal);
                border-color: var(--color-principal);
                color: var(--color-texto-primario);
            }

        /* Mensaje para cuando no hay horarios */
        .no-times-message {
            text-align: center;
            padding: 2rem;
            background-color: #f8f9fa;
            border-radius: 10px;
            color: var(--color-texto-secundario);
            font-weight: 500;
        }

        /* ====== ESTILOS PARA LOS BOTONES DEL FOOTER DEL MODAL MODIFY ====== */

        /* Estilo base para el botón primario (Guardar) */
        #modalModify .modal-footer .btn-primary {
            background-color: var(--color-texto-primario); /* Color oscuro por defecto (deshabilitado) */
            color: #9ca3af; /* Texto gris claro */
            cursor: not-allowed;
            border: none;
        }

        /* Estilo para el botón primario CUANDO ESTÁ HABILITADO */
        #modalModify .modal-footer .btn-primary:not(.aspNetDisabled):not([disabled]) {
            background-color: var(--color-principal); /* Amarillo */
            color: var(--color-texto-primario); /* Texto oscuro */
            cursor: pointer;
        }

        /* Efecto hover SOLO para el botón habilitado */
        #modalModify .modal-footer .btn-primary:not(.aspNetDisabled):not([disabled]):hover {
            background-color: var(--color-principal-hover);
        }
    </style>

    <div class="dashboard-container">
        <div class="dashboard-grid">

            <!-- ====== COLUMNA PRINCIPAL ====== -->
            <main class="dashboard-main-content">
                <div class="stats-grid">
                    <%-- TARJETA 1:Especialidad --%>
                    <div class="dashboard-card stat-card">
                        <div class="stat-card-header"><i class="fa-solid fa-truck-medical"></i></div>
                        <div class="value">
                            <asp:Label ID="lblEspecialidadNombre" runat="server"></asp:Label>
                        </div>
                        <div class="label">Especialidad</div>
                    </div>
                    <%-- TARJETA 2:Sede --%>
                    <div class="dashboard-card stat-card">
                        <div class="stat-card-header"><i class="fa-solid fa-map-location-dot"></i></div>
                        <div class="value">
                            <asp:Label ID="lblSedeNombre" runat="server"></asp:Label>
                        </div>
                        <div class="label">Sede</div>
                    </div>
                    <%-- TARJETA 3: Estado Pago --%>
                    <div class="dashboard-card stat-card">
                        <div class="stat-card-header"><i class="fa-solid fa-file-invoice-dollar"></i></div>
                        <div class="value">
                            <asp:Label ID="lblEstadoPagoNombre" runat="server"></asp:Label>
                        </div>
                        <div class="label">Estado Cita</div>
                    </div>
                    <%-- TARJETA 4: Consultorio --%>
                    <div class="dashboard-card stat-card">
                        <div class="stat-card-header"><i class="fa-solid fa-hospital"></i></div>
                        <div class="value">
                            <asp:Label ID="lblConsultorioNombre" runat="server"></asp:Label>
                        </div>
                        <div class="label">Consultorio</div>
                    </div>
                </div>
                <div class="mid-section">
                    <div class="metrics-stack">
                        <%--TARJETA DE DOCTOR --%>
                        <div class="dashboard-card doctor-profile-card">

                            <%-- Imagen del Doctor --%>
                            <div class="doctor-profile-image-container">
                                <img src="/images/genericDoctor.png" class="doctor-profile-img" alt="Foto del Médico" />
                            </div>

                            <%-- Cuerpo con los detalles del Doctor --%>
                            <div class="doctor-profile-body">

                                <%-- El email ahora se muestra como una "tag" resaltada --%>
                                <div class="doctor-profile-email-tag">
                                    <asp:Label ID="lblMedicoEmail" runat="server"></asp:Label>
                                </div>

                                <div class="doctor-profile-name">
                                    <asp:Label ID="lblMedicoNombreCompleto" runat="server"></asp:Label>
                                </div>

                                <div class="doctor-profile-code">
                                    <asp:Label ID="lblMedicoCodigo" runat="server"></asp:Label>
                                </div>

                            </div>

                        </div>




                        <div class="dashboard-card payment-overview-card">

                            <div class="payment-overview-header">
                                <h3 class="payment-overview-title">Pago de la Cita</h3>
                                <asp:PlaceHolder ID="phPaymentStatusTag" runat="server"></asp:PlaceHolder>
                            </div>

                            <div class="payment-overview-body">

                                <!-- Barra 1: Monto Total -->
                                <div class="payment-bar-wrapper">
                                    <div class="payment-bar-amount">
                                        <asp:Label ID="lblAmountTotal" runat="server"></asp:Label>
                                    </div>
                                    <div class="payment-bar-background">
                                        <div id="barFillTotal" class="payment-bar-fill bar-total" runat="server"></div>
                                    </div>
                                    <div class="bar-label">Total</div>
                                </div>

                                <!-- Barra 2: Cubierto por Seguro -->
                                <div class="payment-bar-wrapper">
                                    <div class="payment-bar-amount">
                                        <asp:Label ID="lblAmountInsurance" runat="server"></asp:Label>
                                    </div>
                                    <div class="payment-bar-background">
                                        <div id="barFillInsurance" class="payment-bar-fill bar-insurance" runat="server"></div>
                                    </div>
                                    <div class="bar-label">Seguro</div>
                                </div>

                                <!-- Barra 3: Monto a Pagar (Paciente) -->
                                <div class="payment-bar-wrapper">
                                    <div class="payment-bar-amount">
                                        <asp:Label ID="lblAmountPatient" runat="server"></asp:Label>
                                    </div>
                                    <div class="payment-bar-background">
                                        <div id="barFillPatient" class="payment-bar-fill bar-patient" runat="server"></div>
                                    </div>
                                    <div class="bar-label">Yo</div>
                                </div>

                            </div>
                        </div>
                    </div>
                    <%-- BARRA DE PROGRESO --%>
                    <div class="dashboard-card timeline-stepper-card">

                        <!-- Título superior con icono y negrita -->
                        <h3 class="timeline-main-title">
                            <i class="fas fa-route"></i>
                            <!-- Icono representativo -->
                            Progreso de la Cita
                        </h3>

                        <div class="timeline-container">

                            <!-- PASO 1: En Espera -->
                            <div id="stepEspera" class="timeline-step" runat="server">
                                <div class="step-icon"><i class="fas fa-check"></i></div>
                                <div class="step-details">
                                    <div class="round-title">Etapa 1</div>
                                    <div class="step-description">En Espera</div>
                                    <%-- ID CAMBIADO DE lblDateEspera a lblDescEspera --%>
                                    <div class="step-date">
                                        <asp:Label ID="lblDescEspera" runat="server"></asp:Label>
                                    </div>
                                </div>
                                <asp:PlaceHolder ID="phTagEspera" runat="server" Visible="false"></asp:PlaceHolder>
                            </div>

                            <!-- Conector 1 -->
                            <div class="timeline-connector"></div>

                            <!-- PASO 2: En Consultorio -->
                            <div id="stepConsultorio" class="timeline-step" runat="server">
                                <div class="step-icon"><i class="fas fa-bolt"></i></div>
                                <div class="step-details">
                                    <div class="round-title">Etapa 2</div>
                                    <div class="step-description">En Consultorio</div>
                                    <div class="step-date">
                                        <asp:Label ID="lblDescConsultorio" runat="server"></asp:Label>
                                    </div>
                                </div>
                                <asp:PlaceHolder ID="phTagConsultorio" runat="server" Visible="false"></asp:PlaceHolder>
                            </div>

                            <!-- Conector 2 -->
                            <div class="timeline-connector"></div>

                            <!-- PASO 3: Atendido -->
                            <div id="stepAtendido" class="timeline-step" runat="server">
                                <div class="step-icon"><i class="fas fa-flag-checkered"></i></div>
                                <div class="step-details">
                                    <div class="round-title">Etapa 3</div>
                                    <div class="step-description">Atendido</div>
                                    <div class="step-date">
                                        <asp:Label ID="lblDescAtendido" runat="server"></asp:Label>
                                    </div>
                                </div>
                                <asp:PlaceHolder ID="phTagAtendido" runat="server" Visible="false"></asp:PlaceHolder>
                            </div>
                        </div>
                    </div>


                </div>

                <%-- TARJETA DE MOTIVO DE CONSULTA --%>
                <div class="dashboard-card consultation-info-card">
                    <h3 class="consultation-info-title">
                        <i class="fas fa-file-medical-alt fa-lg"></i>
                        <span>Motivo de Consulta</span>
                    </h3>
                    <div class="consultation-info-text">
                        <asp:Label ID="lblConsultationReason" runat="server"></asp:Label>
                    </div>
                </div>
            </main>

            <!-- ====== COLUMNA LATERAL DEL DASHBOARD ====== -->
            <aside class="dashboard-sidebar-content">

                <%-- TARJETA DEL CALENDARIO--%>
                <div class="dashboard-card calendar-widget-card">

                    <div class="calendar-header">
                        <%-- 1. Icono de calendario añadido --%>
                        <i class="far fa-calendar-alt"></i>

                        <%-- 2. El Label para el mes ahora se renderizará en negrita por el CSS --%>
                        <span class="month-year">
                            <asp:Label ID="lblCalendarMonth" runat="server"></asp:Label>
                        </span>
                    </div>

                    <div class="calendar-grid">
                        <div class="calendar-day-header">Lun</div>
                        <div class="calendar-day-header">Mar</div>
                        <div class="calendar-day-header">Mié</div>
                        <div class="calendar-day-header">Jue</div>
                        <div class="calendar-day-header">Vie</div>
                        <div class="calendar-day-header">Sáb</div>
                        <div class="calendar-day-header">Dom</div>
                    </div>
                    <div class="calendar-grid">
                        <asp:PlaceHolder ID="phCalendarDays" runat="server"></asp:PlaceHolder>
                    </div>

                    <hr class="calendar-divider" />

                    <%-- 3. La hora ahora está dentro de su propio contenedor estilizado --%>
                    <div class="calendar-time-wrapper">
                        <div class="calendar-time-display">
                            <i class="far fa-clock"></i>
                            <asp:Label ID="lblAppointmentTime" runat="server"></asp:Label>
                        </div>
                    </div>

                </div>

                <%-- TARJETA OSCURA CON CENTRO DE ACCIONES --%>
                <div class="dashboard-card actions-card">
                    <h3 class="actions-card-title">
                        <i class="fas fa-tasks"></i>
                        <span>Acciones de la Cita</span>
                    </h3>

                    <!-- Acción 1: Modificar Cita -->
                    <div class="action-item">
                        <%-- Se añade la clase "modify-button" --%>
                        <asp:LinkButton ID="btnModifyAppointment" runat="server" CssClass="action-button modify-button" OnClientClick="openModal('modalModify'); return false;">
            Modificar Cita
                        </asp:LinkButton>
                        <div id="divModifyWarning" class="action-warning-message" runat="server" visible="false">
                            <asp:Label ID="lblModifyWarning" runat="server"></asp:Label>
                        </div>
                    </div>

                    <!-- Acción 2: Cancelar Cita -->
                    <div class="action-item">
                        <%-- Se añade la clase "cancel-button" --%>
                        <asp:LinkButton ID="btnCancelAppointment" runat="server" CssClass="action-button cancel-button" OnClientClick="openModal('modalCancel'); return false;">
            Cancelar Cita
                        </asp:LinkButton>
                        <div id="divCancelWarning" class="action-warning-message" runat="server" visible="false">
                            <asp:Label ID="lblCancelWarning" runat="server"></asp:Label>
                        </div>
                    </div>
                </div>
            </aside>
        </div>
    </div>

    <!-- ======    HTML DEL MODAL DE MODIFICACIÓN   ====== -->
    <div id="modalModify" class="modal-wrapper">
    <asp:UpdatePanel ID="updModalModify" runat="server">
        <ContentTemplate>
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Modificar Cita</h5>
                    <button type="button" class="modal-close-button" onclick="closeModal('modalModify'); return false;">×</button>
                </div>
                
                <asp:HiddenField ID="hdnSelectedDate" runat="server" />
                <asp:HiddenField ID="hdnSelectedTime" runat="server" />
                <asp:HiddenField ID="hdnDateOffset" runat="server" Value="0" />
                <asp:Button ID="btnRefreshScheduler" runat="server" OnClick="btnRefreshScheduler_Click" Style="display: none;" />

                <div class="modal-body">
                    <div>
                        <h4 class="scheduler-section-title">1. Selecciona un día</h4>
                        <div class="date-selector-container">
                            <a href="javascript:void(0);" class="date-nav-btn" onclick="navigateDates(-1, '<%= hdnDateOffset.ClientID %>', '<%= btnRefreshScheduler.ClientID %>')"><i class="fas fa-chevron-left"></i></a>
                            <div class="date-selector">
                                <asp:Repeater ID="rptDates" runat="server">
                                    <ItemTemplate>
                                        <a href="javascript:void(0);"
                                            class='<%# GetDateItemCssClass(Container.DataItem) %>'
                                            onclick="selectDate('<%# ((DateTime)Container.DataItem).ToString("o") %>', '<%= hdnSelectedDate.ClientID %>', '<%= hdnSelectedTime.ClientID %>', '<%= btnRefreshScheduler.ClientID %>')">
                                            <span class="day-number"><%# ((DateTime)Container.DataItem).ToString("dd") %></span>
                                            <span class="day-month"><%# ((DateTime)Container.DataItem).ToString("MMM") %></span>
                                        </a>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </div>
                            <a href="javascript:void(0);" class="date-nav-btn" onclick="navigateDates(1, '<%= hdnDateOffset.ClientID %>', '<%= btnRefreshScheduler.ClientID %>')"><i class="fas fa-chevron-right"></i></a>
                        </div>
                    </div>
                    <asp:Panel ID="pnlTimeSlots" runat="server" Visible="false">
                        <h4 class="scheduler-section-title">2. Selecciona un horario</h4>
                        <div class="time-slots-grid">
                            <asp:Repeater ID="rptTimes" runat="server">
                                <ItemTemplate>
                                    <a href="javascript:void(0);"
                                        class='<%# GetTimeSlotCssClass(Eval("Time")) %>'
                                        onclick="selectTime('<%# Eval("Time") %>', '<%= hdnSelectedTime.ClientID %>', '<%= btnRefreshScheduler.ClientID %>')">
                                        <%# Eval("Time") %>
                                    </a>
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>
                    </asp:Panel>
                    <asp:Panel ID="pnlNoTimes" runat="server" Visible="false">
                        <div class="no-times-message">
                            <i class="far fa-frown fa-2x" style="margin-bottom: 1rem;"></i>
                            <p>No hay horarios disponibles.<br />Por favor, selecciona otra fecha.</p>
                        </div>
                    </asp:Panel>
                </div>
                
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" onclick="closeModal('modalModify'); return false;">Salir</button>
                    <asp:Button ID="btnConfirmModify" runat="server" Text="Guardar Cambios" CssClass="btn btn-primary" OnClick="btnConfirmModify_Click" />
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</div>
    <!-- ====== MODAL DE CANCELACIÓN CON NUEVO DISEÑO (ACTUALIZADO) ====== -->
    <div id="modalCancel" class="modal-wrapper">
        <div class="modal-content">
            <!-- 1. El header ahora será rojo gracias al CSS -->
            <div class="modal-header">
                <h5 class="modal-title">Confirmar Cancelación</h5>
                <button type="button" class="modal-close-button" onclick="closeModal('modalCancel'); return false;">×</button>
            </div>

            <!-- 2. El body ahora tiene un layout flex con imagen y texto -->
            <div class="modal-body">
                <!-- Imagen de advertencia -->
                <img src="/images/WarningPerson.png" alt="Icono de advertencia" class="modal-warning-image" />
                <!-- Contenedor del texto -->
                <div class="modal-text-content">
                    <p>¿Estás seguro de que deseas cancelar esta cita?</p>
                    <p>Esta acción no se puede deshacer y perderás tu horario reservado.</p>
                </div>
            </div>

            <!-- 3. El footer ahora será oscuro y los botones tendrán el efecto "salto" -->
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="closeModal('modalCancel'); return false;">No, mantener cita</button>
                <asp:Button ID="btnConfirmCancel" runat="server" Text="Sí, cancelar cita" CssClass="btn btn-danger" OnClick="btnConfirmCancel_Click" />
            </div>
        </div>
    </div>
</asp:Content>
