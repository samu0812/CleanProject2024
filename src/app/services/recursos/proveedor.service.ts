import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { Token } from '@angular/compiler';
import { Proveedor } from '../../models/recursos/proveedor';

@Injectable({
  providedIn: 'root'
})
export class ProveedorService {
  private apiUrl = 'http://127.0.0.1:8000/api';

  constructor(private http: HttpClient) { }


  listar(TipoLista: number): Observable<any> {
    const url = `${this.apiUrl}/SPL_Proveedor?TipoLista=${TipoLista}`;
    return this.http.get(url);
  }


  agregarProveedor(proveedor: Proveedor, Token: string): Observable<any> {
    const url = `${this.apiUrl}/SPA_Proveedor`;
    const body = {
      IdTipoPersona: proveedor.IdTipoPersona,
      IdTipoDomicilio: proveedor.IdTipoDomicilio,
      Calle: proveedor.Calle,
      Nro: proveedor.Nro,
      Piso: proveedor.Piso,
      IdLocalidad: proveedor.IdLocalidad,
      IdTipoDocumentacion: proveedor.IdTipoDocumentacion,
      Documentacion: proveedor.Documentacion,
      Mail: proveedor.Mail,
      RazonSocial:proveedor.RazonSocial,
      Telefono: proveedor.Telefono,
      IdProvincia: proveedor.IdProvincia,
      Token: Token
    };
    return this.http.post(url, body);
  }

  editar(proveedor: Proveedor,Token: string): Observable<any> {
    const url = `${this.apiUrl}/SPM_Proveedor`;
    const body = {
      IdTipoPersona: proveedor.IdTipoPersona,
      IdPersona: proveedor.IdPersona,
      IdTipoDomicilio: proveedor.IdTipoDomicilio,
      Calle: proveedor.Calle,
      Nro: proveedor.Nro,
      Piso: proveedor.Piso,
      IdLocalidad: proveedor.IdLocalidad,
      IdTipoDocumentacion: proveedor.IdTipoDocumentacion,
      Documentacion: proveedor.Documentacion,
      Mail: proveedor.Mail,
      RazonSocial:proveedor.RazonSocial,
      Telefono: proveedor.Telefono,
      IdProvincia: proveedor.IdProvincia,
      Token: Token
    };
    console.log(body);
    return this.http.put(url, body);
  }

  inhabilitar(item: Proveedor , Token: string): Observable<any> {
    const url = `${this.apiUrl}/SPB_Proveedor`;
    const body = {
      IdPersona: item.IdPersona,
      Token: Token
    };
    return this.http.put(url, body);
  }

  habilitar(item: Proveedor,Token: string): Observable<any> {
    const url = `${this.apiUrl}/SPH_Proveedor`;
    const body = {
      IdPersona: item.IdPersona,
      Token: Token
    };
    return this.http.put(url, body);
  }
}





