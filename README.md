# PazCitas — Sistema de Gestión de Citas Médicas

Sistema web para la gestión integral de citas médicas ambulatorias de una clínica, desarrollado en equipo. Permite a pacientes agendar, modificar y cancelar citas; a médicos gestionar su agenda, historial clínico y recetas; y a administradores controlar sedes, especialidades, horarios y reportes. La arquitectura separa explícitamente la lógica de negocio (Java, Jakarta EE) de la capa de presentación (ASP.NET, C#), comunicadas mediante 18 servicios web SOAP.

---

## Tecnologías Utilizadas

**Backend:** Java 21, Jakarta EE 10, JAX-WS (SOAP), JDBC, Maven (proyecto multimódulo), GlassFish 7/8

**Frontend:** C#, ASP.NET Web Forms (.NET Framework 4.8.1), Bootstrap 5

**Base de Datos:** MySQL, con procedimientos almacenados

**Reportes:** JasperReports (exportación a PDF)

**Infraestructura:** Docker (MySQL local), AWS RDS (despliegue original)

**Entornos de Desarrollo:** NetBeans, Visual Studio

---

## Características

- **Gestión multi-rol:** pacientes, médicos y administradores, cada uno con su propio portal.
- **Programación de citas sin conflictos:** validación de choques de horario contra los turnos ya asignados por médico y consultorio.
- **Modificación y cancelación de citas**, con reasignación del horario cuando una cita existente se cancela.
- **Historial médico:** notas clínicas, recetas y medicamentos vinculados a cada cita.
- **Gestión de sedes, especialidades, consultorios, turnos y seguros médicos.**
- **Reportes en PDF** generados con JasperReports.
- **Arquitectura distribuida:** 18 servicios SOAP (citas, pacientes, médicos, horarios, recetas, pagos, reportes, entre otros) consumidos por el frontend.

---

## Capturas

| Portal del paciente | Reserva de cita |
|---|---|
| ![Portal del paciente](REEMPLAZAR-URL-1) | ![Reserva de cita](REEMPLAZAR-URL-2) |

---

## El Proceso

El mayor reto fue conectar dos mundos distintos: un backend de dominio y persistencia en **Java**, organizado como proyecto Maven multimódulo (DBManager, Domain, Persistance, Business y Web), y una interfaz en **ASP.NET Web Forms**, comunicados mediante **servicios web SOAP**. Es un ejercicio real de programación distribuida, donde ambos lados deben mantenerse sincronizados sin compartir runtime ni tipos nativos.

Desarrollé el **módulo de Paciente** de punta a punta: base de datos, lógica de backend e interfaz. El punto más delicado fue la **reprogramación de citas existentes**: cuando se cancela una cita ya asignada, el sistema no puede solo marcarla como cancelada. Debe liberar ese horario y reconciliarlo con el resto de la agenda del médico, evitando huecos mal gestionados o choques con otras citas. Esta lógica vive en los procedimientos almacenados de MySQL, junto con la función que asigna pacientes a las citas disponibles.

![Modelo de base de datos](Base%20de%20Datos/DiagramaFisico_BD.png)

El otro foco deliberado fue el **diseño UX de la vista del paciente**, el usuario con menor familiaridad técnica del sistema. El portal resume en tarjetas sus citas programadas, atenciones realizadas, recetas y exámenes, y la reserva de citas se guía paso a paso (especialidad, médico, fecha, hora, sede y confirmación) en vez de pedir todos los datos en un solo formulario.

---

## Lo Que Aprendí

Aprendí a diseñar lógica de reprogramación de citas que se mantiene consistente con una agenda compartida, y a integrar dos stacks heterogéneos (Java y C#) mediante servicios SOAP.

---

## Cómo Puede Mejorarse

- **Hash de contraseñas más seguro:** hoy MySQL calcula un hash MD5 sin sal. Lo ideal es migrar a bcrypt o Argon2, calculado en el backend, y eliminar la comparación de respaldo en texto plano que conserva el procedimiento `VERIFICAR_CUENTA_GENERAL`.
- **Cifrado en tránsito:** el frontend, el backend y MySQL se comunican por HTTP y JDBC sin SSL. En producción deberían usar HTTPS y conexiones cifradas.
- **Secretos fuera del repositorio:** la configuración de base de datos (`db.properties`) guarda la llave de cifrado junto a la contraseña cifrada. Deberían pasar a variables de entorno.
- **Pruebas automatizadas:** la validación de choques de horario es la lógica más sensible del sistema y la primera candidata a cubrir con pruebas unitarias.

---

## Cómo Correr el Proyecto

### Requisitos previos
- Windows con Visual Studio (carga de trabajo "ASP.NET y desarrollo web") y .NET Framework 4.8.1
- JDK 21 y Maven
- GlassFish 7 u 8 (Jakarta EE 10)
- Docker

### 1. Base de datos

Desde la carpeta `Local/`, levanta MySQL con Docker:

```bash
docker compose up -d
```

El contenedor carga automáticamente `Local/PazCitasScript_local.sql`, que crea el esquema, las tablas, los procedimientos almacenados y los datos de prueba.

### 2. Backend (servicios SOAP)

```bash
cd BackEnd/PazCitasSolution
mvn clean install
asadmin deploy --contextroot PazCitasWeb PazCitasWeb/target/PazCitasWeb-1.0.war
```

Los servicios quedan en `http://localhost:8080/PazCitasWeb/<Servicio>`; agrega `?wsdl` para ver el contrato (por ejemplo, `CitaWS?wsdl`). La conexión a MySQL se configura en `BackEnd/PazCitasSolution/PazCitasWeb/src/main/resources/db.properties`.

### 3. Frontend

Abre `FrontEnd/FrontEnd.sln` en Visual Studio y ejecuta con **F5**. La aplicación corre en IIS Express (`http://localhost:53716/`). Las URLs de los servicios SOAP se configuran en `FrontEnd/PazCitasWeb/Web.config`.

### Usuarios de prueba

Las cuentas de demo (administrador, médico y paciente) están en `docs/credenciales-demo.txt`.

---

## Video

https://github.com/user-attachments/assets/REEMPLAZAR-CON-TU-LINK
