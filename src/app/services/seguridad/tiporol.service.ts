import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Observable } from 'rxjs';
import { TipoRol } from '../../models/seguridad/TipoRol';

@Injectable({
  providedIn: 'root'
})
export class TiporolService {
  private apiUrl = 'http://127.0.0.1:8000/api';

  constructor(private http: HttpClient) { }

  listar(TipoLista: number): Observable<any> {
    const url = `${this.apiUrl}/SPL_TipoRol?TipoLista=${TipoLista}`;
    return this.http.get(url);
  }

  agregar(item: TipoRol, Token: string): Observable<any> {
    const url = `${this.apiUrl}/SPA_TipoRol`;
    const body = {
      Descripcion: item.Descripcion,
      Token: Token};
    return this.http.post(url, body);
  }

  editar(item: TipoRol, Token: string): Observable<any> {
    const url = `${this.apiUrl}/SPM_TipoRol`;
    const body = {
      IdTipoCategoria: item.IdTipoRol,
      Descripcion: item.Descripcion,
      Token: Token};
      return this.http.put(url, body);
  }

  inhabilitar(item: TipoRol, Token: string): Observable<any> {
    const url = `${this.apiUrl}/SPB_TipoRol`;
    const body = {
      IdTipoCategoria: item.IdTipoRol,
      Token: Token};
      return this.http.put(url, body);
  }
  habilitar(item: TipoRol, Token: string): Observable<any> {
    const url = `${this.apiUrl}/SPH_TipoRol`;
    const body = {
      IdTipoCategoria: item.IdTipoRol,
      Token: Token};
    return this.http.put<TipoRol[]>(url,body);
  }


}
