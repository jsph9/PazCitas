/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package pe.edu.pucp.pazcitas.atencion.model;


public class LineaRecetaMedicamento {
    private int idLineaRecetaMedicamento;
    private Receta receta;
    private Medicamento medicamento;
    private int cantidad;
    private boolean activo;

    public int getIdLineaRecetaMedicamento() {
        return idLineaRecetaMedicamento;
    }

    public void setIdLineaRecetaMedicamento(int idLineaRecetaMedicamento) {
        this.idLineaRecetaMedicamento = idLineaRecetaMedicamento;
    }

    public Receta getReceta() {
        return receta;
    }

    public void setReceta(Receta receta) {
        this.receta = receta;
    }

    public Medicamento getMedicamento() {
        return medicamento;
    }

    public void setMedicamento(Medicamento medicamento) {
        this.medicamento = medicamento;
    }

    public int getCantidad() {
        return cantidad;
    }

    public void setCantidad(int cantidad) {
        this.cantidad = cantidad;
    }

    public boolean isActivo() {
        return activo;
    }

    public void setActivo(boolean activo) {
        this.activo = activo;
    }
    
}
