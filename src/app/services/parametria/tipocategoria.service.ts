import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Observable } from 'rxjs';
import { TipoCategoria } from '../../models/parametria/tipoCategoria'

@Injectable({
  providedIn: 'root'
})
export class TipoCategoriaService {
  private apiUrl = 'http://127.0.0.1:8000/api';

  constructor(private http: HttpClient) {}

  listar(TipoLista: number): Observable<any> {
    const url = `${this.apiUrl}/parametria/tipocategoria?TipoLista=${TipoLista}`;
    return this.http.get(url);
  }

  agregar(item: TipoCategoria, Token: string): Observable<any> {
    const url = `${this.apiUrl}/parametria/tipocategoria`;
    const body = {
      Descripcion: item.Descripcion,
      Token: Token};
    return this.http.post(url, body);
  }

  editar(item: TipoCategoria, Token: string): Observable<any> {
    const url = `${this.apiUrl}/parametria/tipocategoria`;
    const body = {
      IdTipoCategoria: item.IdTipoCategoria,
      Descripcion: item.Descripcion,
      Token: Token};
      return this.http.put(url, body);
  }

  inhabilitar(item: TipoCategoria, Token: string): Observable<any> {
    const url = `${this.apiUrl}/parametria/tipocategoria`;
    const body = {
      IdTipoCategoria: item.IdTipoCategoria,
      Token: Token};
      return this.http.put(url, body);
  }

  habilitar(item: TipoCategoria, Token: string): Observable<any> {
    const url = `${this.apiUrl}/parametria/tipocategoria`;
    const body = {
      IdTipoCategoria: item.IdTipoCategoria,
      Token: Token};
    return this.http.put<TipoCategoria[]>(url,body);
  }
}
