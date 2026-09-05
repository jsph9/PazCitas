<%@ Page Title="" Language="C#" MasterPageFile="~/PazCitasAdmin.Master" AutoEventWireup="true" CodeBehind="ListarTratamientos.aspx.cs" Inherits="PazCitasWA.ListarTratamientos" %>


<asp:Content ID="Content1" ContentPlaceHolderID="cph_Title" runat="server">
    Listar Medicamentos
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="cph_Scripts" runat="server">
    <style>
        .card-tratamientos .card-header {
            background: linear-gradient(135deg, #3add5f 0%, #10ab33 100%);
            color: white;
        }

            .card-tratamientos .card-header h5 {
                font-size: 1rem;
                margin: 0;
            }

        #gvTratamientos {
            font-size: 0.85rem;
        }

            #gvTratamientos th, #gvTratamientos td {
                vertical-align: middle;
                padding: 0.5rem;
            }

            #gvTratamientos thead th {
                background-color: #198754;
                color: #fff;
                border-bottom: none;
            }

            #gvTratamientos.table-striped > tbody > tr:nth-of-type(odd) > * {
                background-color: #f7fdf7;
            }

            #gvTratamientos.table-hover tbody tr:hover > * {
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

        .stock-box {
            display: inline-block;
            min-width: 60px;
            padding: 6px 12px;
            font-size: 0.9rem;
            font-weight: 600;
            text-align: center;
            color: #fff;
            border-radius: 10px;
            font-family: 'Segoe UI', sans-serif;
        }

        /* Colores de fondo según nivel */
        .bg-danger {
            background-color: #dc3545 !important;
        }

        .bg-warning {
            background-color: #ffc107 !important;
            color: #000 !important;
        }

        .bg-success {
            background-color: #198754 !important;
        }

        .Center {
            text-align: center;
        }

        .CenteredCell {
            text-align: center !important;
            vertical-align: middle !important;
        }
    </style>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="cph_Contenido" runat="server">
    <div class="container-fluid">
        <div class="card card-tratamientos shadow-sm mb-4">
            <div class="card-header d-flex justify-content-between align-items-center">
                <h4 class="mb-0 fw-bold">
                    <i class="fa-solid fa-capsules me-2"></i>
                    Medicamentos Disponibles
                </h4>
                <asp:LinkButton ID="btnRegistrar" CssClass="btn btn-light fw-semibold"
                    runat="server" OnClick="btnRegistrar_Click">
                    <i class="fa-solid fa-plus me-1"></i>
                    Registrar Tratamiento
                </asp:LinkButton>
            </div>
            <div class="card-body p-3">
                <asp:GridView ID="gvTratamientos" runat="server"
                    CssClass="table table-hover table-striped table-bordered"
                    AutoGenerateColumns="false" PageSize="7" AllowPaging="true"
                    OnPageIndexChanging="gvTratamientos_PageIndexChanging"
                    OnRowDataBound="gvTratamientos_RowDataBound"
                    PagerStyle-CssClass="pagination-container text-center"
                    PagerStyle-HorizontalAlign="Center"
                    PagerSettings-Mode="Numeric" PagerSettings-Position="Bottom">
                    <Columns>
                        <asp:BoundField HeaderText="ID" DataField="idMedicamento"
                            HeaderStyle-CssClass="bg-success text-white align-middle"
                            ItemStyle-Width="10%" ItemStyle-CssClass="align-middle" />
                        <asp:BoundField HeaderText="Nombre" DataField="nombre"
                            HeaderStyle-CssClass="bg-success text-white align-middle"
                            ItemStyle-Width="25%" ItemStyle-CssClass="align-middle" />
                        <asp:BoundField HeaderText="Presentación" DataField="presentacion"
                            HeaderStyle-CssClass="bg-success text-white align-middle"
                            ItemStyle-Width="30%" ItemStyle-CssClass="text-wrap align-middle" />
                        <asp:TemplateField HeaderText="Stock"
                            HeaderStyle-CssClass="bg-success text-white align-middle"
                            ItemStyle-Width="10%" ItemStyle-CssClass="CenteredCell">
                            <ItemTemplate>
                                <asp:Label ID="lblStock" runat="server" CssClass="stock-box" Text='<%# Eval("stock") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Acciones"
                            HeaderStyle-CssClass="bg-success text-white Center"
                            ItemStyle-CssClass="CenteredCell">
                            <ItemTemplate>
                                <div class="d-flex gap-2">
                                    <asp:LinkButton runat="server" ID="btnModificar" CssClass="btn btn-success btn-sm btn-modificar"
                                        Text="<i class='fa-solid fa-pen me-1'></i> Modificar"
                                        OnClick="btnModificar_Click"
                                        CommandArgument='<%# Eval("idMedicamento") %>' />
                                    <asp:LinkButton runat="server" ID="btnEliminar" CssClass="btn btn-danger btn-sm"
                                        Text="<i class='fa-solid fa-trash me-1'></i> Eliminar"
                                        OnClick="btnEliminar_Click"
                                        CommandArgument='<%# Eval("idMedicamento") %>' />
                                </div>
                            </ItemTemplate>
                            <ItemStyle Width="25%" />
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </div>
</asp:Content>
