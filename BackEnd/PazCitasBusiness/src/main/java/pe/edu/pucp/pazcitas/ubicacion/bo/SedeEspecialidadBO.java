/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package pe.edu.pucp.pazcitas.ubicacion.bo;

import pe.edu.pucp.pazcitas.ubicacion.dao.SedeEspecialidadDAO;
import pe.edu.pucp.pazcitas.ubicacion.impl.SedeEspecialidadImpl;
import pe.edu.pucp.pazcitas.ubicacion.model.SedeEspecialidad;

/**
 *
 * @author Joel
 */
public class SedeEspecialidadBO {
    private final SedeEspecialidadDAO daoSedeEspecialidad;
    
    public SedeEspecialidadBO(){
        daoSedeEspecialidad = new SedeEspecialidadImpl();
    }
    
    public int insertar(SedeEspecialidad sedeesp){
        return daoSedeEspecialidad.insertar(sedeesp);
    }
    
    public int eliminar(int id){
        return daoSedeEspecialidad.eliminar(id);
    }
    
    public int eliminarXSede(int idSede){
        return daoSedeEspecialidad.eliminarPorSede(idSede);
    }
}
