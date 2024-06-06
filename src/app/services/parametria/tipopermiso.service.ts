import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Observable } from 'rxjs';
import { TipoPermiso } from '../../models/parametria/tipopermiso';
import { TipoPermisoDetalles } from '../../models/parametria/tipopermisodetalle';
@Injectable({
  providedIn: 'root'
})
export class TipopermisoService {
  private apiUrl= 'http://127.0.0.1:8000/api';

  constructor(private http: HttpClient) { }

  listar(): Observable<any> {
    const url = `${this.apiUrl}/parametria/tipopermiso`;
    return this.http.get(url);
  }

  listarDetalle(TipoLista: number): Observable<any> {
    const url = `${this.apiUrl}/parametria/tipopermisodetalle?TipoLista=${TipoLista}`;
    return this.http.get(url);
  }
}
