/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package pe.edu.pucp.pazcitas.atencion.impl;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import pe.edu.pucp.pazcitas.atencion.dao.LineaRecetaMedicamentoDAO;
import pe.edu.pucp.pazcitas.atencion.model.LineaRecetaMedicamento;
import pe.edu.pucp.pazcitas.atencion.model.Medicamento;
import pe.edu.pucp.pazcitas.config.DBManager;

/**
 *
 * @author Joel
 */
public class LineaRecetaMedicamentoImpl implements LineaRecetaMedicamentoDAO{
    
    private ResultSet rs;

    @Override
    public int insertar(LineaRecetaMedicamento linea) {
        Map<Integer, Object> parametrosSalida = new HashMap<>();
        Map<Integer, Object> parametrosEntrada = new HashMap<>();
        parametrosSalida.put(1, Types.INTEGER);
        parametrosEntrada.put(2, linea.getReceta().getIdReceta());
        parametrosEntrada.put(3, linea.getMedicamento().getIdMedicamento());
        parametrosEntrada.put(4, linea.getCantidad());
        DBManager.getInstance().ejecutarProcedimiento("INSERTAR_RECETA_MEDICAMENTO", parametrosEntrada, parametrosSalida);
        linea.setIdLineaRecetaMedicamento((int) parametrosSalida.get(1));
        System.out.println("Se ha realizado el registro de la linea receta...");
        return linea.getIdLineaRecetaMedicamento();
    }

    @Override
    public int eliminar(int idModelo) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public int modificar(LineaRecetaMedicamento modelo) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public ArrayList<LineaRecetaMedicamento> listarTodos() {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public ArrayList<LineaRecetaMedicamento> listar_lineas_x_receta(int idReceta) {
        ArrayList<LineaRecetaMedicamento> lineas = null;
        Map<Integer, Object> parametrosEntrada = new HashMap<>();
        parametrosEntrada.put(1, idReceta);
        rs = DBManager.getInstance().ejecutarProcedimientoLectura("LISTAR_LINEAS_X_RECETA", parametrosEntrada);
        System.out.println("Lectura de lineas...");
        
        try {
            while (rs.next()) {
                if (lineas == null) {
                    lineas = new ArrayList<>();
                }
                LineaRecetaMedicamento l = new LineaRecetaMedicamento();
                
                l.setIdLineaRecetaMedicamento(rs.getInt("id_receta_medicamento"));
                Medicamento m = new Medicamento();
                m.setIdMedicamento(rs.getInt("fid_medicamento"));
                m.setNombre(rs.getString("nombre"));
                m.setPresentacion(rs.getString("presentacion"));
                l.setMedicamento(m);
                l.setCantidad(rs.getInt("cantidad"));
                
                lineas.add(l);
                
                
            }
            
            
        } catch (SQLException ex) {
            System.out.println(ex.getMessage());

        } finally {
            DBManager.getInstance().cerrarConexion();
        }
        
        return lineas;
    }
    
    
}
