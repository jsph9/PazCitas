/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package pe.edu.pucp.pazcitas.cita.bo;

import java.util.ArrayList;
import java.util.Date;
import pe.edu.pucp.pazcitas.cita.dao.TurnoDAO;
import pe.edu.pucp.pazcitas.cita.impl.TurnoImpl;
import pe.edu.pucp.pazcitas.cita.model.Turno;
import pe.edu.pucp.pazcitas.cita.model.TurnoDisponibleDTO;

/**
 *
 * @author Joel
 */
public class TurnoBO {

    private final TurnoDAO daoTurno;

    public TurnoBO() {
        daoTurno = new TurnoImpl();
    }

    public int insertar(Turno turno) {
        return daoTurno.insertar(turno);
    }

    public int modificar(Turno turno) {
        return daoTurno.modificar(turno);
    }

    public int eliminar(int idTurno) {
        return daoTurno.eliminar(idTurno);
    }

    public ArrayList<Turno> listarTodos() {
        return daoTurno.listarTodos();
    }

    public Turno obtenerXId(int idTurno) {
        return daoTurno.obtenerPorId(idTurno);
    }

    public ArrayList<TurnoDisponibleDTO> listarTurnosPorSemana(int idMedico, Date fechaInicio) {
        return daoTurno.listarTurnosDisponiblesSemana(idMedico, fechaInicio);
    }

    public ArrayList<Turno> obtenerTurnosLibres(int idMedico, Date fecha) {
        return daoTurno.obtenerTurnosLibres(idMedico, fecha);
    }
}
