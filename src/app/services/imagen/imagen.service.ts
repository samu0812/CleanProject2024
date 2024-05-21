import { Injectable } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class ImagenService {

  private apiUrl = 'http://127.0.0.1:8000/api/SP_GetImagenSubMenu';

  constructor(private http: HttpClient) { }

  getImagenSubMenu(Path: string): Observable<any> {
    const params = new HttpParams().set('Path', Path);
    return this.http.get<any>(this.apiUrl, { params });
  }
}
