import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class TipodestinatariofacturaService {
  private apiUrl= 'http://127.0.0.1:8000/api';

  constructor(private http: HttpClient) { }

  listar(TipoLista: number): Observable<any> {
    const url = `${this.apiUrl}/SPL_TipoDestinatarioFactura?TipoLista=${TipoLista}`;
    return this.http.get(url);
  }

  
}
