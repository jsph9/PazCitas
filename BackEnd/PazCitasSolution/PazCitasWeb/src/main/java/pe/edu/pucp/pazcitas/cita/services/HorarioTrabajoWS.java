/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/WebServices/WebService.java to edit this template
 */
package pe.edu.pucp.pazcitas.cita.services;

import jakarta.jws.WebService;
import jakarta.jws.WebMethod;
import jakarta.jws.WebParam;
import java.util.ArrayList;
import pe.edu.pucp.pazcitas.cita.bo.HorarioTrabajoBO;
import pe.edu.pucp.pazcitas.cita.model.HorarioTrabajo;

/**
 *
 * @author Joel
 */
@WebService(serviceName = "HorarioTrabajoWS",
        targetNamespace = "http://services.pucp.edu.pe")
public class HorarioTrabajoWS {

    private HorarioTrabajoBO bohorario;
    
    @WebMethod(operationName = "listarHorario")
    public ArrayList<HorarioTrabajo> listarHorario() {
        bohorario = new HorarioTrabajoBO();
        return bohorario.listarTodos();
    }
    
    @WebMethod(operationName = "listarPorMedico")
    public ArrayList<HorarioTrabajo> listarPorMedico(@WebParam(name = "idMedico") int idMedico) {
        bohorario = new HorarioTrabajoBO();
        return bohorario.listarPorMedico(idMedico);
    }
    
    @WebMethod(operationName = "insertaHorario")
    public int insertaHorario(@WebParam(name = "horario") HorarioTrabajo horario) {
        bohorario = new HorarioTrabajoBO();
        return bohorario.insertar(horario);
    }
    @WebMethod(operationName = "modificarHorario")
    public int modificarHorario(@WebParam(name = "horario") HorarioTrabajo horario) {
        bohorario = new HorarioTrabajoBO();
        return bohorario.modificar(horario);
    }
    @WebMethod(operationName = "eliminarHorario")
    public int eliminarHorario(@WebParam(name = "idhorario") int idhorario) {
        bohorario = new HorarioTrabajoBO();
        return bohorario.eliminar(idhorario);
    }
    
    @WebMethod(operationName = "eliminarHorarioPorMedico")
    public int eliminarHorarioPorMedico(@WebParam(name = "idMedico") int idMedico) {
        bohorario = new HorarioTrabajoBO();
        return bohorario.eliminarPorMedico(idMedico);
    }
}
