/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package pe.edu.pucp.pazcitas.ubicacion.impl;

import java.sql.Types;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import pe.edu.pucp.pazcitas.config.DBManager;
import pe.edu.pucp.pazcitas.ubicacion.dao.SedeEspecialidadDAO;
import pe.edu.pucp.pazcitas.ubicacion.model.SedeEspecialidad;

/**
 *
 * @author Joel
 */
public class SedeEspecialidadImpl implements SedeEspecialidadDAO{

    @Override
    public int insertar(SedeEspecialidad sedeespe) {
        Map<Integer,Object> parametrosEntrada = new HashMap<>();
        Map<Integer,Object> parametrosSalida = new HashMap<>();
        parametrosSalida.put(1, Types.INTEGER);
        
        parametrosEntrada.put(2, sedeespe.getSede().getIdSede());
        parametrosEntrada.put(3, sedeespe.getEspecialidad().getIdEspecialidad());
        
        DBManager.getInstance().ejecutarProcedimiento("INSERTAR_SEDE_ESPECIALIDAD", parametrosEntrada, parametrosSalida);
        sedeespe.setIdSedeEspecialidad((int) parametrosSalida.get(1));
        System.out.println("Se ha realizado el registro el sede-especialidad");
        return sedeespe.getIdSedeEspecialidad();
    }

    @Override
    public int eliminar(int idsedeespe) {
        Map<Integer,Object> parametrosEntrada = new HashMap<>();
        parametrosEntrada.put(1, idsedeespe);
        int resultado = DBManager.getInstance().ejecutarProcedimiento("ELIMINAR_SEDE_ESPECIALIDAD", parametrosEntrada, null);
        System.out.println("Se ha realizado la eliminacion de la sede-especialidad");
        return resultado;
    }

    @Override
    public int modificar(SedeEspecialidad modelo) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public ArrayList<SedeEspecialidad> listarTodos() {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public int eliminarPorSede(int idSede) {
        Map<Integer,Object> parametrosEntrada = new HashMap<>();
        parametrosEntrada.put(1,idSede);
        int resultado = DBManager.getInstance().ejecutarProcedimiento("ELIMINAR_SEDE_ESPECIALIDAD_X_SEDE", parametrosEntrada, null);
        System.out.println("Se ha realizado la eliminacion de la sede-especialidad por sede");
        return resultado;
    }
}
