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
    const url = `${this.apiUrl}/recursos/inventario?TipoLista=${TipoLista}`;
    return this.http.get(url);
  }

  agregar(item: Productos, Token: string): Observable<any> {
    const url = `${this.apiUrl}/recursos/inventario`;
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
    const url = `${this.apiUrl}/recursos/inventario`;
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
    const url = `${this.apiUrl}/recursos/inventario?IdProducto=${item.IdProducto}&Token=${Token}`;
    return this.http.delete(url);
  }

  habilitar(item: Productos, Token: string): Observable<any> {
    const url = `${this.apiUrl}/recursos/inventario/habilitar`;
    const body = {
      IdProducto: item.IdProducto,
      Token: Token
    };
    return this.http.put(url, body);
  }

  // Método para obtener tipos de aumento
  obtenerTiposAumento(): Observable<any> {
    const url = `${this.apiUrl}/recursos/inventario/tipoaumento`;
    return this.http.get(url);
  }

  // Método para obtener aumentos por producto
  getAumentosPorProducto(IdProducto: number): Observable<any> {
    return this.http.get<any>(`${this.apiUrl}/recursos/inventario/aumentoporproducto?IdProducto=${IdProducto}`);
  }

  guardarAumentosProducto(data: any): Observable<any> {
    return this.http.post<any>(`${this.apiUrl}/recursos/inventario/agregaraumento`, data);
  }

  AgregarStock(IdProducto: number, Cantidad: number, token: string): Observable<any> {
    const url = `${this.apiUrl}/recursos/inventario/stock`;
    const body = { IdProducto, Cantidad, Token: token };
    return this.http.post(url, body);
  }

  AumentoEnMasa(productosConAumento, aumentoExtra , token: string): Observable<any> {
    const url = `${this.apiUrl}/recursos/inventario/aumentoEnMasa`;
    const body = { 
      productos: productosConAumento, 
      PorcentajeExtra: aumentoExtra, 
      Token: token, 
    };
    return this.http.put(url, body);
  }
  
    
}
