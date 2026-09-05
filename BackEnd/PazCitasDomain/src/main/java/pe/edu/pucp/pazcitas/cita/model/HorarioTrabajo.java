/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package pe.edu.pucp.pazcitas.cita.model;

import pe.edu.pucp.pazcitas.usuario.model.Medico;

public class HorarioTrabajo {
    private int idHorarioTrabajo;
    private Medico medico;
    private Turno turno;
    private boolean activo;

    public int getIdHorarioTrabajo() {
        return idHorarioTrabajo;
    }

    public void setIdHorarioTrabajo(int idHorarioTrabajo) {
        this.idHorarioTrabajo = idHorarioTrabajo;
    }

    public Medico getMedico() {
        return medico;
    }

    public void setMedico(Medico medico) {
        this.medico = medico;
    }

    public Turno getTurno() {
        return turno;
    }

    public void setTurno(Turno turno) {
        this.turno = turno;
    }

    public boolean isActivo() {
        return activo;
    }

    public void setActivo(boolean activo) {
        this.activo = activo;
    }
    
}
