import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, map, tap } from 'rxjs';
import { Productos } from '../../models/recursos/productos';

@Injectable({
  providedIn: 'root'
})
export class StockService {

  private apiUrl = 'http://127.0.0.1:8000/api';

  constructor(private http: HttpClient) {}

  listar(TipoLista: number): Observable<any> {
    const url = `${this.apiUrl}/SPL_Producto?TipoLista=${TipoLista}`;
    return this.http.get(url);
  }

  agregar(item: Productos, Token: string): Observable<any> {
    const url = `${this.apiUrl}/SPA_Producto`;
    const body = {
      IdTipoMedida: item.IdTipoMedida,
      IdTipoCategoria: item.IdTipoCategoria,
      IdTipoProducto: item.IdTipoProducto,
      Codigo: item.Codigo,
      Nombre: item.Nombre,
      IdPersona: item.IdPersona,
      Marca: item.Marca,
      PrecioCosto: item.PrecioCosto,
      Tamano: item.Tamano,
      CantMinima: item.CantMinima,
      CantMaxima: item.CantMaxima,
      Token: Token
    };

    console.log(body);

    return this.http.post(url, body);
  }

  editar(item: Productos, Token: string): Observable<any> {
    const url = `${this.apiUrl}/SPM_Producto`;
    const body = {
      IdProducto: item.IdProducto,
      IdTipoMedida: item.IdTipoMedida,
      IdTipoCategoria: item.IdTipoCategoria,
      IdTipoProducto: item.IdTipoProducto,
      Codigo: item.Codigo,
      Nombre: item.Nombre,
      IdPersona: item.IdPersona,
      Marca: item.Marca,
      PrecioCosto: item.PrecioCosto,
      Tamano: item.Tamano,
      CantMinima: item.CantMinima,
      CantMaxima: item.CantMaxima,
      Token: Token
    };
    console.log(body);
    return this.http.put(url, body);
  }

  inhabilitar(item: Productos, Token: string): Observable<any> {
    const url = `${this.apiUrl}/SPB_Producto`;
    const body = {
      IdProducto: item.IdProducto,
      Token: Token
    };
    return this.http.put(url, body);
  }

  habilitar(item: Productos, Token: string): Observable<any> {
    const url = `${this.apiUrl}/SPH_Producto`;
    const body = {
      IdProducto: item.IdProducto,
      Token: Token
    };
    return this.http.put(url, body);
  }

  // Método para obtener tipos de aumento
  obtenerTiposAumento(): Observable<any> {
    const url = `${this.apiUrl}/SPL_TipoAumento`;
    return this.http.get(url);
  }

  // Método para obtener aumentos por producto
  getAumentosPorProducto(IdProducto: number): Observable<any> {
    return this.http.get<any>(`${this.apiUrl}/SPL_AumentoPorProducto?IdProducto=${IdProducto}`);
  }

  guardarAumentosProducto(data: any): Observable<any> {
    return this.http.post<any>(`${this.apiUrl}/guardarAumentosProducto`, data);
  }

  AgregarStock(IdProducto: number, Cantidad: number, token: string): Observable<any> {
    const url = `${this.apiUrl}/recursos/inventario/stock`;
    const body = { IdProducto, Cantidad, Token: token };
    return this.http.post(url, body);
  }
  
    
}
