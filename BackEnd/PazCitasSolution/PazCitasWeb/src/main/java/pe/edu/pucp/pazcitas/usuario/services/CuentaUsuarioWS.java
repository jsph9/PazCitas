/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/WebServices/WebService.java to edit this template
 */
package pe.edu.pucp.pazcitas.usuario.services;

import jakarta.jws.WebService;
import jakarta.jws.WebMethod;
import jakarta.jws.WebParam;
import pe.edu.pucp.pazcitas.usuario.bo.CuentaUsuarioBO;
import pe.edu.pucp.pazcitas.usuario.model.CuentaUsuario;

/**
 *
 * @author Joel
 */
@WebService(serviceName = "CuentaUsuarioWS",
        targetNamespace = "http://services.pucp.edu.pe")
public class CuentaUsuarioWS {

    private CuentaUsuarioBO cuentabo;
    
    @WebMethod(operationName = "insertarCuenta")
    public int insertarCuenta(@WebParam(name = "cuenta") CuentaUsuario cuenta) {
        cuentabo = new CuentaUsuarioBO();
        return cuentabo.insertar(cuenta);
    }
    @WebMethod(operationName = "verificarCuentaAdministrador")
    public int verificarCuentaAdministrador(@WebParam(name = "username") String username,
            @WebParam(name = "contra") String contra) {
        cuentabo = new CuentaUsuarioBO();
        return cuentabo.verificarCuentaAdministrador(username,contra);
    }
    
    @WebMethod(operationName = "verificarCuentaMedico")
    public int verificarCuentaMedico(@WebParam(name = "username") String username,
            @WebParam(name = "contra") String contra) {
        cuentabo = new CuentaUsuarioBO();
        return cuentabo.verificarCuentaMedico(username,contra);
    }
    @WebMethod(operationName = "verificarCuentaPaciente")
    public int verificarCuentaPaciente(@WebParam(name = "username") String username,
            @WebParam(name = "contra") String contra) {
        cuentabo = new CuentaUsuarioBO();
        return cuentabo.verificarCuentaPaciente(username,contra);
    }
    
    //MEtodo Nuevo
    @WebMethod(operationName = "verificarCuenta")
    public int verificarCuentaPorDni(
            @WebParam(name = "identificador") String identificador,
            @WebParam(name = "password") String password,
            @WebParam(name = "rol") String rol) {
        cuentabo = new CuentaUsuarioBO();
        return cuentabo.verificarCuenta(identificador, password, rol);
    }
    
    @WebMethod(operationName = "usernameExiste")
    public boolean usernameExiste(@WebParam(name = "username") String username) {
        cuentabo = new CuentaUsuarioBO();
        return cuentabo.usernameExiste(username);
    }
    
}
