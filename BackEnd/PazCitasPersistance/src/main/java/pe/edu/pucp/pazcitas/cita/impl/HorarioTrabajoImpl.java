
package pe.edu.pucp.pazcitas.cita.impl;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import pe.edu.pucp.pazcitas.cita.dao.HorarioTrabajoDAO;
import pe.edu.pucp.pazcitas.cita.model.DiaSemana;
import pe.edu.pucp.pazcitas.cita.model.HorarioTrabajo;
import pe.edu.pucp.pazcitas.cita.model.Turno;
import pe.edu.pucp.pazcitas.config.DBManager;
import pe.edu.pucp.pazcitas.usuario.model.Medico;

public class HorarioTrabajoImpl implements HorarioTrabajoDAO{
    private ResultSet rs;

    @Override
    public int insertar(HorarioTrabajo h) {
        Map<Integer,Object> parametrosSalida = new HashMap<>();   
        Map<Integer,Object> parametrosEntrada = new HashMap<>();
        parametrosSalida.put(1, Types.INTEGER);
        parametrosEntrada.put(2, h.getMedico().getIdUsuario());
        parametrosEntrada.put(3, h.getTurno().getIdTurno());
        DBManager.getInstance().ejecutarProcedimiento("INSERTAR_HORARIO", parametrosEntrada, parametrosSalida);
        h.setIdHorarioTrabajo((int) parametrosSalida.get(1));
        return h.getIdHorarioTrabajo();
    }

    @Override
    public int modificar(HorarioTrabajo h) {
        Map<Integer,Object> parametrosEntrada = new HashMap<>();
        parametrosEntrada.put(1, h.getIdHorarioTrabajo());
        parametrosEntrada.put(2, h.getMedico().getIdUsuario());
        parametrosEntrada.put(3, h.getTurno().getIdTurno());
        int resultado = DBManager.getInstance().ejecutarProcedimiento("MODIFICAR_HORARIO", parametrosEntrada, null);
        return resultado;       
    }

    @Override
    public int eliminar(int idHorario) {
        Map<Integer,Object> parametrosEntrada = new HashMap<>();
        parametrosEntrada.put(1, idHorario);
        int resultado = DBManager.getInstance().ejecutarProcedimiento("ELIMINAR_HORARIO", parametrosEntrada, null);
        return resultado;       
    }

    @Override
    public ArrayList<HorarioTrabajo> listarTodos() {
        ArrayList<HorarioTrabajo> horarios = null;
        rs = DBManager.getInstance().ejecutarProcedimientoLectura("LISTAR_HORARIO_TODOS", null);
        try{
            while(rs.next()){
                if(horarios == null) horarios = new ArrayList<>();
                HorarioTrabajo h = new HorarioTrabajo();
                h.setIdHorarioTrabajo(rs.getInt("id_horario_trabajo"));
                
                Turno t=new Turno();
                t.setIdTurno(rs.getInt("fid_turno"));
                DiaSemana dia = DiaSemana.valueOf(rs.getString("dia").toUpperCase());
                t.setDia(dia);
                t.setHoraInicio(rs.getDate("hora_inicio"));
                t.setHoraInicio(rs.getDate("hora_fin"));
                
                Medico m=new Medico();
                m.setIdUsuario(rs.getInt("fid_medico"));
                
                h.setTurno(t);
                h.setMedico(m);
                horarios.add(h);
            }
        }catch(SQLException ex){
            System.out.println(ex.getMessage());
        }finally{
            DBManager.getInstance().cerrarConexion();
        }
        return horarios;      
    }

    @Override
    public HorarioTrabajo obtenerPorId(int idHorario) {
        HorarioTrabajo h = null;
        Map<Integer, Object> parametrosEntrada = new HashMap<>();
        parametrosEntrada.put(1, idHorario);
        rs = DBManager.getInstance().ejecutarProcedimientoLectura("OBTENER_HORARIO_X_ID", parametrosEntrada);
        try{
            while(rs.next()){
                if(h == null) h = new HorarioTrabajo();
                h.setIdHorarioTrabajo(rs.getInt("id_horario_trabajo"));
                
                Turno t=new Turno();
                t.setIdTurno(rs.getInt("fid_turno"));
                DiaSemana dia = DiaSemana.valueOf(rs.getString("dia").toUpperCase());
                t.setDia(dia);
                t.setHoraInicio(rs.getDate("hora_inicio"));
                t.setHoraInicio(rs.getDate("hora_fin"));
                
                Medico m=new Medico();
                m.setIdUsuario(rs.getInt("fid_medico"));
                
                h.setTurno(t);
                h.setMedico(m);
            }
        }catch(SQLException ex){
            System.out.println(ex.getMessage());
        }finally{
            DBManager.getInstance().cerrarConexion();
        }
        return h;     
    }

    @Override
    public ArrayList<HorarioTrabajo> listarPorMedico(int idMedico) {
        ArrayList<HorarioTrabajo> horarios = null;
        Map<Integer, Object> parametrosEntrada = new HashMap<>();
        parametrosEntrada.put(1, idMedico);
        rs = DBManager.getInstance().ejecutarProcedimientoLectura("LISTAR_HORARIO_X_MEDICO", parametrosEntrada);
        try{
            while(rs.next()){
                if(horarios == null) horarios = new ArrayList<>();
                HorarioTrabajo h = new HorarioTrabajo();
                h.setIdHorarioTrabajo(rs.getInt("id_horario_trabajo"));
                
                Turno t=new Turno();
                t.setIdTurno(rs.getInt("fid_turno"));
                DiaSemana dia = DiaSemana.valueOf(rs.getString("dia").toUpperCase());
                t.setDia(dia);
                t.setHoraInicio(rs.getTime("hora_inicio"));
                t.setHoraInicio(rs.getTime("hora_fin"));
                
                Medico m=new Medico();
                m.setIdUsuario(rs.getInt("fid_medico"));
                
                h.setTurno(t);
                h.setMedico(m);
                
                horarios.add(h);
            }
        }catch(SQLException ex){
            System.out.println(ex.getMessage());
        }finally{
            DBManager.getInstance().cerrarConexion();
        }
        return horarios;     
    }

    @Override
    public int eliminarPorMedico(int idMedico) {
        Map<Integer,Object> parametrosEntrada = new HashMap<>();
        parametrosEntrada.put(1, idMedico);
        int resultado = DBManager.getInstance().ejecutarProcedimiento("ELIMINAR_HORARIO_X_MEDICO", parametrosEntrada, null);
        return resultado;
    }
    
    

    
}