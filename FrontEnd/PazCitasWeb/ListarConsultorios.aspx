<%@ Page Title="" Language="C#" MasterPageFile="~/PazCitasAdmin.Master" AutoEventWireup="true" CodeBehind="ListarConsultorios.aspx.cs" Inherits="PazCitasWA.ListarConsultorios" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cph_Title" runat="server">
    Listar Consultorios
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cph_Scripts" runat="server">
    <style>
        /* Card contenedor y header */
        .card-doctores .card-header {
            background: linear-gradient(135deg, #3add5f 0%, #10ab33 100%);
            color: white;
        }

            .card-doctores .card-header h5 {
                font-size: 1rem;
                margin: 0;
            }

        /* Tabla */
        #gvConsultorios {
            font-size: 0.85rem;
        }

            #gvConsultorios th,
            #gvConsultorios td {
                vertical-align: middle;
                padding: 0.5rem;
            }

            #gvConsultorios thead th {
                background-color: #19692c;
                color: #fff;
                border-bottom: none;
            }

            #gvConsultorios.table-striped > tbody > tr:nth-of-type(odd) > * {
                background-color: #f7fdf7;
            }

            #gvConsultorios.table-hover tbody tr:hover > * {
                background-color: #e2f8e2;
            }

        /* Paginación */
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

        .Center {
            text-align: center;
        }
    </style>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="cph_Contenido" runat="server">
    <div class="container-fluid">
        <!-- Card que engloba la tabla -->
        <div class="card card-doctores shadow-sm mb-4">
            <!-- Header verde -->
            <div class="card-header d-flex justify-content-between align-items-center">
                <h4 class="mb-0 fw-bold">
                    <i class="fa-solid fa-door-open me-2"></i>
                    Consultorios
                </h4>
                <asp:LinkButton ID="btnRegistrar"
                    CssClass="btn btn-light fw-semibold"
                    runat="server"
                    OnClick="btnRegistrar_Click">
                    <i class="fa-solid fa-square-plus me-1"></i>
                    Registrar Consultorio
                </asp:LinkButton>
            </div>
            <!-- Cuerpo de la card -->
            <div class="card-body p-3">
                <asp:GridView ID="gvConsultorios" runat="server"
                    CssClass="table table-hover table-striped table-bordered"
                    AutoGenerateColumns="false" PageSize="7" AllowPaging="true" OnPageIndexChanging="gvConsultorios_PageIndexChanging"
                    PagerStyle-CssClass="pagination-container text-center" PagerStyle-HorizontalAlign="Center"
                    PagerSettings-Mode="Numeric" PagerSettings-Position="Bottom">
                    <Columns>
                        <asp:BoundField HeaderText="ID" DataField="idConsultorio"
                            HeaderStyle-CssClass="bg-success text-white align-middle"
                            ItemStyle-Width="10%" ItemStyle-CssClass="align-middle" />
                        <asp:BoundField HeaderText="Nombre" DataField="nombreConsultorio"
                            HeaderStyle-CssClass="bg-success text-white align-middle"
                            ItemStyle-Width="15%" ItemStyle-CssClass="align-middle" />
                        <asp:BoundField HeaderText="Piso" DataField="piso"
                            HeaderStyle-CssClass="bg-success text-white align-middle"
                            ItemStyle-Width="10%" ItemStyle-CssClass="text-wrap align-middle" />
                        <asp:BoundField HeaderText="Capacidad" DataField="capacidad"
                            HeaderStyle-CssClass="bg-success text-white align-middle"
                            ItemStyle-Width="10%" ItemStyle-CssClass="text-wrap align-middle" />
                        <asp:BoundField HeaderText="Sede" DataField="sede.nombre"
                            HeaderStyle-CssClass="bg-success text-white align-middle"
                            ItemStyle-Width="35%" ItemStyle-CssClass="text-wrap align-middle" />

                        <asp:TemplateField HeaderText="Acciones" HeaderStyle-CssClass="bg-success text-white Center"
                            ItemStyle-CssClass="Center">
                            <ItemTemplate>
                                <div class="d-flex justify-content-center gap-2">
                                    <asp:LinkButton runat="server" ID="btnModificar" CssClass="btn btn-success btn-sm"
                                        Text="<i class='fa-solid fa-pen'></i>"
                                        OnClick="btnModificar_Click"
                                        CommandArgument='<%# Eval("idConsultorio") %>' />

                                    <asp:LinkButton runat="server" ID="btnEliminar" CssClass="btn btn-danger btn-sm"
                                        Text="<i class='fa-solid fa-trash'></i>"
                                        OnClick="btnEliminar_Click"
                                        CommandArgument='<%# Eval("idConsultorio") %>' />
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
