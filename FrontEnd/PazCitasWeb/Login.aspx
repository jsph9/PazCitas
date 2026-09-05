<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="PazCitasWA.Login" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Ingreso / Registro</title>

    <!-- Bootstrap local -->
    <link href="Content/bootstrap.min.css" rel="stylesheet" />
    <!-- Font Awesome local -->
    <link href="Content/Fonts/css/all.css" rel="stylesheet" />
    <!-- Estilo personalizado -->
    <link href="Content/LoginModern/login-modern.css" rel="stylesheet" />
</head>
<body>
    <form runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" />

        <div class="contenedor" id="contenedor">
            <input type="hidden" id="rolUsuario" value="<%= Request.QueryString["rol"] ?? "" %>" />

            <!-- Panel lateral -->
            <div class="panel" id="panel">
                <div class="panel-contenido">
                    <i class="fas fa-sign-in-alt icono-panel" id="icono-panel"></i>
                    <h2 id="titulo-panel">¡Hola, bienvenido!</h2>
                    <p id="texto-panel">¿No tienes cuenta?</p>
                    <button type="button" class="boton-panel" id="cambiar-formulario">Regístrate aquí</button>
                </div>
            </div>

            <!-- Área de formularios -->
            <div class="formulario-area" id="formularioArea">

                <!-- LOGIN -->
                <div class="formulario animado activo" id="formularioLogin">
                    <h2><i class="fas fa-user-check icono-form me-2" id="icono-login"></i>Iniciar sesión</h2>

                    

                    <label for="txtUsuario"><i class="fas fa-id-card icono-label me-2"></i>DNI:</label>
                    <asp:TextBox ID="txtUsuario" runat="server" CssClass="form-control mb-3" placeholder="Ingrese su DNI"></asp:TextBox>

                    <label for="txtClave"><i class="fas fa-lock icono-label me-2"></i>Contraseña:</label>
                    <asp:TextBox ID="txtClave" runat="server" TextMode="Password" CssClass="form-control mb-4" placeholder="Ingrese su contraseña"></asp:TextBox>
                    <asp:Label ID="lblMensaje" runat="server" CssClass="text-danger mb-2 d-block"></asp:Label>
                    <button type="button" class="btn btn-primary w-100 fw-bold" onclick="document.getElementById('<%= btnLogin.ClientID %>').click();">Iniciar sesión</button>
                    <asp:Button ID="btnLogin" runat="server" Text="HiddenLogin" OnClick="btnLogin_Click" Style="display: none;" />
                    
                </div>

                <!-- REGISTRO -->
                <div class="formulario animado" id="formularioRegistro">
                    <h2><i class="fas fa-user-plus icono-form me-2" id="icono-registro"></i>Registro</h2>

                    <label for="txtDni"><i class="fas fa-id-card icono-label me-2"></i>DNI:</label>
                    <asp:TextBox ID="txtDni" runat="server" CssClass="form-control mb-3" placeholder="Ingrese su DNI" />

                    <label for="txtNombre"><i class="fas fa-user icono-label me-2"></i>Nombre completo:</label>
                    <asp:TextBox ID="txtNombre" runat="server" CssClass="form-control mb-3" placeholder="Ingrese su nombre" />

                    <label for="txtCorreo"><i class="fas fa-envelope icono-label me-2"></i>Correo electrónico:</label>
                    <asp:TextBox ID="txtCorreo" runat="server" CssClass="form-control mb-3" placeholder="Ingrese su correo" TextMode="Email" />

                    <label for="txtDireccion"><i class="fas fa-map-marker-alt icono-label me-2"></i>Dirección:</label>
                    <asp:TextBox ID="txtDireccion" runat="server" CssClass="form-control mb-3" placeholder="Ingrese su dirección" />

                    <label for="txtTelefono"><i class="fas fa-phone icono-label me-2"></i>Teléfono:</label>
                    <asp:TextBox ID="txtTelefono" runat="server" CssClass="form-control mb-3" placeholder="Ingrese su teléfono" />

                    <label for="txtPassword"><i class="fas fa-lock icono-label me-2"></i>Contraseña:</label>
                    <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control mb-4" placeholder="Ingrese su contraseña" />

                    <button type="button" class="btn btn-success w-100 fw-bold" onclick="document.getElementById('<%= btnRegistro.ClientID %>').click();">Registrarse</button>
                    <asp:Button ID="btnRegistro" runat="server" Text="HiddenRegister" OnClick="btnRegistro_Click" Style="display: none;" />
                </div>
            </div>
        </div>
    </form>

    <!-- Scripts -->
    <script src="Scripts/jquery-3.7.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="Scripts/LoginModern/login-modern.js"></script>
</body>
</html>
