/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package pe.edu.pucp.pazcitas.atencion.dao;

import java.util.ArrayList;
import pe.edu.pucp.pazcitas.atencion.model.LineaRecetaMedicamento;
import pe.edu.pucp.pazcitas.dao.ICrud;

/**
 *
 * @author Joel
 */
public interface LineaRecetaMedicamentoDAO extends ICrud<LineaRecetaMedicamento>{
    ArrayList<LineaRecetaMedicamento> listar_lineas_x_receta(int idReceta);
}
