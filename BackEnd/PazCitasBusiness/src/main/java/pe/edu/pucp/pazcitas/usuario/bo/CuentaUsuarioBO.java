/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package pe.edu.pucp.pazcitas.usuario.bo;

import pe.edu.pucp.pazcitas.usuario.dao.CuentaUsuarioDAO;
import pe.edu.pucp.pazcitas.usuario.impl.CuentaUsuarioImpl;
import pe.edu.pucp.pazcitas.usuario.model.CuentaUsuario;

/**
 *
 * @author Joel
 */
public class CuentaUsuarioBO {
    private CuentaUsuarioDAO daocuenta;
    
    public CuentaUsuarioBO(){
        daocuenta = new CuentaUsuarioImpl();
    }
    
    public int insertar(CuentaUsuario cuenta){
        return daocuenta.insertar(cuenta);
    }
    public int verificarCuentaPaciente(String username, String contra){
        return daocuenta.verificarCuentaPaciente(username, contra);
    }
    public int verificarCuentaMedico(String username, String contra){
        return daocuenta.verificarCuentaMedico(username, contra);
    }
    public int verificarCuentaAdministrador(String username, String contra){
        return daocuenta.verificarCuentaAdministrador(username, contra);
    }
    
    // Verificación única por DNI, contraseña y rol
    public int verificarCuenta(String identificador, String password, String rol) {
        return daocuenta.verificarCuenta(identificador, password, rol);
    }
    
    public boolean usernameExiste(String username){
        return daocuenta.verificarUsernameExiste(username) != 0;
    }
}
