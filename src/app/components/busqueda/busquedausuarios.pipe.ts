import { Pipe, PipeTransform } from '@angular/core';

@Pipe({
  name: 'busquedausuarios'
})
export class BusquedausuariosPipe implements PipeTransform {

  transform(value: any[], busquedausuarios: string, idField: string, Usuario: string, Nombre: string, 
    Apellido: string, Documentacion: string): any[] {
    if (!value) return [];
    if (!busquedausuarios) return value;

    busquedausuarios = busquedausuarios.toLowerCase();

    return value.filter(item => {
      const id = item[idField]?.toString().toLowerCase() || '';
      const usuario = item[Usuario]?.toLowerCase() || '';
      const nombre = item[Nombre]?.toLowerCase() || '';
      const apellido = item[Apellido]?.toLowerCase() || '';
      const documentacion = item[Documentacion]?.toLowerCase() || '';

      return id.includes(busquedausuarios) || usuario.includes(busquedausuarios)
        || nombre.includes(busquedausuarios)
        || apellido.includes(busquedausuarios)
        || documentacion.includes(busquedausuarios);
    });
  }
}
