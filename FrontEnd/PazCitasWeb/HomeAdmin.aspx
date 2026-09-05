<%@ Page Title="" Language="C#" MasterPageFile="~/PazCitasAdmin.Master" AutoEventWireup="true" CodeBehind="HomeAdmin.aspx.cs" Inherits="PazCitasWA.HomeAdmin" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cph_Title" runat="server">
    Clínica Paz Citas
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph_Scripts" runat="server">
    <style>
        .contenido-principal {
            background-color: rgb(255, 255, 255, 0.56);
            padding: 2rem;
            border-radius: 10px;
            max-width: 800px;
            margin: 4rem auto;
            text-align: center;
        }
    </style>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="cph_Contenido" runat="server">
    <div style="background-image: url('/Images/imagen-clinica.JPG'); 
                background-size: cover;
                background-position: center;
                background-repeat: no-repeat;
                background-attachment: fixed;
                min-height: 90vh;
                padding: 3rem;">
        <div class="contenido-principal">
            <h2>Clínica Paz Citas</h2>
            <asp:Label ID="lblBienvenida" runat="server" CssClass="h4 text-success fw-semibold"></asp:Label>
        </div>
    </div>
</asp:Content>
