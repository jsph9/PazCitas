using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Net.Mail;
using System.Net;
using System.Web;

namespace PazCitasWA.ServiciosEmail
{
    public class ServicioEmail
    {
        /// <summary>
        /// Método principal para enviar correos electrónicos.
        /// </summary>
        /// <param name="destinatario">El correo del paciente.</param>
        /// <param name="asunto">El asunto del correo.</param>
        /// <param name="cuerpo">El contenido del correo (puede ser HTML).</param>
        /// <returns>True si se envió correctamente, False si hubo un error.</returns>
        public static bool Enviar(string destinatario, string asunto, string cuerpo)
        {
            // === PASO A: LEER LA CONFIGURACIÓN DEL Web.config ===
            string emailEmisor = ConfigurationManager.AppSettings["EmailEmisor"];
            string passwordEmisor = ConfigurationManager.AppSettings["PasswordEmisor"];
            string smtpServidor = ConfigurationManager.AppSettings["SmtpServidor"];
            int smtpPuerto = Convert.ToInt32(ConfigurationManager.AppSettings["SmtpPuerto"]);

            // === PASO B: CONSTRUIR EL MENSAJE DEL CORREO ===
            // Usamos 'using' para que los recursos se liberen automáticamente
            using (MailMessage mensaje = new MailMessage())
            {
                mensaje.From = new MailAddress(emailEmisor);
                mensaje.To.Add(new MailAddress(destinatario));
                mensaje.Subject = asunto;
                mensaje.Body = cuerpo;
                mensaje.IsBodyHtml = true; // Fundamental para que interprete etiquetas como <h1>, <p>, <b>

                // === PASO C: CONFIGURAR EL CLIENTE SMTP (EL SERVICIO DE GMAIL) ===
                using (SmtpClient clienteSmtp = new SmtpClient(smtpServidor, smtpPuerto))
                {
                    // Le decimos al cliente que use conexión segura
                    clienteSmtp.EnableSsl = true;
                    // Le pasamos nuestras credenciales (el usuario y la contraseña de aplicación)
                    clienteSmtp.Credentials = new NetworkCredential(emailEmisor, passwordEmisor);

                    // === PASO D: ENVIAR EL CORREO ===
                    try
                    {
                        clienteSmtp.Send(mensaje);
                        // Si el código llega hasta aquí, el correo se envió sin problemas.
                        return true;
                    }
                    catch (Exception ex)
                    {
                        // Si algo falla (ej: la contraseña es incorrecta, no hay conexión a internet),
                        // el error se captura aquí y el método devuelve 'false'.
                        // En un proyecto real, guardarías el detalle del error 'ex' en un archivo de log.
                        System.Diagnostics.Debug.WriteLine("Error al enviar email: " + ex.Message);
                        return false;
                    }
                }
            }
        }
    }
}