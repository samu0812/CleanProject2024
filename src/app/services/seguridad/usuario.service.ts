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
    const url = `${this.apiUrl}/seguridad/usuario?TipoLista=${TipoLista}`;
    return this.http.get(url);
  }


  agregar(item: Usuario, Token: string): Observable<any> {
    const url = `${this.apiUrl}/seguridad/usuarios`;
    const body = {
      IdPersona: item.IdPersona,
      Usuario: item.Usuario,
      Clave: item.Clave,
      Token: Token};
    return this.http.post(url, body);
  }

  editar(item: Usuario, Token: string): Observable<any> {
    const url = `${this.apiUrl}/seguridad/usuarios`;
    const body = {
      IdUsuario: item.IdUsuario,
      NuevoUsuario: item.Usuario,
      NuevaClave: item.Clave,
      Token: Token};
      return this.http.put(url, body);
  }

  listarPersonas(): Observable<any> {
    const url = `${this.apiUrl}/lista/personas`;
    return this.http.get(url);
  }

  agregarRolUsuario(item: Usuario, Token: string): Observable<any> {
    const url = `${this.apiUrl}/seguridad/usuarios/rol`;
    const body = {
      IdUsuario: item.IdUsuario,
      IdRol: item.IdTipoRol,
      Token: Token};
    return this.http.post(url, body);
  }

  listarUsuariosRol(IdUsuario: number): Observable<any> {
    const url = `${this.apiUrl}/seguridad/usuarios/rol?IdUsuario=${IdUsuario}`;
    return this.http.get(url);
  }

  eliminarUsuarioRol(item: any, Token: string): Observable<any> {
    const url = `${this.apiUrl}/seguridad/usuarios?IdUsuarioRol=${item.IdUsuarioRol}&Token=${Token}`;
    return this.http.delete(url);
  }

  modificarUsuarioSucursal(IdUsuario: number, IdSucursal: number, Token: string): Observable<any> {
    const url = `${this.apiUrl}/seguridad/usuarios/sucursal`;
    const body = {
      IdUsuario: IdUsuario,
      IdSucursal: IdSucursal,
      Token: Token};
      return this.http.put(url, body);
  }

  inhabilitar(item: Usuario, Token: string): Observable<any> {
    const url = `${this.apiUrl}/seguridad/usuarios?IdUsuario=${item.IdUsuario}&Token=${Token}`;
    return this.http.delete(url);
  }

}
