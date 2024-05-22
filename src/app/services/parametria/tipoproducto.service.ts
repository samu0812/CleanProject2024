import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Observable } from 'rxjs';
import { TipoProducto } from '../../models/parametria/tipoproducto';

@Injectable({
  providedIn: 'root'
})
export class TipoproductoService {
  private apiUrl = 'http://127.0.0.1:8000/api';

  constructor(private http: HttpClient) {}

  listar(TipoLista: number): Observable<any> {
    const url = `${this.apiUrl}/SPL_TipoProducto?TipoLista=${TipoLista}`;
    return this.http.get(url);
  }

  agregar(item: TipoProducto, Token: string): Observable<any> {
    const url = `${this.apiUrl}/SPA_TipoProducto`;
    const body = {
      Descripcion: item.Detalle,
      Token: Token};
    return this.http.post(url, body);
  }

  editar(item: TipoProducto, Token: string): Observable<any> {
    const url = `${this.apiUrl}/SPM_TipoProducto`;
    const body = {
      IdTipoProducto: item.IdTipoProducto,
      Descripcion: item.Detalle,
      Token: Token};
      return this.http.put(url, body);
  }

  inhabilitar(item: TipoProducto, Token: string): Observable<any> {
    const url = `${this.apiUrl}/SPB_TipoProducto`;
    const body = {
      IdTipoProducto: item.IdTipoProducto,
      Token: Token};
      return this.http.put(url, body);
  }

  habilitar(item: TipoProducto, Token: string): Observable<any> {
    const url = `${this.apiUrl}/SPH_TipoProducto`;
    const body = {
      IdTipoProducto: item.IdTipoProducto,
      Token: Token};
    return this.http.put<TipoProducto[]>(url,body);
  }
}

