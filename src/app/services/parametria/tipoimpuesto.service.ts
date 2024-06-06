import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Observable } from 'rxjs';
import { TipoImpuesto } from '../../models/parametria/tipoimpuesto';

@Injectable({
  providedIn: 'root'
})
export class TipoimpuestoService {
  private apiUrl = 'http://127.0.0.1:8000/api';

  constructor(private http: HttpClient) {}

  listar(TipoLista: number): Observable<any> {
    const url = `${this.apiUrl}/parametria/tipoimpuesto?TipoLista=${TipoLista}`;
    return this.http.get(url);
  }

  agregar(item: TipoImpuesto, Token: string): Observable<any> {
    const url = `${this.apiUrl}/parametria/tipoimpuesto`;
    const body = {
      Detalle: item.Detalle,
      Porcentaje: item.Porcentaje,
      Token: Token};
    return this.http.post(url, body);
  }

  editar(item: TipoImpuesto, Token: string): Observable<any> {
    const url = `${this.apiUrl}/parametria/tipoimpuesto`;
    const body = {
      IdTipoImpuesto: item.IdTipoImpuesto,
      Detalle: item.Detalle,
      Porcentaje: item.Porcentaje,
      Token: Token};
      return this.http.put(url, body);
  }

  inhabilitar(item: TipoImpuesto, Token: string): Observable<any> {
    const url = `${this.apiUrl}/parametria/tipoimpuesto`;
    const body = {
      IdTipoImpuesto: item.IdTipoImpuesto,
      Token: Token};
      return this.http.put(url, body);
  }

  habilitar(item: TipoImpuesto, Token: string): Observable<any> {
    const url = `${this.apiUrl}/parametria/tipoimpuesto`;
    const body = {
      IdTipoImpuesto: item.IdTipoImpuesto,
      Token: Token};
    return this.http.put<TipoImpuesto[]>(url,body);
  }
}