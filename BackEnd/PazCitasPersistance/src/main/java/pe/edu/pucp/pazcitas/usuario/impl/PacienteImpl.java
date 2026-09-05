package pe.edu.pucp.pazcitas.usuario.impl;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import pe.edu.pucp.pazcitas.config.DBManager;
import pe.edu.pucp.pazcitas.financiero.model.Seguro;
import pe.edu.pucp.pazcitas.financiero.model.TipoSeguro;
import pe.edu.pucp.pazcitas.usuario.dao.PacienteDAO;
import pe.edu.pucp.pazcitas.usuario.model.Paciente;

public class PacienteImpl implements PacienteDAO {

    private ResultSet rs;

    //ola
    @Override
    public int insertar(Paciente p) {
        Map<Integer, Object> parametrosSalida = new HashMap<>();
        Map<Integer, Object> parametrosEntrada = new HashMap<>();
        parametrosSalida.put(1, Types.INTEGER);
        parametrosEntrada.put(2, p.getNombre());
        parametrosEntrada.put(3, p.getApellidoPaterno());
        parametrosEntrada.put(4, p.getApellidoMaterno());
        parametrosEntrada.put(5, p.getDni());
        parametrosEntrada.put(6, p.getEmail());
        parametrosEntrada.put(7, p.getFechaNacimiento());
        parametrosEntrada.put(8, String.valueOf(p.getGenero()));
        parametrosEntrada.put(9, p.getDireccion());
        parametrosEntrada.put(10, p.getTelefono());
        parametrosEntrada.put(11, p.getSeguro().getIdSeguro());
        DBManager.getInstance().ejecutarProcedimiento("INSERTAR_PACIENTE", parametrosEntrada, parametrosSalida);
        p.setIdUsuario((int) parametrosSalida.get(1));
        return p.getIdUsuario();
    }

    @Override
    public int modificar(Paciente p) {
        Map<Integer, Object> parametrosEntrada = new HashMap<>();
        parametrosEntrada.put(1, p.getIdUsuario());
        parametrosEntrada.put(2, p.getNombre());
        parametrosEntrada.put(3, p.getApellidoPaterno());
        parametrosEntrada.put(4, p.getApellidoMaterno());
        parametrosEntrada.put(5, p.getDni());
        parametrosEntrada.put(6, p.getEmail());
        parametrosEntrada.put(7, p.getFechaNacimiento());
        parametrosEntrada.put(8, String.valueOf(p.getGenero()));
        parametrosEntrada.put(9, p.getDireccion());
        parametrosEntrada.put(10, p.getTelefono());
        parametrosEntrada.put(11, p.getSeguro().getIdSeguro());
        int resultado = DBManager.getInstance().ejecutarProcedimiento("MODIFICAR_PACIENTE", parametrosEntrada, null);
        return resultado;
    }

    @Override
    public int eliminar(int idPaciente) {
        Map<Integer, Object> parametrosEntrada = new HashMap<>();
        parametrosEntrada.put(1, idPaciente);
        int resultado = DBManager.getInstance().ejecutarProcedimiento("ELIMINAR_PACIENTE", parametrosEntrada, null);
        return resultado;
    }

    @Override
    public ArrayList<Paciente> listarTodos() {
        ArrayList<Paciente> pacientes = null;
        rs = DBManager.getInstance().ejecutarProcedimientoLectura("LISTAR_PACIENTE_TODOS", null);
        try {
            while (rs.next()) {
                if (pacientes == null) {
                    pacientes = new ArrayList<>();
                }
                Paciente p = new Paciente();
                p.setIdUsuario(rs.getInt("id_usuario"));
                p.setNombre(rs.getString("nombre"));
                p.setApellidoPaterno(rs.getString("apellido_paterno"));
                p.setApellidoMaterno(rs.getString("apellido_materno"));
                p.setDni(rs.getString("dni"));
                p.setEmail(rs.getString("email"));
                p.setFechaNacimiento(rs.getDate("fecha_nacimiento"));
                p.setGenero(rs.getString("genero").charAt(0));
                p.setDireccion(rs.getString("direccion"));
                p.setTelefono(rs.getString("telefono"));

                Seguro s = new Seguro();
                s.setIdSeguro(rs.getInt("id_seguro"));
                s.setNombreSeguro(rs.getString("nombre_seguro"));

                TipoSeguro estadoAtencion = TipoSeguro.valueOf(rs.getString("tipo").toUpperCase());
                s.setTipo(estadoAtencion);
                s.setPorcentajeCobertura(rs.getDouble("porcentaje_cobertura"));
                s.setVigencia(rs.getDate("vigencia"));

                p.setSeguro(s);
                pacientes.add(p);
            }
        } catch (SQLException ex) {
            System.out.println(ex.getMessage());
        } finally {
            DBManager.getInstance().cerrarConexion();
        }
        return pacientes;
    }

