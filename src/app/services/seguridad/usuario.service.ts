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
    const url = `${this.apiUrl}/seguridad/usuario`;
    const body = {
      IdPersona: item.IdPersona,
      Usuario: item.Usuario,
      Clave: item.Clave,
      Token: Token};
    return this.http.post(url, body);
  }

  editar(usuario: Usuario, token: string): Observable<any> {
    const url = `${this.apiUrl}/SPM_Usuarios`;
    const body = {
      IdUsuario: usuario.IdUsuario,
      NuevoUsuario: usuario.Usuario,
      NuevaClave: usuario.Clave,
      Token: token
    };
    return this.http.put(url, body);
  }

  listarPersonas(): Observable<any> {
    const url = `${this.apiUrl}/SP_ListaPersonas`;
    return this.http.get(url);
  }

  agregarRolUsuario(item: Usuario, Token: string): Observable<any> {
    const url = `${this.apiUrl}/SPA_AgregarRolUsuario`;
    const body = {
      IdUsuario: item.IdUsuario,
      IdRol: item.IdTipoRol,
      Token: Token};
    return this.http.post(url, body);
  }

  listarUsuariosRol(IdUsuario: number): Observable<any> {
    const url = `${this.apiUrl}/SP_ListaUsuariosRol?IdUsuario=${IdUsuario}`;
    return this.http.get(url);
  }

  eliminarUsuarioRol(item: any, Token: string): Observable<any> {
    console.log(item);
    const url = `${this.apiUrl}/SPB_UsuarioRol`;
    const body = {
      IdUsuarioRol: item.IdUsuarioRol,
      Token: Token};
      return this.http.put(url, body);
  }

  modificarUsuarioSucursal(IdUsuario: number, IdSucursal: number, Token: string): Observable<any> {
    const url = `${this.apiUrl}/SPM_UsuarioPorSucursal`;
    const body = {
      IdUsuario: IdUsuario,
      IdSucursal: IdSucursal,
      Token: Token};
      return this.http.put(url, body);
  }

  inhabilitar(item: Usuario, Token: string): Observable<any> {
    const url = `${this.apiUrl}/SPB_Usuarios`;
    const body = {
      IdUsuario: item.IdUsuario,
      Token: Token};
      return this.http.put(url, body);
  }

}
