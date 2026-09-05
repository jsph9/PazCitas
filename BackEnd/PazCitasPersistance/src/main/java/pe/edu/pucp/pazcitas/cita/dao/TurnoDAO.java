/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package pe.edu.pucp.pazcitas.cita.dao;

import java.util.ArrayList;
import java.util.Date;
import pe.edu.pucp.pazcitas.cita.model.Turno;
import pe.edu.pucp.pazcitas.cita.model.TurnoDisponibleDTO;
import pe.edu.pucp.pazcitas.dao.ICrud;

/**
 *
 * @author Joel
 */
public interface TurnoDAO extends ICrud<Turno>{
    public Turno obtenerPorId(int idTurno);
    public ArrayList<TurnoDisponibleDTO> listarTurnosDisponiblesSemana(int idMedico, Date fechaInicio);
    public ArrayList<Turno> obtenerTurnosLibres(int idMedico, Date fecha);
}
