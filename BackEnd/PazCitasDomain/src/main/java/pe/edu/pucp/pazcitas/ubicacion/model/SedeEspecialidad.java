/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package pe.edu.pucp.pazcitas.ubicacion.model;

import pe.edu.pucp.pazcitas.cita.model.Especialidad;

public class SedeEspecialidad {
    private int idSedeEspecialidad;
    private Sede sede;
    private Especialidad especialidad;
    private boolean asignado;

    public SedeEspecialidad() {
    }

    public int getIdSedeEspecialidad() {
        return idSedeEspecialidad;
    }

    public void setIdSedeEspecialidad(int idSedeEspecialidad) {
        this.idSedeEspecialidad = idSedeEspecialidad;
    }

    public Sede getSede() {
        return sede;
    }

    public void setSede(Sede sede) {
        this.sede = sede;
    }

    public Especialidad getEspecialidad() {
        return especialidad;
    }

    public void setEspecialidad(Especialidad especialidad) {
        this.especialidad = especialidad;
    }

    public boolean isAsignado() {
        return asignado;
    }

    public void setAsignado(boolean asignado) {
        this.asignado = asignado;
    }
    
    
    
    
}
