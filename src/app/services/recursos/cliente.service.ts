import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Observable } from 'rxjs';
import { cliente } from '../../models/recursos/cliente';

@Injectable({
  providedIn: 'root'
})
export class ClienteService {
  private apiUrl = 'http://127.0.0.1:8000/api';
  constructor(private http: HttpClient) { }


  listar(TipoLista: number): Observable<any> {
    const url = `${this.apiUrl}/recursos/clientes?TipoLista=${TipoLista}`;
    return this.http.get(url);
  }

  agregar(item: cliente, Token: string): Observable<any> {
    const url = `${this.apiUrl}/recursos/clientes`;
    const body = {
      IdTipoPersona: item.IdTipoPersona,
      IdTipoDomicilio: item.IdTipoDomicilio,
      Calle: item.Calle,
      Nro: item.Nro,
      Piso: item.Piso,
      IdLocalidad: item.IdLocalidad,
      IdTipoDocumentacion: item.IdTipoDocumentacion,
      Documentacion: item.Documentacion,
      Nombre: item.Nombre,
      Apellido: item.Apellido,
      Mail: item.Mail,
      RazonSocial: item.RazonSocial,
      FechaNacimiento: item.FechaNacimiento,
      Telefono: item.Telefono,
      IdProvincia: item.IdProvincia,
      Token: Token
    };
    return this.http.post(url, body);
  }

  editar(item: cliente, Token: string): Observable<any> {
    const url = `${this.apiUrl}/recursos/clientes`;
    const body = {
      IdCliente: item.IdCliente,
      IdTipoPersona: item.IdTipoPersona,
      IdTipoDomicilio: item.IdTipoDomicilio,
      Calle: item.Calle,
      Nro: item.Nro,
      Piso: item.Piso,
      IdLocalidad: item.IdLocalidad,
      IdTipoDocumentacion: item.IdTipoDocumentacion,
      Documentacion: item.Documentacion,
      Nombre: item.Nombre,
      Apellido: item.Apellido,
      Mail: item.Mail,
      RazonSocial: item.RazonSocial,
      FechaNacimiento: item.FechaNacimiento,
      Telefono: item.Telefono,
      IdProvincia: item.IdProvincia,
      Token:Token
    };
    console.log(body);
    return this.http.put(url, body);
  }

  inhabilitar(item: cliente , Token: string): Observable<any> {
    const url = `${this.apiUrl}/recursos/clientes?IdCliente=${item.IdCliente}&Token=${Token}`;
    return this.http.delete(url);
  }

  habilitar(item: cliente, Token: string): Observable<any> {
    const url = `${this.apiUrl}/recursos/clientes/habilitar`;
    const body = {
      IdCliente: item.IdCliente,
      Token:Token
    };
    return this.http.put(url, body);
  }
}
