/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package pe.edu.pucp.pazcitas.ubicacion.dao;

import pe.edu.pucp.pazcitas.dao.ICrud;
import pe.edu.pucp.pazcitas.ubicacion.model.SedeEspecialidad;

/**
 *
 * @author Joel
 */
public interface SedeEspecialidadDAO extends ICrud<SedeEspecialidad>{
    int eliminarPorSede(int idSede);
}
