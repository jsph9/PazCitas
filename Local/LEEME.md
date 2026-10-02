# PazCitas en local (sin AWS)

Lo único que usaba AWS era la base de datos MySQL en RDS. Ahora apunta a un MySQL en tu Mac.

## Qué se cambió
- `BackEnd/PazCitasSolution/PazCitasWeb/src/main/resources/db.properties` → `hostname=localhost`, contraseña local `pazcitas_local` (ya encriptada con la misma clave).
  El original está en `db.properties.aws` en la misma carpeta.
- `Local/PazCitasScript_local.sql` → copia del script con el `USE PAZCITAS_PRUEBA;` (línea 2488) corregido a `USE CLINICA_PAZCITAS;`. Sin eso no se cargaban recetas, notas ni pagos.
- `Local/docker-compose.yml` → MySQL 8 con usuario `pazadmin` / `pazcitas_local` que carga el script al arrancar.

## 1. Base de datos
Instala Docker Desktop y luego:

    cd Local
    docker compose up -d

La primera vez tarda ~30 s en cargar el script. Para empezar de cero: `docker compose down -v`.
(Sin Docker: instala MySQL 8, crea el usuario `pazadmin`@`%` con clave `pazcitas_local`, dale permisos sobre `CLINICA_PAZCITAS` y ejecuta `PazCitasScript_local.sql`.)

## 2. Backend (Java / SOAP)
Requiere JDK 21 y GlassFish 7 (Jakarta EE 10).

    cd BackEnd/PazCitasSolution
    mvn clean install
    # despliega PazCitasWeb/target/PazCitasWeb-1.0.war en GlassFish
    asadmin start-domain
    asadmin deploy --contextroot PazCitasWeb --force PazCitasWeb/target/PazCitasWeb-1.0.war

Prueba: http://localhost:8080/PazCitasWeb/CitaWS?wsdl

## 3. Frontend (ASP.NET Web Forms, .NET Framework 4.8.1)
Solo corre en Windows (Visual Studio + IIS Express). En Mac: usa una VM de Windows (Parallels / UTM / VMware Fusion) o una PC con Windows.
Si el frontend corre en una VM, cambia en `FrontEnd/PazCitasWeb/Web.config` los `localhost:8080` por la IP de tu Mac
(`ipconfig getifaddr en0`).

## Usuarios de prueba
Ver `usuarios.txt` (admin 10000001, paciente 70123456, médico 12345678).
