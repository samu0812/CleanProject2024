import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Observable } from 'rxjs';
import { TipoFormaDePago } from '../../models/parametria/tipoformadepago';

@Injectable({
  providedIn: 'root'
})
export class TipoformadepagoService {

  private apiUrl = 'http://127.0.0.1:8000/api';

  constructor(private http: HttpClient) {}

  listar(TipoLista: number): Observable<any> {
    const url = `${this.apiUrl}/parametria/tipoformadepago?TipoLista=${TipoLista}`;
    return this.http.get(url);
  }

  agregar(item: TipoFormaDePago, Token: string): Observable<any> {
    const url = `${this.apiUrl}/parametria/tipoformadepago`;
    const body = {
      Descripcion: item.Descripcion,
      Token: Token};
    return this.http.post(url, body);
  }

  editar(item: TipoFormaDePago, Token: string): Observable<any> {
    const url = `${this.apiUrl}/parametria/tipoformadepago`;
    const body = {
      IdTipoFormaDePago: item.IdTipoFormaDePago,
      Descripcion: item.Descripcion,
      Token: Token};
      return this.http.put(url, body);
  }

  inhabilitar(item: TipoFormaDePago, Token: string): Observable<any> {
    const url = `${this.apiUrl}/parametria/tipoformadepago`;
    const body = {
      IdTipoFormaDePago: item.IdTipoFormaDePago,
      Token: Token};
      return this.http.put(url, body);
  }

  habilitar(item: TipoFormaDePago, Token: string): Observable<any> {
    const url = `${this.apiUrl}/parametria/tipoformadepago`;
    const body = {
      IdTipoFormaDePago: item.IdTipoFormaDePago,
      Token: Token};
    return this.http.put<TipoFormaDePago[]>(url,body);
  }
}