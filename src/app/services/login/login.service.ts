import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class LoginService {

  private apiUrl = 'http://127.0.0.1:8000/api'; // Reemplaza con la URL de tu API

  constructor(private http: HttpClient) { }

  login(usuario: { Usuario: string, Clave: string }): Observable<any> {
    return this.http.post<any[]>(`${this.apiUrl}/usuario`, usuario);


  }
}
