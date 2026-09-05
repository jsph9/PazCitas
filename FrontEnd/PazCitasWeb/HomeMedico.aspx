<%@ Page Title="" Language="C#" MasterPageFile="~/PazCitasMedico.Master" AutoEventWireup="true" CodeBehind="HomeMedico.aspx.cs" Inherits="PazCitasWA.HomeMedico" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cph_Title" runat="server">
    Home Médico
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="cph_Scripts" runat="server">
    <%-- Puedes agregar scripts adicionales aquí si los necesitas --%>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="cph_Contenido" runat="server">
    <div class="container mt-5">
        <div class="card shadow-lg">
            <div class="card-body text-center">
                <h3 class="fw-semibold text-dark mb-3">
                    <asp:Label ID="lblNombreMedico" runat="server" />
                </h3>
                <p class="lead">
                    Desde aquí podrás gestionar las citas médicas de tus pacientes.
                </p>
            </div>
        </div>
    </div>
</asp:Content>
