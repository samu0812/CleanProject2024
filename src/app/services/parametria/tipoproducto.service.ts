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
    const url = `${this.apiUrl}/parametria/tipoproducto?TipoLista=${TipoLista}`;
    return this.http.get(url);
  }

  agregar(item: TipoProducto, Token: string): Observable<any> {
    const url = `${this.apiUrl}/parametria/tipoproducto`;
    const body = {
      Detalle: item.Detalle,
      Token: Token};
    return this.http.post(url, body);
  }

  editar(item: TipoProducto, Token: string): Observable<any> {
    const url = `${this.apiUrl}/parametria/tipoproducto`;
    const body = {
      IdTipoProducto: item.IdTipoProducto,
      Detalle: item.Detalle,
      Token: Token};
      return this.http.put(url, body);
  }

  inhabilitar(item: TipoProducto, Token: string): Observable<any> {
    const url = `${this.apiUrl}/parametria/tipoproducto?IdTipoProducto=${item.IdTipoProducto}&Token=${Token}`;
    return this.http.delete(url);
  }

  

  habilitar(item: TipoProducto, Token: string): Observable<any> {
    const url = `${this.apiUrl}/parametria/tipoproducto`;
    const body = {
      IdTipoProducto: item.IdTipoProducto,
      Token: Token};
    return this.http.put<TipoProducto[]>(url,body);
  }
}

