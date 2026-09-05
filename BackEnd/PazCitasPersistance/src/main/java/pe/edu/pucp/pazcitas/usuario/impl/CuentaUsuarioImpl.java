package pe.edu.pucp.pazcitas.usuario.impl;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import pe.edu.pucp.pazcitas.config.DBManager;
import pe.edu.pucp.pazcitas.usuario.dao.CuentaUsuarioDAO;
import pe.edu.pucp.pazcitas.usuario.model.Administrador;
import pe.edu.pucp.pazcitas.usuario.model.CuentaUsuario;
import pe.edu.pucp.pazcitas.usuario.model.Medico;
import pe.edu.pucp.pazcitas.usuario.model.Paciente;

public class CuentaUsuarioImpl implements CuentaUsuarioDAO{
    private ResultSet rs;
    @Override
    public int insertar(CuentaUsuario c) {
        Map<Integer,Object> parametrosSalida = new HashMap<>();   
        Map<Integer,Object> parametrosEntrada = new HashMap<>();
        parametrosSalida.put(1, Types.INTEGER);
        parametrosEntrada.put(2, c.getUsername());
        parametrosEntrada.put(3, c.getPassword());
        parametrosEntrada.put(4, c.getRol().name());
        parametrosEntrada.put(5, c.getUsuario().getIdUsuario());
        DBManager.getInstance().ejecutarProcedimiento("INSERTAR_CUENTA", parametrosEntrada, parametrosSalida);
        c.setIdCuentaUsuario((int) parametrosSalida.get(1));
        return c.getIdCuentaUsuario();    
    }

    @Override
    public int verificarCuentaPaciente(String username, String password) {
        int resultado = 0;
        Map<Integer, Object> parametrosEntrada = new HashMap<>();
        parametrosEntrada.put(1, username);
        parametrosEntrada.put(2, password);
        rs = DBManager.getInstance().ejecutarProcedimientoLectura("VERIFICAR_CUENTA_PACIENTE", parametrosEntrada);
        try{
            if(rs.next()){
                resultado = rs.getInt("fid_usuario");
            }
        }catch(SQLException ex){
            System.out.println("ERROR: "+ex.getMessage());
        }finally{
            DBManager.getInstance().cerrarConexion();
        }
        return resultado;
    }
    @Override
    public int verificarCuentaMedico(String username, String password) {
        int resultado = 0;
        Map<Integer, Object> parametrosEntrada = new HashMap<>();
        parametrosEntrada.put(1, username);
        parametrosEntrada.put(2, password);
        rs = DBManager.getInstance().ejecutarProcedimientoLectura("VERIFICAR_CUENTA_MEDICO", parametrosEntrada);
        try{
            if(rs.next()){
                resultado = rs.getInt("fid_usuario");
            }
        }catch(SQLException ex){
            System.out.println("ERROR: "+ex.getMessage());
        }finally{
            DBManager.getInstance().cerrarConexion();
        }
        return resultado;   
    }

    @Override
    public int verificarCuentaAdministrador(String username, String password) {
        int resultado = 0;
        Map<Integer, Object> parametrosEntrada = new HashMap<>();
        parametrosEntrada.put(1, username);
        parametrosEntrada.put(2, password);
        rs = DBManager.getInstance().ejecutarProcedimientoLectura("VERIFICAR_CUENTA_ADMINISTRADOR", parametrosEntrada);
        try{
            if(rs.next()){
                resultado = rs.getInt("fid_usuario");
            }
        }catch(SQLException ex){
            System.out.println("ERROR: "+ex.getMessage());
        }finally{
            DBManager.getInstance().cerrarConexion();
        }
        return resultado;    
    }

    @Override
    public int modificar(CuentaUsuario modelo) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public int eliminar(int idModelo) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public ArrayList<CuentaUsuario> listarTodos() {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public int verificarCuenta(String identificador, String password, String rol) {
        int resultado = 0;
        Map<Integer, Object> parametrosEntrada = new HashMap<>();
        parametrosEntrada.put(1, identificador);
        parametrosEntrada.put(2, password);
        parametrosEntrada.put(3, rol);
        rs = DBManager.getInstance().ejecutarProcedimientoLectura("VERIFICAR_CUENTA_GENERAL", parametrosEntrada);
        try{
            if(rs.next()){
                resultado = rs.getInt("fid_usuario");
            }
        }catch(SQLException ex){
            System.out.println("ERROR: "+ex.getMessage());
        }finally{
            DBManager.getInstance().cerrarConexion();
        }
        return resultado;
    }

    @Override
    public int verificarUsernameExiste(String username) {
        int resultado=0;
        Map<Integer, Object> parametrosEntrada = new HashMap<>();
        parametrosEntrada.put(1, username);
        rs = DBManager.getInstance().ejecutarProcedimientoLectura("VERIFICAR_USERNAME_EXISTE", parametrosEntrada);
        try{
            if(rs.next()){
                resultado = rs.getInt("existe");
            }
        }catch(SQLException ex){
            System.out.println("ERROR: "+ex.getMessage());
        }finally{
            DBManager.getInstance().cerrarConexion();
        }
        return resultado;
    }
    
}