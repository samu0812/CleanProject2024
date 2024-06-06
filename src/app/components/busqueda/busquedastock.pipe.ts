import { Pipe, PipeTransform } from '@angular/core';

@Pipe({
  name: 'busquedastock'
})
export class BusquedastockPipe implements PipeTransform {

  transform(value: any[], busquedastock: string, idField: string, descripcionField: string, Codigo: string, 
    Marca: string, TipoMedida: string, TipoCategoria: string, TipoProducto: string): any[] {
    if (!value) return [];
    if (!busquedastock) return value;

    busquedastock = busquedastock.toLowerCase();

    return value.filter(item => {
      const id = item[idField]?.toString().toLowerCase() || '';
      const descripcion = item[descripcionField]?.toLowerCase() || '';
      const codigo = item[Codigo]?.toLowerCase() || '';
      const marca = item[Marca]?.toLowerCase() || '';
      const tipoMedida = item[TipoMedida]?.toLowerCase() || '';
      const tipoCategoria = item[TipoCategoria]?.toLowerCase() || '';
      const tipoProducto = item[TipoProducto]?.toLowerCase() || '';

      return id.includes(busquedastock) || descripcion.includes(busquedastock)
        || codigo.includes(busquedastock)
        || marca.includes(busquedastock)
        || tipoMedida.includes(busquedastock)
        || tipoCategoria.includes(busquedastock)
        || tipoProducto.includes(busquedastock);
    });
  }
}
