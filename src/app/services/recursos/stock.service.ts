import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
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
      Marca: item.Marca,
      PrecioCosto: item.PrecioCosto,
      Tamano: item.Tamano,
      CantMinima: item.CantMinima,
      CantMaxima: item.CantMaxima,
      Token: Token
    };
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
    const url = `${this.apiUrl}/recursos/inventario`;
    const body = {
      IdProducto: item.IdProducto,
      Token: Token
    };
    return this.http.put(url, body);
  }

  habilitar(item: Productos, Token: string): Observable<any> {
    const url = `${this.apiUrl}/recursos/inventario`;
    const body = {
      IdProducto: item.IdProducto,
      Token: Token
    };
    return this.http.put(url, body);
  }
}
