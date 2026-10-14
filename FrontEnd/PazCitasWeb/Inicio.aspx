<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Inicio.aspx.cs" Inherits="PazCitasWA.Inicio" %>

<!DOCTYPE html>
<html lang="es">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Inicio - PazCitas</title>

    <!-- Bootstrap CSS -->
    <link href="Content/bootstrap-grid.min.css" rel="stylesheet" />
    <link href="Content/bootstrap-reboot.min.css" rel="stylesheet" />
    <!-- Font Awesome -->
    <link href="Content/Fonts/css/all.min.css" rel="stylesheet" />
    <!-- jQuery -->
    <script src="Scripts/jquery-3.7.1.min.js"></script>
    <!-- Bootstrap JS -->
    <script src="Scripts/bootstrap.bundle.min.js"></script>

    <style>
        body {
            /*Foto de mi lord*/
            /*

                background-image: url('Images/PazCantante.PNG');
                background-size: cover;
                background-position: center;
                background-repeat: no-repeat;
                background-attachment: fixed; 
            */
        }

        .titulo-global {
            text-align: center;
            padding: 60px 20px 20px;
        }

            .titulo-global h1 {
                color: #0d6efd;
                font-weight: bold;
                font-size: 42px;
                margin-bottom: 10px;
            }

            .titulo-global p {
                color: #6c757d;
                font-size: 18px;
                margin-bottom: 0;
            }

        .role-card {
            border: 1px solid #eee;
            border-radius: 16px;
            padding: 30px;
            text-align: center;
            box-shadow: 0 4px 10px rgba(0,0,0,0.05);
            background-color: #fff;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

            .role-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 8px 20px rgba(0,0,0,0.1);
            }

        .role-icon {
            font-size: 50px;
            margin-bottom: 15px;
        }

        .btn-role {
            margin-top: 15px;
            padding: 10px 25px;
            border: none;
            border-radius: 10px;
            color: #fff;
            font-weight: bold;
            transition: background 0.3s;
            cursor: pointer;
        }

        .btn-pacientes {
            background-color: #fbbc04;
        }

        .btn-personal {
            background-color: #4285f4;
        }

        .btn-admin {
            background-color: #34a853;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <!-- TÍTULO CENTRADO EN TODA LA PANTALLA -->
        <div class="titulo-global">
            <h1>Bienvenido a PazCitas</h1>
            <p>Seleccione su tipo de usuario</p>
        </div>

        <!-- TARJETAS CENTRADAS -->
        <div class="container">
            <div class="row justify-content-center g-4">
                <!-- Paciente -->
                <div class="col-12 col-md-6 col-lg-4 px-3 mb-4">
                    <div class="role-card">
                        <div class="role-icon"><i class="fas fa-user-injured" style="color: #fbbc04;"></i></div>
                        <h4>Paciente</h4>
                        <p>Consulta tus citas médicas, historial y datos personales.</p>
                        <asp:Button ID="BtnPacientes" runat="server" CssClass="btn-role btn-pacientes" Text="Ingresar como paciente" OnClick="BtnPacientes_Click" />
                    </div>
                </div>

                <!-- Personal Médico -->
                <div class="col-12 col-md-6 col-lg-4 px-3 mb-4">
                    <div class="role-card">
                        <div class="role-icon"><i class="fas fa-user-md" style="color: #4285f4;"></i></div>
                        <h4>Personal Médico</h4>
                        <p>Revisa tus citas agendadas, pacientes y turnos asignados.</p>
                        <asp:Button ID="BtnPersonal" runat="server" CssClass="btn-role btn-personal" Text="Ingresar como personal" OnClick="BtnPersonal_Click" />
                    </div>
                </div>

                <!-- Administración -->
                <div class="col-12 col-md-6 col-lg-4 px-3 mb-4">
                    <div class="role-card">
                        <div class="role-icon"><i class="fas fa-cogs" style="color: #34a853;"></i></div>
                        <h4>Administración</h4>
                        <p>Administra usuarios, citas, horarios y configuraciones del sistema.</p>
                        <asp:Button ID="BtnAdmin" runat="server" CssClass="btn-role btn-admin" Text="Panel de administración" OnClick="BtnAdmin_Click" />
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
