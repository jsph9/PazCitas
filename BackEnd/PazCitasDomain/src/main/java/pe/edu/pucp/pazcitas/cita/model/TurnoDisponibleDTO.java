/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package pe.edu.pucp.pazcitas.cita.model;

import java.util.Date;

/**
 *
 * @author andre
 */
public class TurnoDisponibleDTO {
     private Date fecha;
    private DiaSemana dia;
    private Date horaInicio;
    private Date horaFin;
    private int idHorarioTrabajo;

    public int getIdHorarioTrabajo() {
        return idHorarioTrabajo;
    }

    public void setIdHorarioTrabajo(int idHorarioTrabajo) {
        this.idHorarioTrabajo = idHorarioTrabajo;
    }

    // Getters
    public Date getFecha() {
        return fecha;
    }

    public DiaSemana getDia() {
        return dia;
    }

    public Date getHoraInicio() {
        return horaInicio;
    }

    public Date getHoraFin() {
        return horaFin;
    }

    // Setters
    public void setFecha(Date fecha) {
        this.fecha = fecha;
    }

    public void setDia(DiaSemana dia) {
        this.dia = dia;
    }

    public void setHoraInicio(Date horaInicio) {
        this.horaInicio = horaInicio;
    }

    public void setHoraFin(Date horaFin) {
        this.horaFin = horaFin;
    }
    
}
