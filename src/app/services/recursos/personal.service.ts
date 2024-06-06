import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { Personal } from '../../models/recursos/personal';
import { Token } from '@angular/compiler';

@Injectable({
  providedIn: 'root'
})
export class PersonalService {
  private apiUrl = 'http://127.0.0.1:8000/api';

  constructor(private http: HttpClient) { }


  listar(TipoLista: number): Observable<any> {
    const url = `${this.apiUrl}/recursos/personal?TipoLista=${TipoLista}`;
    return this.http.get(url);
  }


  agregarPersonal(personal: Personal, Token: string): Observable<any> {
    const url = `${this.apiUrl}/recursos/personal`;
    const body = {
      IdTipoPersonaSistema: personal.IdTipoPersonaSistema, // Asegúrate de usar el campo correcto
      IdTipoPersona: personal.IdTipoPersona,
      IdTipoDomicilio: personal.IdTipoDomicilio,
      Calle: personal.Calle,
      Nro: personal.Nro,
      Piso: personal.Piso,
      IdLocalidad: personal.IdLocalidad,
      IdTipoDocumentacion: personal.IdTipoDocumentacion,
      Documentacion: personal.Documentacion,
      Nombre: personal.Nombre,
      Apellido: personal.Apellido,
      Mail: personal.Mail,
      FechaNacimiento: personal.FechaNacimiento,
      Telefono: personal.Telefono,
      IdProvincia: personal.IdProvincia,
      Token: Token
    };
    return this.http.post(url, body);
  }

  editar(personal: Personal,Token: string): Observable<any> {
    const url = `${this.apiUrl}/recursos/personal`;
    const body = {
      IdTipoPersona: personal.IdTipoPersona,
      IdPersona: personal.IdPersona,
      IdTipoDomicilio: personal.IdTipoDomicilio,
      Calle: personal.Calle,
      Nro: personal.Nro,
      Piso: personal.Piso,
      IdLocalidad: personal.IdLocalidad,
      IdTipoDocumentacion: personal.IdTipoDocumentacion,
      Documentacion: personal.Documentacion,
      Nombre: personal.Nombre,
      Apellido: personal.Apellido,
      Mail: personal.Mail,
      FechaNacimiento: personal.FechaNacimiento,
      Telefono: personal.Telefono,
      IdProvincia: personal.IdProvincia,
      Token: Token
    };
    console.log(body);
    return this.http.put(url, body);
  }

  inhabilitar(item: Personal , Token: string): Observable<any> {
    const url = `${this.apiUrl}/recursos/personal`;
    const body = {
      IdPersona: item.IdPersona,
      Token: Token
    };
    return this.http.put(url, body);
  }

  habilitar(item: Personal,Token: string): Observable<any> {
    const url = `${this.apiUrl}/recursos/personal`;
    const body = {
      IdPersona: item.IdPersona,
      Token: Token
    };
    return this.http.put(url, body);
  }
}





