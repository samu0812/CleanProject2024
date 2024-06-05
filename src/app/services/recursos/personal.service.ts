import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { Personal } from '../../models/recursos/personal';

@Injectable({
  providedIn: 'root'
})
export class PersonalService {
  private apiUrl = 'http://127.0.0.1:8000/api';

  constructor(private http: HttpClient) { }


  listar(TipoLista: number): Observable<any> {
    const url = `${this.apiUrl}/SPL_Personal?TipoLista=${TipoLista}`;
    return this.http.get(url);
  }


  agregarPersonal(personal: Personal): Observable<any> {
    const url = `${this.apiUrl}/SPA_Personal`;
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
    };
    return this.http.post(url, body);
  }
}


  // editar(item: Usuario, Token: string): Observable<any> {
  //   const url = `${this.apiUrl}/SPM_TipoCategoria`;
  //   const body = {
  //     IdTipoCategoria: item.IdTipoCategoria,
  //     Descripcion: item.Descripcion,
  //     Token: Token};
  //     return this.http.put(url, body);
  // }





