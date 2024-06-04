import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { Usuario } from '../../models/seguridad/Usuario';


@Injectable({
  providedIn: 'root'
})
export class UsuarioService {
  private apiUrl = 'http://127.0.0.1:8000/api';

  constructor(private http: HttpClient) { }


  listar(TipoLista: number): Observable<any> {
    const url = `${this.apiUrl}/SPL_Usuarios?TipoLista=${TipoLista}`;
    return this.http.get(url);
  }


  agregar(item: Usuario, Token: string): Observable<any> {
    const url = `${this.apiUrl}/SPA_Usuarios`;
    const body = {
      IdPersona: item.IdPersona,
      Usuario: item.Usuario,
      Clave: item.Clave,
      Token: Token};
    return this.http.post(url, body);
  }

  listarPersonas(): Observable<any> {
    const url = `${this.apiUrl}/SP_ListaPersonas`;
    return this.http.get(url);
  }

  agregarRolUsuario(IdUsuario: number, IdRol: number, Token: string): Observable<any> {
    const url = `${this.apiUrl}/SPA_AgregarRolUsuario`;
    const body = {
      IdUsuario: IdUsuario,
      IdRol: IdRol,
      Token: Token};
    return this.http.post(url, body);
  }

  listarUsuariosRol(IdUsuario: number): Observable<any> {
    const url = `${this.apiUrl}/SP_ListaUsuariosRol?IdUsuario=${IdUsuario}`;
    return this.http.get(url);
  }

  eliminarUsuarioRol(IdUsuarioRol: number, Token: string): Observable<any> {
    const url = `${this.apiUrl}/SPB_UsuarioRol`;
    const body = {
      IdUsuarioRol: IdUsuarioRol,
      Token: Token};
      return this.http.put(url, body);
  }

  modificarUsuarioRol(IdUsuarioRol: number, IdSucursal: number, Token: string): Observable<any> {
    const url = `${this.apiUrl}/SPM_UsuarioPorSucursal`;
    const body = {
      IdUsuarioRol: IdUsuarioRol,
      IdSucursal: IdSucursal,
      Token: Token};
      return this.http.put(url, body);
  }

  // inhabilitar(item: TipoCategoria, Token: string): Observable<any> {
  //   const url = `${this.apiUrl}/SPB_TipoCategoria`;
  //   const body = {
  //     IdTipoCategoria: item.IdTipoCategoria,
  //     Token: Token};
  //     return this.http.put(url, body);
  // }

}
