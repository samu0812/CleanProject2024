import { Pipe, PipeTransform } from '@angular/core';

@Pipe({
  name: 'busqueda'
})
export class BusquedaPipe implements PipeTransform {

  transform(value: any[], busqueda: string, idField: string, descripcionField: string): any[] {
    if (!value) return [];
    if (!busqueda) return value;

    busqueda = busqueda.toLowerCase();

    return value.filter(item => {
      const id = item[idField].toString().toLowerCase();
      const descripcion = item[descripcionField].toLowerCase();

      return id.includes(busqueda) || descripcion.includes(busqueda);
    });
  }
}
