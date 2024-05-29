import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { Sucursales } from '../../models/parametria/tiposucursal';// Ajusta la ruta según la ubicación del modelo

@Injectable({
  providedIn: 'root'
})
export class TiposucursalService {
  private apiUrl = 'http://127.0.0.1:8000/api';

  constructor(private http: HttpClient) { }

  listar(TipoLista: number): Observable<any> {
    const url = `${this.apiUrl}/SPL_Sucursal?TipoLista=${TipoLista}`; // Ajusta la ruta según el endpoint correspondiente
    return this.http.get(url);
  }

  agregar(item: Sucursales, Token: string): Observable<any> {
    const url = `${this.apiUrl}/SPA_Sucursal`;
    const body = {
      IdTipoDomicilio: item.IdTipoDomicilio,
      Descripcion: item.Descripcion,
      Calle: item.Calle,
      Nro: item.Nro,
      Piso: item.Piso,
      Token: Token
    };
    return this.http.post(url, body);
  }

  editar(item: Sucursales, Token: string): Observable<any> {
    const url = `${this.apiUrl}/SPM_Sucursal`;
    const body = {
      IdSucursal: item.IdSucursal,
      IdDomicilio: item.IdDomicilio, // Ajusta según la estructura de tu modelo
      IdTipoDomicilio: item.IdTipoDomicilio,
      Descripcion: item.Descripcion,
      Calle: item.Calle,
      Nro: item.Nro,
      Piso: item.Piso,
      Token: Token
    };
    return this.http.put(url, body);
  }

  inhabilitar(item: Sucursales, Token: string): Observable<any> {
    const url = `${this.apiUrl}/SPB_Sucursal`;
    const body = {
      IdSucursal: item.IdSucursal,
      Token: Token
    };
    return this.http.put(url, body);
  }

  habilitar(item: Sucursales, Token: string): Observable<any> {
    const url = `${this.apiUrl}/SPH_Sucursal`;
    const body = {
      IdSucursal: item.IdSucursal,
      Token: Token
    };
    return this.http.put(url, body);
  }
}
