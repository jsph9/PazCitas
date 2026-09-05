/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package pe.edu.pucp.pazcitas.cita.bo;

import java.util.ArrayList;
import pe.edu.pucp.pazcitas.cita.dao.HorarioTrabajoDAO;
import pe.edu.pucp.pazcitas.cita.impl.HorarioTrabajoImpl;
import pe.edu.pucp.pazcitas.cita.model.HorarioTrabajo;

/**
 *
 * @author Joel
 */
public class HorarioTrabajoBO {
    
    private final HorarioTrabajoDAO daoHorario;
    
    public HorarioTrabajoBO(){
        daoHorario = new HorarioTrabajoImpl();
    }
    
    public int insertar(HorarioTrabajo horario){
        return daoHorario.insertar(horario);
    }
    public int modificar(HorarioTrabajo horario){
        return daoHorario.modificar(horario);
    }
    public int eliminar(int idHorario){
        return daoHorario.eliminar(idHorario);
    }
    public ArrayList<HorarioTrabajo> listarTodos(){
        return daoHorario.listarTodos();
    }
    
    public ArrayList<HorarioTrabajo> listarPorMedico(int idMedico){
        return daoHorario.listarPorMedico(idMedico);
    }
    
    public int eliminarPorMedico(int idMedico){
        return daoHorario.eliminarPorMedico(idMedico);
    }
}
