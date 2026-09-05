/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/WebServices/WebService.java to edit this template
 */
package pe.edu.pucp.pazcitas.cita.services;

import jakarta.jws.WebService;
import jakarta.jws.WebMethod;
import jakarta.jws.WebParam;
import java.util.ArrayList;
import java.util.Date;
import pe.edu.pucp.pazcitas.cita.bo.TurnoBO;
import pe.edu.pucp.pazcitas.cita.model.Turno;
import pe.edu.pucp.pazcitas.cita.model.TurnoDisponibleDTO;

/**
 *
 * @author Joel
 */
@WebService(serviceName = "TurnoWS",
        targetNamespace = "http://services.pucp.edu.pe")
public class TurnoWS {

    private TurnoBO boturno;

    @WebMethod(operationName = "listarTurno")
    public ArrayList<Turno> listarTurno() {
        boturno = new TurnoBO();
        return boturno.listarTodos();
    }

    @WebMethod(operationName = "insertaTurno")
    public int insertaTurno(@WebParam(name = "turno") Turno turno) {
        boturno = new TurnoBO();
        return boturno.insertar(turno);
    }

    @WebMethod(operationName = "modificarTurno")
    public int modificarTurno(@WebParam(name = "turno") Turno turno) {
        boturno = new TurnoBO();
        return boturno.modificar(turno);
    }

    @WebMethod(operationName = "eliminarTurno")
    public int eliminarTurno(@WebParam(name = "idturno") int idturno) {
        boturno = new TurnoBO();
        return boturno.eliminar(idturno);
    }

    @WebMethod(operationName = "obtenerXId")
    public Turno obtenerXId(@WebParam(name = "idturno") int idturno) {
        boturno = new TurnoBO();
        return boturno.obtenerXId(idturno);
    }

    //Añadido nuevo metodo
    @WebMethod(operationName = "listarTurnosSemana")
    public ArrayList<TurnoDisponibleDTO> listarTurnosSemana(@WebParam(name = "idMedico") int idMedico, @WebParam(name = "fechaInicio") Date fechaInicio) {
        boturno = new TurnoBO();
        return boturno.listarTurnosPorSemana(idMedico, fechaInicio);
    }

    @WebMethod(operationName = "obtenerTurnosLibres")
    public ArrayList<Turno> obtenerTurnosLibres(@WebParam(name = "idMedico") int idMedico, @WebParam(name = "fecha") Date fecha) {
        boturno = new TurnoBO();
        return boturno.obtenerTurnosLibres(idMedico, fecha);
    }
}
