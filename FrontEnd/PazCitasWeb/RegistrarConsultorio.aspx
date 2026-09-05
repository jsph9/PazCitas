<%@ Page Title="" Language="C#" MasterPageFile="~/PazCitasAdmin.Master" AutoEventWireup="true" CodeBehind="RegistrarConsultorio.aspx.cs" Inherits="PazCitasWA.RegistrarConsultorio" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cph_Title" runat="server">
    Registrar Consultorio
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph_Scripts" runat="server">
    <script src="Scripts/PazCitasS/RegistrarConsultorio.js"></script>
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
                    <asp:Label ID="lblIDConsultorio" CssClass="col-form-label col-sm-auto pe-sm-2 fw-bold" runat="server" Text="ID de Consultorio:"></asp:Label>
                    <div class="col-sm-2">
                        <asp:TextBox ID="txtIDConsultorio" CssClass="form-control" Enabled="false" runat="server"></asp:TextBox>
                    </div>
                </div>
                <div class="mb-3 row align-items-center">
                    <asp:Label ID="lblNombre" CssClass="col-form-label col-sm-auto pe-sm-2 fw-bold" runat="server" Text="Nombre:"></asp:Label>
                    <div class="col-sm-6">
                        <asp:TextBox ID="txtNombre" CssClass="form-control" runat="server"></asp:TextBox>
                    </div>
                </div>
                <div class="mb-3 row align-items-start">
                    <asp:Label ID="lblPiso" CssClass="col-form-label col-sm-auto pe-sm-2 fw-bold " runat="server" Text="Nº Piso:"></asp:Label>
                    <div class="col-sm-8">
                        <asp:TextBox ID="txtPiso" CssClass="form-control" runat="server"></asp:TextBox>
                    </div>
                </div>
                <div class="mb-3 row align-items-start">
                    <asp:Label ID="lblCapacidad" CssClass="col-form-label col-sm-auto pe-sm-2 fw-bold " runat="server" Text="Capacidad:"></asp:Label>
                    <div class="col-sm-8">
                        <asp:TextBox ID="txtCapacidad" CssClass="form-control" runat="server"></asp:TextBox>
                    </div>
                </div>
                <div class="mb-3 row align-items-center">
                    <asp:Label ID="lblSede" CssClass="col-form-label col-sm-auto pe-sm-2 fw-bold" runat="server" Text="Sede:"></asp:Label>
                    <div class="col-sm-6">
                        <asp:DropDownList ID="ddlSede" runat="server" CssClass="form-select"></asp:DropDownList>
                    </div>
                </div>
            </div>
            <div class="card-footer clearfix">
                <asp:LinkButton ID="btnRegresar" runat="server" Text="<i class='fa-solid fa-rotate-left'></i> Regresar" CssClass="float-start btn btn-secondary" OnClick="btnRegresar_Click" />
                <asp:LinkButton ID="btnGuardar" CssClass="float-end btn btn-success" runat="server" Text="<i class='fa-solid fa-floppy-disk pe-2'></i> Guardar" OnClick="btnGuardar_Click" />
            </div>
        </div>
    </div>
    <!-- Modal de error-->
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
