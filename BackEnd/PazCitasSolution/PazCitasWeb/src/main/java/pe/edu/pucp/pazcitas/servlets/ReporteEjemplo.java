/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package pe.edu.pucp.pazcitas.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.awt.Image;
import java.io.IOException;
import java.net.URL;
import java.net.URLDecoder;
import java.sql.Connection;
import java.util.HashMap;
import javax.swing.ImageIcon;
import net.sf.jasperreports.engine.JasperExportManager;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.JasperReport;
import net.sf.jasperreports.engine.util.JRLoader;
import pe.edu.pucp.pazcitas.config.DBManager;

/**
 *
 * @author darwi
 */
public class ReporteEjemplo {
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        //aqui vamos a programar para que aparezca el reporte que acabamos de crear.
        try{
            
            //1) creamos el 'reporte', asignando el 'URL del Reporte'
            JasperReport jr = (JasperReport)JRLoader.loadObject(getClass().
                    getClassLoader().getResourceAsStream("/pe/edu/pucp//pazcitas/reportes/reporteCitas.jasper"));
            
            //2) enviamos paramestros de informacion para que se pueda lanzar el reporte
            
            //a. reporte sin parametros ni conexion con la BD
//            JasperPrint jp = JasperFillManager.fillReport(jr,null,new JREmptyDataSource());


            //b. reporte con PARAMETROS enviados desde el JAVA
//            HashMap parametros = new HashMap();
//            parametros.put("nombre", "WINDAR");
//            
//            JasperPrint jp = JasperFillManager.fillReport(jr,parametros,new JREmptyDataSource());
            
            //c. reporte con informacion de la BD
            /*OJO: Se requerirá una 'sentencia sql' que permita retornar los datos a mostrar en
            el reporte.*/
//            HashMap parametros = new HashMap();
//            parametros.put("nombre", "WINDAR");
//            
//            Connection con = DBManager.getInstance().getConnection();
//            JasperPrint jp = JasperFillManager.fillReport(jr,parametros,con);
            
            
            //d. reporte con info de la BD e IMAGEN
            HashMap parametros = new HashMap();
            parametros.put("nombre", "WINDAR");
            
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
            
            //3) mostramos en pantalla el reporte
            JasperExportManager.exportReportToPdfStream(jp, response.getOutputStream());
            
        }catch(Exception ex){
            System.out.println(ex.getMessage());
        }
        
        
        
//        response.setContentType("text/html;charset=UTF-8");
//        try (PrintWriter out = response.getWriter()) {
//            /* TODO output your page here. You may use following sample code. */
//            out.println("<!DOCTYPE html>");
//            out.println("<html>");
//            out.println("<head>");
//            out.println("<title>Servlet ReporteEjemplo</title>");
//            out.println("</head>");
//            out.println("<body>");
//            out.println("<h1>Servlet ReporteEjemplo at " + request.getContextPath() + "</h1>");
//            out.println("<h2>OLA A TODOS</h2>");
//            out.println("</body>");
//            out.println("</html>");
//        }
    }
}
