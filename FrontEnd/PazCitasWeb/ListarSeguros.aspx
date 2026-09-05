<%@ Page Title="" Language="C#" MasterPageFile="~/PazCitasAdmin.Master" AutoEventWireup="true" CodeBehind="ListarSeguros.aspx.cs" Inherits="PazCitasWA.ListarSeguros" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cph_Title" runat="server">
    Seguros Médicos
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="cph_Scripts" runat="server">
    <style>
        .card-seguros .card-header {
            background: linear-gradient(135deg, #3add5f 0%, #10ab33 100%);
            color: white;
        }

            .card-seguros .card-header h5 {
                font-size: 1rem;
                margin: 0;
            }

        #gvSeguros {
            font-size: 0.85rem;
        }

            #gvSeguros th, #gvSeguros td {
                vertical-align: middle;
                padding: 0.5rem;
            }

            #gvSeguros thead th {
                background-color: #198754;
                color: #fff;
                border-bottom: none;
            }

            #gvSeguros.table-striped > tbody > tr:nth-of-type(odd) > * {
                background-color: #f7fdf7;
            }

            #gvSeguros.table-hover tbody tr:hover > * {
                background-color: #e2f8e2;
            }

        .pagination-container {
            text-align: center;
            margin-top: 1rem;
        }

            .pagination-container a,
            .pagination-container span {
                display: inline-block;
                padding: 6px 12px;
                margin: 0 3px;
                border-radius: 5px;
                border: 1px solid #ccc;
                background-color: #f4f4f4;
                color: #333;
                text-decoration: none;
            }

            .pagination-container span {
                background-color: #198754;
                color: white;
                font-weight: bold;
                border-color: #198754;
            }

            .pagination-container a:hover {
                background-color: #d9ffd9;
            }

        .btn-modificar {
            background: #18c35a;
            border-color: #18c35a;
            color: #fff;
        }

            .btn-modificar:hover,
            .btn-modificar:focus {
                background: #1aa85a;
                border-color: #1aa85a;
            }
    </style>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="cph_Contenido" runat="server">
    <div class="container-fluid">
        <div class="card card-seguros shadow-sm mb-4">
            <div class="card-header d-flex justify-content-between align-items-center">
                <h4 class="mb-0 fw-bold">
                    <i class="fa-solid fa-briefcase-medical me-2"></i>
                    Seguros Médicos
                </h4>
                <asp:LinkButton ID="btnRegistrar" CssClass="btn btn-light fw-semibold"
                    runat="server" OnClick="btnRegistrar_Click">
                    <i class="fa-solid fa-plus me-1"></i>
                    Registrar Seguro
                </asp:LinkButton>
            </div>
            <div class="card-body p-3">
                <asp:GridView ID="gvSeguros" runat="server"
                    CssClass="table table-hover table-striped table-bordered"
                    AutoGenerateColumns="false" PageSize="7" AllowPaging="true"
                    OnPageIndexChanging="gvSeguros_PageIndexChanging"
                    PagerStyle-CssClass="pagination-container text-center"
                    PagerStyle-HorizontalAlign="Center"
                    PagerSettings-Mode="Numeric" PagerSettings-Position="Bottom">
                    <Columns>
                        <asp:BoundField HeaderText="ID" DataField="idSeguro"
                            HeaderStyle-CssClass="bg-success text-white align-middle"
                            ItemStyle-Width="10%" ItemStyle-CssClass="align-middle" />
                        <asp:BoundField HeaderText="Nombre" DataField="nombreSeguro"
                            HeaderStyle-CssClass="bg-success text-white align-middle"
                            ItemStyle-Width="25%" ItemStyle-CssClass="align-middle" />
                        <asp:BoundField HeaderText="Tipo" DataField="tipo"
                            HeaderStyle-CssClass="bg-success text-white align-middle"
                            ItemStyle-Width="10%" ItemStyle-CssClass="text-wrap align-middle" />
                        <asp:BoundField HeaderText="% Cobertura" DataField="porcentajeCobertura"
                            DataFormatString="{0:0.00} %" HtmlEncode="false"
                            HeaderStyle-CssClass="bg-success text-white align-middle"
                            ItemStyle-Width="15%" ItemStyle-CssClass="text-wrap align-middle" />
                        <asp:BoundField HeaderText="Vigencia" DataField="vigencia"
                            DataFormatString="{0:dd-MM-yyyy}" HtmlEncode="false"
                            HeaderStyle-CssClass="bg-success text-white align-middle"
                            ItemStyle-Width="20%" ItemStyle-CssClass="text-wrap align-middle" />
                        <asp:TemplateField HeaderText="Acciones"
                            HeaderStyle-CssClass="bg-success text-white align-middle"
                            ItemStyle-CssClass="align-middle">
                            <ItemTemplate>
                                <div class="d-flex gap-2">
                                    <asp:LinkButton runat="server" ID="btnModificar" CssClass="btn btn-success btn-sm btn-modificar"
                                        Text="<i class='fa-solid fa-pen me-1'></i> Modificar"
                                        OnClick="btnModificar_Click"
                                        CommandArgument='<%# Eval("idSeguro") %>' />
                                    <asp:LinkButton runat="server" ID="btnEliminar" CssClass="btn btn-danger btn-sm"
                                        Text="<i class='fa-solid fa-trash me-1'></i> Eliminar"
                                        OnClick="btnEliminar_Click"
                                        CommandArgument='<%# Eval("idSeguro") %>' />
                                </div>
                            </ItemTemplate>
                            <ItemStyle Width="20%" />
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </div>
</asp:Content>
