<%@ Page Title="" Language="C#" MasterPageFile="~/PazCitasAdmin.Master" AutoEventWireup="true" CodeBehind="RegistrarSeguro.aspx.cs" Inherits="PazCitasWA.RegistrarSeguro" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cph_Title" runat="server">
    Registrar Seguro
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph_Scripts" runat="server">
    <style>
        /* Dropdown “TipoSeguro” */
        #ddlTipo.form-select {
            text-align: center; /* centra el texto */
            transition: border-color .2s, box-shadow .2s;
            border: 2px solid #198754; /* verde corporativo */
            border-radius: 0.5rem; /* esquinas más suaves */
        }

        /* cambia el borde al enfocar */
        #ddlTipo:focus {
            border-color: #157347;
            box-shadow: 0 0 0 .25rem rgba(25, 135, 84, .25);
        }
    </style>
    <script src="Scripts/PazCitasS/RegistrarSeguro.js"></script>
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
                    <asp:Label ID="lblIDSeguro" CssClass="col-form-label col-sm-auto pe-sm-2 fw-bold" runat="server" Text="ID Seguro:"></asp:Label>
                    <div class="col-sm-2">
                        <asp:TextBox ID="txtIDSeguro" CssClass="form-control" Enabled="false" runat="server"></asp:TextBox>
                    </div>
                </div>
                <div class="mb-3 row align-items-center">
                    <asp:Label ID="lblNombreSeguro" CssClass="col-form-label col-sm-auto pe-sm-2 fw-bold" runat="server" Text="Nombre:"></asp:Label>
                    <div class="col-sm-6">
                        <asp:TextBox ID="txtNombreSeguro" CssClass="form-control" runat="server"></asp:TextBox>
                        <asp:RegularExpressionValidator
                            ID="revNombres" runat="server" ControlToValidate="txtNombreSeguro"
                            ErrorMessage="Solo se permiten letras y espacios."
                            ValidationExpression="^[A-Za-zÁÉÍÓÚáéíóúÑñ\s]{2,50}$"
                            CssClass="text-danger small"
                            Display="Dynamic" />
                    </div>
                </div>
                <div class="mb-3 row align-items-center">
                    <asp:Label ID="lblTipoSeguro" CssClass="col-form-label col-sm-auto pe-sm-2 fw-bold" runat="server" Text="Tipo de Seguro:"></asp:Label>
                    <div class="col-sm-6">
                        <asp:DropDownList ID="ddlTipo" runat="server" CssClass="form-select"></asp:DropDownList>
                    </div>
                </div>
                <div class="mb-3 row align-items-start">
                    <asp:Label ID="lblPorcentCobertura" CssClass="col-form-label col-sm-auto pe-sm-2 fw-bold " runat="server" Text="Porcentaje de Cobertura:"></asp:Label>
                    <div class="col-sm-8">
                        <asp:TextBox ID="txtlblPorcentCobertura" CssClass="form-control" runat="server"></asp:TextBox>
                    </div>
                </div>
                <div class="mb-3 row align-items-start">
                    <asp:Label ID="lblVigencia" CssClass="col-form-label col-sm-auto pe-sm-2 fw-bold " runat="server" Text="Vigente hasta:"></asp:Label>
                    <div class="col-sm-8">
                        <input id="dtpVigencia" class="form-control" type="date" runat="server" />
                        <asp:RangeValidator
                            ID="rvVigencia"
                            runat="server"
                            ControlToValidate="dtpVigencia"
                            MinimumValue="2025-01-01"
                            MaximumValue="2030-12-01"
                            Type="Date"
                            ErrorMessage="La fecha debe estar entre 2025 y 2030."
                            CssClass="text-danger small"
                            Display="Dynamic" />
                    </div>
                </div>
            </div>
            <div class="card-footer clearfix">
                <asp:LinkButton ID="btnRegresar" runat="server" Text="<i class='fa-solid fa-rotate-left'></i> Regresar" CssClass="float-start btn btn-secondary" OnClick="btnRegresar_Click" />
                <asp:LinkButton ID="btnGuardar" CssClass="float-end btn btn-success" runat="server" Text="<i class='fa-solid fa-floppy-disk pe-2'></i> Guardar" OnClick="btnGuardar_Click" />
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
</asp:Content>
