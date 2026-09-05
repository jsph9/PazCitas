/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/WebServices/WebService.java to edit this template
 */
package pe.edu.pucp.pazcitas.reportes.services;

import jakarta.jws.WebMethod;
import jakarta.jws.WebParam;
import java.awt.Image;
import java.net.URL;
import java.net.URLDecoder;
import java.sql.Connection;
import java.util.HashMap;
import jakarta.jws.WebService;
import jakarta.jws.WebMethod;
import jakarta.jws.WebParam;
import javax.swing.ImageIcon;
import net.sf.jasperreports.engine.JasperExportManager;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.JasperReport;
import net.sf.jasperreports.engine.util.JRLoader;
import pe.edu.pucp.pazcitas.config.DBManager;
import pe.edu.pucp.pazcitas.ubicacion.model.Sede;

/**
 *
 * @author darwi
 */
@WebService(serviceName = "ReporteWS",
        targetNamespace = "http://services.pucp.edu.pe")
public class ReporteWS {

    @WebMethod(operationName = "generarReporteCita")
    public byte[] generarReporteCita(@WebParam(name = "nombre") String nombre) {
        byte[]reporte =null;
        try{
            
            //1) creamos el 'reporte', asignando el 'URL del Reporte'
            JasperReport jr = (JasperReport)JRLoader.loadObject(getClass().
                    getClassLoader().getResourceAsStream("/pe/edu/pucp//pazcitas/reportes/reporteCitas.jasper"));
            
            //2) enviamos paramestros de informacion para que se pueda lanzar el reporte
            
            //d. reporte con info de la BD e IMAGEN
            HashMap parametros = new HashMap();
            parametros.put("nombre", nombre);
            
            //Referenciamos la imagen del reporte
            URL rutaLogo = getClass().getResource("/pe/edu/pucp/pazcitas/reportes/imagen.png");
            Image logo = (new ImageIcon(rutaLogo)).getImage();
            parametros.put("Logo", logo);
            URL subreporteCXE = getClass().getResource("/pe/edu/pucp/pazcitas/reportes/reporteCitasPorEspecialidad.jasper");
            URL subreporteCXS = getClass().getResource("/pe/edu/pucp/pazcitas/reportes/reporteCitasPorSemana.jasper");
            

            String rutasubreporteCXE = URLDecoder.decode(subreporteCXE.getPath(),"UTF-8");
            String rutasubreporteCXS = URLDecoder.decode(subreporteCXS.getPath(),"UTF-8");

            parametros.put("rutaSubReporteCitasPorEspecialidad", rutasubreporteCXE);
            parametros.put("rutaSubReporteCitaPorSemana", rutasubreporteCXS);

            //Establecemos la conexion
            Connection con = DBManager.getInstance().getConnection();
            //Probamos el reporte
            JasperPrint jp = JasperFillManager.fillReport(jr,parametros,con);

            con.close();
            
            //3) enviar a C# el pdf en formato de arreglo de bytes
            reporte = JasperExportManager.exportReportToPdf(jp);
            
            
        }catch(Exception ex){
            System.out.println(ex.getMessage());
        }
        finally{
            DBManager.getInstance().cerrarConexion();
        }
        return reporte;
    }
    
    @WebMethod(operationName = "generarReporteCitasXSede")
    public byte[] generarReporteCitasXSede(@WebParam(name = "nombre") String nombre,
            @WebParam(name = "sede") Sede sede) {
        byte[]reporte =null;
        try{
            
            //Referenciamos el archivo Jasper
            JasperReport jr = (JasperReport) JRLoader.loadObject(getClass().getResourceAsStream("/pe/edu/pucp/pazcitas/reportes/ReporteEjemplo.jasper"));
            //Establecemos los parametros que necesita el reporte
            HashMap parametros = new HashMap();
            parametros.put("Nombre", nombre);
            //Referenciamos la imagen del logo y los subreportes
            URL rutaLogo = getClass().getResource("/pe/edu/pucp/pazcitas/reportes/clinic-logo.jpg");
            URL subreporteMedicos = getClass().getResource("/pe/edu/pucp/pazcitas/reportes/ReporteMedicos.jasper");
            URL subreporteGrafico = getClass().getResource("/pe/edu/pucp/pazcitas/reportes/ReporteImagen.jasper");
            //Generamos los objetos necesarios en el reporte
            Image logo = (new ImageIcon(rutaLogo)).getImage();
            String rutaSubreporteMedicos = URLDecoder.decode(subreporteMedicos.getPath(), "UTF-8");
            String rutaSubreporteGrafico = URLDecoder.decode(subreporteGrafico.getPath(), "UTF-8");
            //Colocamos los parámetros
            parametros.put("logo", logo);
            parametros.put("RutaSubReporteMedico",rutaSubreporteMedicos);
            parametros.put("RutaSubReporteGrafico",rutaSubreporteGrafico);
            parametros.put("id_sede", sede.getIdSede());
            parametros.put("nombre_sede", sede.getNombre());
            //Establecemos la conexión
            Connection con = DBManager.getInstance().getConnection();
            //Poblamos el reporte
            JasperPrint jp = JasperFillManager.fillReport(jr, parametros, con);
            //Mostramos por pantalla
            con.close();
            
            //3) enviar a C# el pdf en formato de arreglo de bytes
            reporte = JasperExportManager.exportReportToPdf(jp);
            
            
        }catch(Exception ex){
            System.out.println(ex.getMessage());
        }
        finally{
            DBManager.getInstance().cerrarConexion();
        }
        return reporte;
    }
    
}
