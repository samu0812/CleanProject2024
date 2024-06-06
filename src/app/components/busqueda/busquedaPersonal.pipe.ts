import { Pipe, PipeTransform } from '@angular/core';

@Pipe({
  name: 'busquedaPersonal'
})
export class BusquedaNombreApellidoDniPipe implements PipeTransform {

  transform(value: any[], busquedaPersonal: string, Nombre: string, Apellido: string): any[] {
    if (!value) return [];
    if (!busquedaPersonal) return value;

    busquedaPersonal = busquedaPersonal.toLowerCase();

    return value.filter(item => {
      const nombre = item[Nombre]?.toString().toLowerCase() || '';
      const apellido = item[Apellido]?.toString().toLowerCase() ;

      return nombre.includes(busquedaPersonal) || apellido.includes(busquedaPersonal);
    });
  }
}
