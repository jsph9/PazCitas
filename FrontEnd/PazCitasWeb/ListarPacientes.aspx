<%@ Page Title="" Language="C#" MasterPageFile="~/PazCitasAdmin.Master" AutoEventWireup="true" CodeBehind="ListarPacientes.aspx.cs" Inherits="PazCitasWA.ListarPacientes" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cph_Title" runat="server">
    Listar Pacientes
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
        #gvPacientes {
            font-size: 0.85rem;
        }

            #gvPacientes th,
            #gvPacientes td {
                vertical-align: middle;
                padding: 0.5rem;
            }

            #gvPacientes thead th {
                background-color: #19692c;
                color: #fff;
                border-bottom: none;
            }

            #gvPacientes.table-striped > tbody > tr:nth-of-type(odd) > * {
                background-color: #f7fdf7;
            }

            #gvPacientes.table-hover tbody tr:hover > * {
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
                    <i class="fa-solid fa-user-doctor me-2"></i>
                    Pacientes
                </h4>
                <asp:LinkButton ID="btnRegistrar"
                    CssClass="btn btn-light fw-semibold"
                    runat="server"
                    OnClick="btnRegistrar_Click">
                <i class="fa-solid fa-plus me-1"></i>
                Registrar Paciente
                </asp:LinkButton>
            </div>

            <!-- Cuerpo de la card -->
            <div class="card-body p-3">
                <div class="row align-items-center mb-3">
                    <div class="col-auto">
                        <asp:Label ID="lblCadena" CssClass="form-label" runat="server" Text="Ingrese nombre, apellido o DNI"></asp:Label>
                    </div>
                    <div class="col-sm-3">
                        <asp:TextBox ID="txtCadena" CssClass="form-control" runat="server"></asp:TextBox>
                    </div>
                    <div class="col-sm-2">
                        <asp:LinkButton ID="btnBuscar" CssClass="btn btn-success"
                            runat="server" Text="<i class='fa-solid fa-magnifying-glass pe-2'></i> Buscar"
                            OnClick="btnBuscar_Click" />
                    </div>
                </div>
                <asp:GridView ID="gvPacientes" runat="server" AutoGenerateColumns="false"
                    CssClass="table table-hover table-striped table-bordered"
                    OnRowDataBound="gvPacientes_RowDataBound"
                    AllowPaging="true" PageSize="9" OnPageIndexChanging="gvPacientes_PageIndexChanging"
                    PagerStyle-CssClass="pagination-container"
                    PagerStyle-HorizontalAlign="Center">
                    <Columns>
                        <asp:BoundField HeaderText="DNI"
                            HeaderStyle-CssClass="bg-success text-white align-middle"
                            ItemStyle-Width="10%" ItemStyle-CssClass="align-middle" />
                        <asp:BoundField HeaderText="Nombre Completo"
                            HeaderStyle-CssClass="bg-success text-white align-middle"
                            ItemStyle-Width="24%" ItemStyle-CssClass="align-middle" />
                        <asp:BoundField HeaderText="E-mail"
                            HeaderStyle-CssClass="bg-success text-white align-middle"
                            ItemStyle-Width="23%" ItemStyle-CssClass="text-wrap align-middle" />
                        <asp:BoundField HeaderText="Direccion"
                            HeaderStyle-CssClass="bg-success text-white align-middle"
                            ItemStyle-Width="23%" ItemStyle-CssClass="text-wrap align-middle" />
                        <asp:BoundField HeaderText="Teléfono"
                            HeaderStyle-CssClass="bg-success text-white align-middle"
                            ItemStyle-Width="10%" ItemStyle-CssClass="text-wrap align-middle" />

                        <asp:TemplateField HeaderText="Acciones" HeaderStyle-CssClass="bg-success text-white align-middle"
                            ItemStyle-CssClass="align-middle">
                            <ItemTemplate>
                                <div class="d-flex gap-2">
                                    <asp:LinkButton runat="server" ID="btnModificar" CssClass="btn btn-success btn-sm btn-modificar"
                                        Text="<i class='fa-solid fa-pen'></i>"
                                        OnClick="btnModificar_Click"
                                        CommandArgument='<%# Eval("idUsuario") %>' />

                                    <asp:LinkButton runat="server" ID="btnEliminar" CssClass="btn btn-danger btn-sm"
                                        Text="<i class='fa-solid fa-trash'></i>"
                                        OnClick="btnEliminar_Click"
                                        CommandArgument='<%# Eval("idUsuario") %>' />
                                    <asp:LinkButton ID="btnVer" runat="server" CssClass="btn btn-primary btn-sm"
                                        Text="<i class='fa-solid fa-eye'></i>"
                                        OnClick="btnVer_Click"
                                        CommandArgument='<%# Eval("idUsuario") %>' />
                                </div>
                            </ItemTemplate>
                            <ItemStyle Width="10%" />
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </div>
</asp:Content>
