/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package pe.edu.pucp.pazcitas.cita.dao;

import java.util.ArrayList;
import pe.edu.pucp.pazcitas.cita.model.HorarioTrabajo;
import pe.edu.pucp.pazcitas.dao.ICrud;

/**
 *
 * @author Joel
 */
public interface HorarioTrabajoDAO extends ICrud<HorarioTrabajo>{
    public HorarioTrabajo obtenerPorId(int idHorario);
    ArrayList<HorarioTrabajo> listarPorMedico(int idMedico);
    int eliminarPorMedico(int idMedico);
}
