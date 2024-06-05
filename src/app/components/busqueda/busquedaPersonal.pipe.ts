import { Pipe, PipeTransform } from '@angular/core';

@Pipe({
  name: 'busquedaNombreApellidoDni'
})
export class BusquedaNombreApellidoDniPipe implements PipeTransform {

  transform(value: any[], busqueda: string, Nombre: string, Apellido: string): any[] {
    if (!value) return [];
    if (!busqueda) return value;

    busqueda = busqueda.toLowerCase();

    return value.filter(item => {
      const nombre = item[Nombre].toString().toLowerCase();
      const apellido = item[Apellido].toString().toLowerCase();

      return nombre.includes(busqueda) || apellido.includes(busqueda);
    });
  }
}
