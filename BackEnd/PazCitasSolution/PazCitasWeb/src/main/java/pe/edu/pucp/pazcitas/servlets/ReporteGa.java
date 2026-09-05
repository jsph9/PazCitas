/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package pe.edu.pucp.pazcitas.servlets;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.net.URL;
import java.net.URLDecoder;
import java.sql.Connection;
import java.util.HashMap;
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
public class ReporteGa {
    protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try{
            //Referenciamos el archivo Jasper
            JasperReport jr = (JasperReport) JRLoader.loadObject(getClass().getResourceAsStream("/pe/edu/pucp/pazcitas/reportes/ReporteEjemplo.jasper"));
            //Establecemos los parametros que necesita el reporte
            HashMap parametros = new HashMap();
            parametros.put("nombre", "Joel Galindo");
            //Referenciamos la imagen del logo y los subreportes
            URL subreporteEmpleados = getClass().getResource("/pe/edu/pucp/pazcitas/reportes/ReporteMedicos.jasper");
            //Generamos los objetos necesarios en el reporte
            String rutaSubreporteMedicos= URLDecoder.decode(subreporteEmpleados.getPath(), "UTF-8");
            //Colocamos los parámetros
            parametros.put("id_sede", 1);
            parametros.put("RutaSubReporteMedico",rutaSubreporteMedicos);
            //Establecemos la conexión
            Connection con = DBManager.getInstance().getConnection();
            //Poblamos el reporte
            JasperPrint jp = JasperFillManager.fillReport(jr, parametros, con);
            //Mostramos por pantalla
            JasperExportManager.exportReportToPdfStream(jp, response.getOutputStream());
        }catch(Exception ex){
            System.out.println(ex.getMessage());
        }finally{
            DBManager.getInstance().cerrarConexion();
        }
    }
    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        processRequest(request, response);
//    }
//
//    
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        processRequest(request, response);
//    }
//
//    
//    @Override
//    public String getServletInfo() {
//        return "Short description";
//    }// </editor-fold>
}
