import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class TipomoduloService {
  private apiUrl= 'http://127.0.0.1:8000/api';

  constructor(private http: HttpClient) { }

  listar(): Observable<any> {
    const url = `${this.apiUrl}/SPL_TipoModulo`;
    return this.http.get(url);
  }
}