    @Override
    public Paciente obtenerPorID(int idPaciente) {
        Paciente p = null;
        Map<Integer, Object> parametrosEntrada = new HashMap<>();
        parametrosEntrada.put(1, idPaciente);
        rs = DBManager.getInstance().ejecutarProcedimientoLectura("OBTENER_PACIENTE_X_ID", parametrosEntrada);
        try {
            while (rs.next()) {
                if (p == null) {
                    p = new Paciente();
                }
                p.setIdUsuario(rs.getInt("id_usuario"));
                p.setNombre(rs.getString("nombre"));
                p.setApellidoPaterno(rs.getString("apellido_paterno"));
                p.setApellidoMaterno(rs.getString("apellido_materno"));
                p.setDni(rs.getString("dni"));
                p.setEmail(rs.getString("email"));
                p.setFechaNacimiento(rs.getDate("fecha_nacimiento"));
                p.setGenero(rs.getString("genero").charAt(0));
                p.setDireccion(rs.getString("direccion"));
                p.setTelefono(rs.getString("telefono"));

                Seguro s = new Seguro();
                s.setIdSeguro(rs.getInt("id_seguro"));
                s.setNombreSeguro(rs.getString("nombre_seguro"));

                TipoSeguro estadoAtencion = TipoSeguro.valueOf(rs.getString("tipo").toUpperCase());
                s.setTipo(estadoAtencion);
                s.setPorcentajeCobertura(rs.getDouble("porcentaje_cobertura"));
                s.setVigencia(rs.getDate("vigencia"));

                p.setSeguro(s);
            }
        } catch (SQLException ex) {
            System.out.println(ex.getMessage());
        } finally {
            DBManager.getInstance().cerrarConexion();
        }
        return p;
    }

    @Override
    public Paciente obtenerPorDNI(String dni) {
        Paciente p = null;
        Map<Integer, Object> parametrosEntrada = new HashMap<>();
        parametrosEntrada.put(1, dni);
        rs = DBManager.getInstance().ejecutarProcedimientoLectura("OBTENER_PACIENTE_X_DNI", parametrosEntrada);
        try {
            while (rs.next()) {
                if (p == null) {
                    p = new Paciente();
                }
                p.setIdUsuario(rs.getInt("id_usuario"));
                p.setNombre(rs.getString("nombre"));
                p.setApellidoPaterno(rs.getString("apellido_paterno"));
                p.setApellidoMaterno(rs.getString("apellido_materno"));
                p.setDni(rs.getString("dni"));
                p.setEmail(rs.getString("email"));
                p.setFechaNacimiento(rs.getDate("fecha_nacimiento"));
                p.setGenero(rs.getString("genero").charAt(0));
                p.setDireccion(rs.getString("direccion"));
                p.setTelefono(rs.getString("telefono"));

                Seguro s = new Seguro();
                s.setIdSeguro(rs.getInt("id_seguro"));
                s.setNombreSeguro(rs.getString("nombre_seguro"));

                TipoSeguro estadoAtencion = TipoSeguro.valueOf(rs.getString("tipo").toUpperCase());
                s.setTipo(estadoAtencion);
                s.setPorcentajeCobertura(rs.getDouble("porcentaje_cobertura"));
                s.setVigencia(rs.getDate("vigencia"));

                p.setSeguro(s);
            }
        } catch (SQLException ex) {
            System.out.println(ex.getMessage());
        } finally {
            DBManager.getInstance().cerrarConexion();
        }
        return p;
    }

    @Override
    public ArrayList<Paciente> obtenerPorCadena(String cadena) {
        ArrayList<Paciente> pacientes = null;
        Map<Integer, Object> parametrosEntrada = new HashMap<>();
        parametrosEntrada.put(1, cadena);
        rs = DBManager.getInstance().ejecutarProcedimientoLectura("OBTENER_PACIENTE_X_CADENA", parametrosEntrada);
        try {
            while (rs.next()) {
                if (pacientes == null) {
                    pacientes = new ArrayList<>();
                }
                Paciente p = new Paciente();
                p.setIdUsuario(rs.getInt("id_usuario"));
                p.setNombre(rs.getString("nombre"));
                p.setApellidoPaterno(rs.getString("apellido_paterno"));
                p.setApellidoMaterno(rs.getString("apellido_materno"));
                p.setDni(rs.getString("dni"));
                p.setEmail(rs.getString("email"));
                p.setFechaNacimiento(rs.getDate("fecha_nacimiento"));
                p.setGenero(rs.getString("genero").charAt(0));
                p.setDireccion(rs.getString("direccion"));
                p.setTelefono(rs.getString("telefono"));

                Seguro s = new Seguro();
                s.setIdSeguro(rs.getInt("id_seguro"));
                s.setNombreSeguro(rs.getString("nombre_seguro"));

                TipoSeguro estadoAtencion = TipoSeguro.valueOf(rs.getString("tipo").toUpperCase());
                s.setTipo(estadoAtencion);
                s.setPorcentajeCobertura(rs.getDouble("porcentaje_cobertura"));
                s.setVigencia(rs.getDate("vigencia"));

                p.setSeguro(s);
                pacientes.add(p);
            }
        } catch (SQLException ex) {
            System.out.println(ex.getMessage());
        } finally {
            DBManager.getInstance().cerrarConexion();
        }
        return pacientes;
    }
    
}
