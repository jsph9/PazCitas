<%@ Page Title="" Language="C#" MasterPageFile="~/PazCitasAdmin.Master" AutoEventWireup="true" CodeBehind="RegistrarMedico.aspx.cs" Inherits="PazCitasWA.RegistrarMedico" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cph_Title" runat="server">
    Registrar Médico
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph_Scripts" runat="server">
    <style>
        /* Campos obligatorios - Asterisco rojo */
        .required::after {
            content: " *";
            color: #dc3545;
            font-weight: bold;
        }

        /* Estilos para mensajes de validación */
        .validation-message {
            min-height: 1.25rem;
            margin-top: 0.25rem;
        }

        .text-danger {
            font-size: 0.875rem;
        }

        /* Resaltar campos con error */
        .field-error {
            border-color: #dc3545 !important;
            box-shadow: 0 0 0 0.2rem rgba(220, 53, 69, 0.25) !important;
        }

        /* Estilos para radio buttons */
        .form-check-input.custom-radio-md {
            width: 1.3rem;
            height: 1.3rem;
            margin-top: 0.55rem;
        }

        .form-check-label.custom-radio-md {
            line-height: 2.375rem;
            padding-left: .5rem;
        }

        /* Grupo de radio buttons obligatorio */
        .radio-group-required {
            border: 1px solid #dee2e6;
            border-radius: 0.375rem;
            padding: 0.5rem;
            background-color: #f8f9fa;
        }

            .radio-group-required.field-error {
                border-color: #dc3545;
                background-color: #f8d7da;
            }

        /* Mejorar apariencia de dropdowns obligatorios */
        .form-select.field-error {
            border-color: #dc3545;
            box-shadow: 0 0 0 0.2rem rgba(220, 53, 69, 0.25);
        }

        /* Estilo para el resumen de errores */
        .validation-summary {
            background-color: #f8d7da;
            border: 1px solid #f5c6cb;
            border-radius: 0.375rem;
            padding: 1rem;
            margin-bottom: 1rem;
        }

            .validation-summary h6 {
                color: #721c24;
                margin-bottom: 0.5rem;
            }

            .validation-summary ul {
                margin-bottom: 0;
                padding-left: 1.5rem;
            }

            .validation-summary li {
                color: #721c24;
                font-size: 0.875rem;
            }
    </style>
    <script src="Scripts/PazCitasS/RegistrarMedico.js"></script>
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
                <!-- Resumen de validación -->
                <asp:ValidationSummary ID="vsResumen" runat="server"
                    CssClass="validation-summary"
                    HeaderText="<h6><i class='fa-solid fa-exclamation-triangle me-2'></i>Por favor corrija los siguientes errores:</h6>"
                    DisplayMode="BulletList"
                    ShowSummary="true" />

                <!-- Id Médico + DNI + CMP -->
                <div class="mb-3 row align-items-start">
                    <!-- Id Médico -->
                    <div class="col-4">
                        <asp:Label ID="lblIDUsuario" runat="server"
                            Text="Id Médico:" CssClass="col-form-label fw-medium pe-2" />
                        <asp:TextBox ID="txtIDUsuario" CssClass="form-control w-75" Enabled="false" runat="server" />
                        <div class="validation-message"></div>
                    </div>

                    <!-- DNI -->
                    <div class="col-4">
                        <asp:Label ID="lblDNI" runat="server"
                            Text="DNI:" CssClass="col-form-label fw-medium pe-2 required" />
                        <asp:TextBox ID="txtDNI" CssClass="form-control w-75" runat="server" MaxLength="8" />
                        <div class="validation-message">
                            <asp:RequiredFieldValidator ID="rfvDNI" runat="server"
                                ControlToValidate="txtDNI"
                                ErrorMessage="El DNI es obligatorio."
                                CssClass="text-danger small"
                                Display="Dynamic" />
                            <asp:RegularExpressionValidator ID="revDNI" runat="server"
                                ControlToValidate="txtDNI"
                                ErrorMessage="El DNI debe contener exactamente 8 números."
                                ValidationExpression="^\d{8}$"
                                CssClass="text-danger small"
                                Display="Dynamic" />
                        </div>
                    </div>

                    <!-- CMP -->
                    <div class="col-4">
                        <asp:Label ID="lblCMP" runat="server"
                            Text="CMP:" CssClass="col-form-label fw-medium pe-2 required" />
                        <asp:TextBox ID="txtCMP" CssClass="form-control w-75" runat="server" />
                        <div class="validation-message">
                            <asp:RequiredFieldValidator ID="rfvCMP" runat="server"
                                ControlToValidate="txtCMP"
                                ErrorMessage="El CMP es obligatorio."
                                CssClass="text-danger small"
                                Display="Dynamic" />
                        </div>
                    </div>
                </div>

                <!-- Nombres y Apellidos -->
                <div class="mb-3 row align-items-start">
                    <div class="col-6">
                        <asp:Label ID="lblNombre" CssClass="col-form-label fw-medium pe-2 required" runat="server" Text="Nombres:"></asp:Label>
                        <asp:TextBox ID="txtNombre" CssClass="form-control" runat="server"></asp:TextBox>
                        <div class="validation-message">
                            <asp:RequiredFieldValidator ID="rfvNombre" runat="server"
                                ControlToValidate="txtNombre"
                                ErrorMessage="El nombre es obligatorio."
                                CssClass="text-danger small"
                                Display="Dynamic" />
                            <asp:RegularExpressionValidator ID="revNombres" runat="server"
                                ControlToValidate="txtNombre"
                                ErrorMessage="Solo se permiten letras y espacios (2-50 caracteres)."
                                ValidationExpression="^[A-Za-zÁÉÍÓÚáéíóúÑñ\s]{2,50}$"
                                CssClass="text-danger small"
                                Display="Dynamic" />
                        </div>
                    </div>

                    <div class="col-3">
                        <asp:Label ID="lblPaterno" CssClass="col-form-label fw-medium pe-2 required" runat="server" Text="Apellido Paterno:"></asp:Label>
                        <asp:TextBox ID="txtPaterno" CssClass="form-control" runat="server"></asp:TextBox>
                        <div class="validation-message">
                            <asp:RequiredFieldValidator ID="rfvPaterno" runat="server"
                                ControlToValidate="txtPaterno"
                                ErrorMessage="El apellido paterno es obligatorio."
                                CssClass="text-danger small"
                                Display="Dynamic" />
                            <asp:RegularExpressionValidator ID="revPaterno" runat="server"
                                ControlToValidate="txtPaterno"
                                ErrorMessage="Solo se permiten letras y espacios."
                                ValidationExpression="^[A-Za-zÁÉÍÓÚáéíóúÑñ\s]{2,50}$"
                                CssClass="text-danger small"
                                Display="Dynamic" />
                        </div>
                    </div>

                    <div class="col-3">
                        <asp:Label ID="lblMaterno" CssClass="col-form-label fw-medium pe-2 required" runat="server" Text="Apellido Materno:"></asp:Label>
                        <asp:TextBox ID="txtMaterno" CssClass="form-control" runat="server"></asp:TextBox>
                        <div class="validation-message">
                            <asp:RequiredFieldValidator ID="rfvMaterno" runat="server"
                                ControlToValidate="txtMaterno"
                                ErrorMessage="El apellido materno es obligatorio."
                                CssClass="text-danger small"
                                Display="Dynamic" />
                            <asp:RegularExpressionValidator ID="revMaterno" runat="server"
                                ControlToValidate="txtMaterno"
                                ErrorMessage="Solo se permiten letras y espacios."
                                ValidationExpression="^[A-Za-zÁÉÍÓÚáéíóúÑñ\s]{2,50}$"
                                CssClass="text-danger small"
                                Display="Dynamic" />
                        </div>
                    </div>
                </div>

                <!-- Fecha, Género y Email -->
                <div class="mb-3 row align-items-start">
                    <div class="col-4">
                        <asp:Label ID="lblFechaNacimiento" CssClass="col-form-label fw-medium pe-2 required" runat="server" Text="Fecha de nacimiento:"></asp:Label>
                        <input id="dtpFechaNacimiento" runat="server" class="form-control" type="date" />
                        <div class="validation-message">
                            <asp:RequiredFieldValidator ID="rfvFechaNacimiento" runat="server"
                                ControlToValidate="dtpFechaNacimiento"
                                ErrorMessage="La fecha de nacimiento es obligatoria."
                                CssClass="text-danger small"
                                Display="Dynamic" />
                            <asp:RangeValidator
                                ID="rvFechaNacimiento"
                                runat="server"
                                ControlToValidate="dtpFechaNacimiento"
                                MinimumValue="1940-01-01"
                                Type="Date"
                                ErrorMessage="La fecha debe estar entre 01/01/1940 y hoy."
                                CssClass="text-danger small"
                                Display="Dynamic" />
                        </div>
                    </div>

                    <div class="col-3">
                        <asp:Label ID="lblGenero" runat="server"
                            Text="Género:" CssClass="col-form-label fw-medium pe-2 required" />
                        <div class="radio-group-required">
                            <div class="form-check form-check-inline">
                                <input runat="server" id="rbMasculino"
                                    type="radio" name="genero" value="M"
                                    class="form-check-input custom-radio-md" />
                                <label runat="server"
                                    for="cphContenido_rbMasculino"
                                    class="form-check-label custom-radio-md">
                                    Masculino</label>
                            </div>
                            <div class="form-check form-check-inline">
                                <input runat="server" id="rbFemenino"
                                    type="radio" name="genero" value="F"
                                    class="form-check-input custom-radio-md" />
                                <label runat="server"
                                    for="cphContenido_rbFemenino"
                                    class="form-check-label custom-radio-md">
                                    Femenino</label>
                            </div>
                        </div>
                        <div class="validation-message">
                            <asp:CustomValidator ID="cvGenero" runat="server"
                                ErrorMessage="Debe seleccionar un género."
                                CssClass="text-danger small"
                                Display="Dynamic"
                                ClientValidationFunction="validarGenero"
                                OnServerValidate="cvGenero_ServerValidate" />
                        </div>
                    </div>

                    <div class="col-5">
                        <asp:Label ID="lblEmail" CssClass="col-form-label fw-medium pe-2 required" runat="server" Text="E-mail:"></asp:Label>
                        <asp:TextBox ID="txtEmail" CssClass="form-control" runat="server" TextMode="Email"></asp:TextBox>
                        <div class="validation-message">
                            <asp:RequiredFieldValidator ID="rfvEmail" runat="server"
                                ControlToValidate="txtEmail"
                                ErrorMessage="El email es obligatorio."
                                CssClass="text-danger small"
                                Display="Dynamic" />
                            <asp:RegularExpressionValidator ID="revEmail" runat="server"
                                ControlToValidate="txtEmail"
                                ErrorMessage="Ingrese un email válido."
                                ValidationExpression="^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"
                                CssClass="text-danger small"
                                Display="Dynamic" />
                        </div>
                    </div>
                </div>

                <!-- Sede + Consultorio + Especialidad -->
                <div class="mb-3 row align-items-start">
                    <!-- Sede -->
                    <div class="col-4">
                        <asp:Label ID="lblSede" runat="server"
                            Text="Sede:" CssClass="col-form-label fw-medium pe-2 required" />
                        <asp:DropDownList ID="ddlSede" runat="server" CssClass="form-select" AutoPostBack="true"
                            OnSelectedIndexChanged="ddlSede_SelectedIndexChanged">
                            <asp:ListItem Value="">-- Seleccione una sede --</asp:ListItem>
                        </asp:DropDownList>
                        <div class="validation-message">
                            <asp:RequiredFieldValidator ID="rfvSede" runat="server"
                                ControlToValidate="ddlSede"
                                InitialValue=""
                                ErrorMessage="Debe seleccionar una sede."
                                CssClass="text-danger small"
                                Display="Dynamic" />
                        </div>
                    </div>

                    <!-- Consultorio -->
                    <div class="col-4">
                        <asp:Label ID="lblConsultorio" runat="server"
                            Text="Consultorio:" CssClass="col-form-label fw-medium pe-2 required" />
                        <asp:DropDownList ID="ddlConsultorio" runat="server" CssClass="form-select">
                            <asp:ListItem Value="">-- Seleccione un consultorio --</asp:ListItem>
                        </asp:DropDownList>
                        <div class="validation-message">
                            <asp:RequiredFieldValidator ID="rfvConsultorio" runat="server"
                                ControlToValidate="ddlConsultorio"
                                InitialValue=""
                                ErrorMessage="Debe seleccionar un consultorio."
                                CssClass="text-danger small"
                                Display="Dynamic" />
                        </div>
                    </div>

                    <!-- Especialidad -->
                    <div class="col-4">
                        <asp:Label ID="lblEspecialidad" runat="server"
                            Text="Especialidad:" CssClass="col-form-label fw-medium pe-2 required" />
                        <asp:DropDownList ID="ddlEspecialidad" runat="server" CssClass="form-select">
                            <asp:ListItem Value="">-- Seleccione una especialidad --</asp:ListItem>
                        </asp:DropDownList>
                        <div class="validation-message">
                            <asp:RequiredFieldValidator ID="rfvEspecialidad" runat="server"
                                ControlToValidate="ddlEspecialidad"
                                InitialValue=""
                                ErrorMessage="Debe seleccionar una especialidad."
                                CssClass="text-danger small"
                                Display="Dynamic" />
                        </div>
                    </div>
                </div>

                <!-- Username y Password -->
                <div class="mb-3 row align-items-start">
                    <div class="col-6">
                        <asp:Label ID="lblUsername" CssClass="col-form-label fw-medium pe-2 required" runat="server" Text="Nombre de usuario:"></asp:Label>
                        <asp:TextBox ID="txtUsername" CssClass="form-control" runat="server"></asp:TextBox>
                        <div class="validation-message">
                            <asp:RequiredFieldValidator ID="rfvUsername" runat="server"
                                ControlToValidate="txtUsername"
                                ErrorMessage="El nombre de usuario es obligatorio."
                                CssClass="text-danger small"
                                Display="Dynamic" />
                            <asp:RegularExpressionValidator ID="revUsuario" runat="server"
                                ControlToValidate="txtUsername"
                                ValidationExpression="^[a-zA-Z0-9_]{5,15}$"
                                ErrorMessage="El nombre de usuario debe contener entre 5 y 15 caracteres (letras, números y guiones bajos)."
                                CssClass="text-danger small"
                                Display="Dynamic" />
                        </div>
                    </div>

                    <div class="col-6">
                        <asp:Label ID="lblPassword" CssClass="col-form-label fw-medium pe-2 required" runat="server" Text="Contraseña:"></asp:Label>
                        <asp:TextBox ID="txtPassword" CssClass="form-control" runat="server" TextMode="Password"></asp:TextBox>
                        <div class="validation-message">
                            <asp:RequiredFieldValidator ID="rfvPassword" runat="server"
                                ControlToValidate="txtPassword"
                                ErrorMessage="La contraseña es obligatoria."
                                CssClass="text-danger small"
                                Display="Dynamic" />
                            <asp:RegularExpressionValidator ID="revPassword" runat="server"
                                ControlToValidate="txtPassword"
                                ValidationExpression="^[A-Za-z0-9]{8,}$"
                                ErrorMessage="La contraseña debe tener al menos 8 caracteres (letras y números)."
                                CssClass="text-danger small"
                                Display="Dynamic" />
                        </div>
                    </div>
                </div>

            </div>
            <div class="card-footer clearfix">
                <asp:LinkButton ID="btnRegresar" runat="server" CausesValidation="false"
                    Text="<i class='fa-solid fa-rotate-left'></i> Regresar"
                    CssClass="float-start btn btn-secondary" OnClick="btnRegresar_Click" />
                <asp:LinkButton ID="btnGuardar" CssClass="float-end btn btn-success" runat="server"
                    Text="<i class='fa-solid fa-floppy-disk pe-2'></i> Guardar" OnClick="btnGuardar_Click" />
            </div>
        </div>
    </div>

    <!-- Modal de Error -->
    <div class="modal fade" id="errorModal" tabindex="-1" aria-labelledby="errorModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header bg-danger text-white">
                    <h5 class="modal-title" id="errorModalLabel">
                        <i class="bi bi-exclamation-triangle-fill me-2"></i>Mensaje de Error
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <asp:Label ID="lblMensajeError" runat="server" Text="Mensaje de ejemplo..." CssClass="form-text text-danger"></asp:Label>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Validación del lado cliente para género
        function validarGenero(sender, args) {
            var masculino = document.getElementById('<%= rbMasculino.ClientID %>');
            var femenino = document.getElementById('<%= rbFemenino.ClientID %>');
            args.IsValid = masculino.checked || femenino.checked;
        }

        // Resaltar campos con errores
        function resaltarCamposConError() {
            // Remover clases de error existentes
            document.querySelectorAll('.field-error').forEach(function (element) {
                element.classList.remove('field-error');
            });

            // Agregar clase de error a campos que tienen validadores activos
            document.querySelectorAll('span[style*="color:Red"], span.text-danger').forEach(function (validator) {
                if (validator.style.display !== 'none' && validator.innerHTML.trim() !== '') {
                    var fieldId = validator.getAttribute('controltovalidate');
                    if (fieldId) {
                        var field = document.getElementById(fieldId);
                        if (field) {
                            field.classList.add('field-error');
                        }
                    }
                }
            });
        }

        // Ejecutar al cargar la página y después de validaciones
        document.addEventListener('DOMContentLoaded', function () {
            // Configurar validación en tiempo real
            setTimeout(resaltarCamposConError, 100);
        });

        // Hook para después de validaciones del lado cliente
        if (typeof (Page_ClientValidate) === 'function') {
            var originalValidate = Page_ClientValidate;
            Page_ClientValidate = function (validationGroup) {
                var result = originalValidate(validationGroup);
                setTimeout(resaltarCamposConError, 100);
                return result;
            };
        }
    </script>
</asp:Content>
