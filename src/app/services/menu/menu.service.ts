import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class MenuService {
  private apiUrl = 'http://127.0.0.1:8000/api/';

  constructor(private http: HttpClient) {}

  getMenuItems(token: string): Observable<any> {
    return this.http.get<any>(`${this.apiUrl}SP_GetMenu/?token=${token}`);
  }

  getSubMenuItems(token: string, id_menu: number): Observable<any> {
    console.log(token, id_menu)
    return this.http.get<any>(`${this.apiUrl}SP_GetSubMenu/?token=${token}&id_menu=${id_menu}`);
  }
}
