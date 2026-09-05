/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/WebServices/WebService.java to edit this template
 */
package pe.edu.pucp.pazcitas.ubicacion.services;

import jakarta.jws.WebService;
import jakarta.jws.WebMethod;
import jakarta.jws.WebParam;
import pe.edu.pucp.pazcitas.ubicacion.bo.SedeEspecialidadBO;
import pe.edu.pucp.pazcitas.ubicacion.model.SedeEspecialidad;

/**
 *
 * @author Joel
 */
@WebService(serviceName = "SedeEspecialidadWS",
        targetNamespace = "http://services.pucp.edu.pe")
public class SedeEspecialidadWS {

    private SedeEspecialidadBO bosedeesp;
    
    @WebMethod(operationName = "insertarSedeEspecialidad")
    public int insertarSedeEspecialidad(@WebParam(name = "sedeEsp") SedeEspecialidad sedeEsp) {
        bosedeesp = new SedeEspecialidadBO();
        return bosedeesp.insertar(sedeEsp);
    }
    
    @WebMethod(operationName = "eliminarSedeEspecialidad")
    public int eliminarSedeEspecialidad(@WebParam(name = "idsedeEsp") int idsedeEsp) {
        bosedeesp = new SedeEspecialidadBO();
        return bosedeesp.eliminar(idsedeEsp);
    }
    
    @WebMethod(operationName = "eliminarSedeEspecialidadXSede")
    public int eliminarSedeEspecialidadXSede(@WebParam(name = "idSede") int idSede){
        bosedeesp = new SedeEspecialidadBO();
        return bosedeesp.eliminarXSede(idSede);
    }
}
