document.addEventListener("DOMContentLoaded", () => {
    const contenedor = document.getElementById("contenedor");
    const panel = document.getElementById("panel");
    const cambiarBtn = document.getElementById("cambiar-formulario");

    const tituloPanel = document.getElementById("titulo-panel");
    const textoPanel = document.getElementById("texto-panel");
    const iconoPanel = document.getElementById("icono-panel");
    const iconoLogin = document.getElementById("icono-login");

    const formularioLogin = document.getElementById("formularioLogin");
    const formularioRegistro = document.getElementById("formularioRegistro");

    const rol = document.getElementById("rolUsuario")?.value;

    let enLogin = true;
    let iconoOriginal = "";

    // Configuración visual por rol
    if (rol === "paciente") {
        document.body.classList.add("fondo-paciente");
        panel.classList.add("paciente");
        iconoPanel.className = "fas fa-user-injured icono-panel";
        iconoLogin.classList.add("text-warning");
        cambiarBtn.classList.add("btn", "btn-warning");
        tituloPanel.textContent = "¡Hola Paciente!";
        textoPanel.textContent = "¿Aún no estás registrado?";
        iconoOriginal = "fas fa-user-injured icono-panel";
    } else if (rol === "medico") {
        document.body.classList.add("fondo-medico");
        panel.classList.add("medico");
        iconoPanel.className = "fas fa-user-md icono-panel";
        iconoLogin.classList.add("text-primary");
        cambiarBtn.style.display = "none";
        formularioRegistro.style.display = "none";
        tituloPanel.textContent = "¡Bienvenido Médico!";
        textoPanel.textContent = "Accede con tu cuenta";
        iconoOriginal = "fas fa-user-md icono-panel";
    } else if (rol === "admin") {
        document.body.classList.add("fondo-admin");
        panel.classList.add("admin");
        iconoPanel.className = "fas fa-cogs icono-panel";
        iconoLogin.classList.add("text-success");
        cambiarBtn.style.display = "none";
        formularioRegistro.style.display = "none";
        tituloPanel.textContent = "Panel del Administrador";
        textoPanel.textContent = "Ingresa tus credenciales";
        iconoOriginal = "fas fa-cogs icono-panel";
    }

    function actualizarPanel() {
        if (enLogin) {
            cambiarBtn.textContent = "Regístrate aquí";
            iconoPanel.className = iconoOriginal;
        } else {
            cambiarBtn.textContent = "Iniciar sesión";
            iconoPanel.className = "fas fa-user-plus icono-panel";
        }
    }

    function cambiarFormulario() {
        const visibleForm = enLogin ? formularioLogin : formularioRegistro;
        const hiddenForm = enLogin ? formularioRegistro : formularioLogin;

        visibleForm.classList.remove("activo");
        contenedor.classList.toggle("active");
        enLogin = !enLogin;
        actualizarPanel();

        setTimeout(() => {
            hiddenForm.classList.add("activo");
        }, 500);
    }

    if (rol === "paciente") {
        cambiarBtn.addEventListener("click", cambiarFormulario);
    }

    formularioLogin.classList.add("activo");
    actualizarPanel();
});
