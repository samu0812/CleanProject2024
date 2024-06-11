import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class MenuService {
  private apiUrl = 'http://127.0.0.1:8000/api/';

  constructor(private http: HttpClient) {}

  getMenuItems(Token: string): Observable<any> {
    return this.http.get<any>(`${this.apiUrl}utils/menu/?Token=${Token}`);
  }

  getSubMenuItems(Token: string, IdMenu: number): Observable<any> {
    return this.http.get<any>(`${this.apiUrl}utils/menu/submenu/?Token=${Token}&IdMenu=${IdMenu}`);
  }
}