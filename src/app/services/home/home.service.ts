import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class HomeService {

  private apiUrl = 'http://127.0.0.1:8000/api';

  constructor(private http: HttpClient) {}

    CantPersonalPorSucursal(Token: String): Observable<any> {
      const url = `${this.apiUrl}/SPG_ObtenerCantPersonalPorSucursal?Token=${Token}`;
      return this.http.get(url);
    }

    CantPersonalTotal(Token: String): Observable<any> {
      const url = `${this.apiUrl}/SPG_ObtenerCantPersonalTotal?Token=${Token}`;
      return this.http.get(url);
    }

    ObtenerStockSucursal(Token: String): Observable<any> {
      const url = `${this.apiUrl}/SPG_ObtenerStockSucursal?Token=${Token}`;
      return this.http.get(url);
    }

    ObtenerStockSucursalPorCategoria(Token: String, IdCategoria: number): Observable<any> {
      const url = `${this.apiUrl}/SPG_ObtenerStockSucursalPorCategoria?IdCategoria=${IdCategoria}&Token=${Token}`;
      return this.http.get(url);
    }
    
    ObtenerCantProductos(Token: String): Observable<any> {
      const url = `${this.apiUrl}/SPG_ObtenerCantProductos?Token=${Token}`;
      return this.http.get(url);
    }

    ObtenerCantProductosPorSucursal(Token: String): Observable<any> {
      const url = `${this.apiUrl}/SPG_ObtenerCantProductosPorSucursal?Token=${Token}`;
      return this.http.get(url);
    }

    ObtenerCantProveedores(Token: String): Observable<any> {
      const url = `${this.apiUrl}/SPG_ObtenerCantProveedores?Token=${Token}`;
      return this.http.get(url);
    }

    ObtenerCantClientes(Token: String): Observable<any> {
      const url = `${this.apiUrl}/SPG_ObtenerCantClientes?Token=${Token}`;
      return this.http.get(url);
    }
   
}
