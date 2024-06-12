import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class localidadesPorProvService {
  private apiUrl = 'http://127.0.0.1:8000/api';
  constructor(private http: HttpClient) { }


  listar(IdProvincia: number): Observable<any> {
    const url = `${this.apiUrl}/lista/localidadesporprov?IdProvincia=${IdProvincia}`;
    return this.http.get(url);
  }

}
