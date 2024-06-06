import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Observable } from 'rxjs';
import { ModulosPorRol } from '../../models/seguridad/modulosporrol';

@Injectable({
  providedIn: 'root'
})
export class ModulosporrolService {

  private apiUrl = 'http://127.0.0.1:8000/api';

  constructor(private http: HttpClient) { }

  listar(TipoLista: number, TipoRol: number): Observable<any> {
    const url = `${this.apiUrl}/seguridad/rolmodulo?IdTipoRol=${TipoRol}&TipoLista=${TipoLista}`;
    const body = {
      IdTipoRol: TipoRol,
      TipoLista: TipoLista};
    return this.http.get(url);
  }

  agregar(item: ModulosPorRol, Token: string): Observable<any> {
    const url = `${this.apiUrl}/seguridad/rolmodulo`;
    const body = {
      IdTipoRol: item.IdTipoRol,
      DescripcionTipoRol: item.DescripcionTipoRol,
      IdTipoModulo: item.IdTipoModulo,
      DetalleTipoModulo: item.DetalleTipoModulo,
      IdTipoPermiso: item.IdTipoPermiso,
      DetalleTipoPermiso: item.DetalleTipoPermiso,
      Token: Token};
    return this.http.post(url, body);
  }

  inhabilitar(item: number, Token: string): Observable<any> {
    const url = `${this.apiUrl}/seguridad/rolmodulo`;
    const body = {
      IdRolModulo: item,
      Token: Token};
      return this.http.put(url, body);
  }
  habilitar(item: ModulosPorRol, Token: string): Observable<any> {
    const url = `${this.apiUrl}/seguridad/rolmodulo`;
    const body = {
      IdTipoRol: item.IdTipoRol,
      DescripcionTipoRol: item.DescripcionTipoRol,
      IdTipoModulo: item.IdTipoModulo,
      DetalleTipoModulo: item.DetalleTipoModulo,
      IdTipoPermiso: item.IdTipoPermiso,
      DetalleTipoPermiso: item.DetalleTipoPermiso,
      Token: Token};
    return this.http.put<ModulosPorRol[]>(url,body);
  }

}
