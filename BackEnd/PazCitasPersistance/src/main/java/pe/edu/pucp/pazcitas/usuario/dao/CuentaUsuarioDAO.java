/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package pe.edu.pucp.pazcitas.usuario.dao;

import pe.edu.pucp.pazcitas.dao.ICrud;
import pe.edu.pucp.pazcitas.usuario.model.CuentaUsuario;

/**
 *
 * @author Joel
 */
public interface CuentaUsuarioDAO extends ICrud<CuentaUsuario>{
    public int verificarCuentaAdministrador(String username, String password);
    public int verificarCuentaMedico(String username, String password);
    public int verificarCuentaPaciente(String username, String password);
    public int verificarCuenta(String identificador, String password, String rol);
    int verificarUsernameExiste(String username);
}
