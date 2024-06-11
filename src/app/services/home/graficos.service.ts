import { Injectable } from '@angular/core';

@Injectable({
  providedIn: 'root'
})
export class GraficosService {
  // Definimos una lista de colores de ejemplo (puedes personalizar esto)
  // private colores = ['#5AA454', '#A10A28', '#C7B42C', '#AAAAAA', '#1f77b4', '#ff7f0e', '#2ca02c'];
  private colores = ['#FF8C00', '#FFB066', '#8f1e00', '#FF8C00', '#FF9D33', '#0042FF', '#8000FF', '#FB00FF', '#FF0013'];

  prepararDatosParaGrafico(datos: any[], keyName: string, keyValue: string): { datosFormateados: any[], coloresPersonalizados: any[] } {
    const datosFormateados = [];
    const coloresPersonalizados = [];
    
    datos.forEach((dato, index) => {
      const datoFormateado = {
        name: dato[keyName],
        value: parseFloat(dato[keyValue]) // Convertir el valor a número
      };
      
      datosFormateados.push(datoFormateado);
      
      const colorPersonalizado = {
        name: dato[keyName],
        value: this.colores[index % this.colores.length]
      };
      
      coloresPersonalizados.push(colorPersonalizado);
    });
    
    return { datosFormateados, coloresPersonalizados };
  }
}
