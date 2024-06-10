import { Component, OnInit, OnDestroy , Input  } from '@angular/core';
import { AuthService } from './../../services/auth/auth.service';
import { Menu } from '../../models/menu/menu';
import { ImagenService } from '../../services/imagen/imagen.service';
import { AlertasService } from '../../services/alertas/alertas.service';
import { FormBuilder, FormGroup, Validators, FormControl, FormArray } from '@angular/forms';
import { NgbModal, NgbModalRef } from '@ng-bootstrap/ng-bootstrap';
import { MatCardModule } from '@angular/material/card';
import { HomeService } from '../../services/home/home.service';
import { NgxChartsModule, Color, ColorHelper, ScaleType } from '@swimlane/ngx-charts';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { GraficosService } from '../../services/home/graficos.service';
import { GraficoBarra } from '../../models/home/graficoBarra';

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.css'] // Corregido 'styleUrl' a 'styleUrls'
})
export class HomeComponent implements OnInit, OnDestroy {
  @Input() menu: Menu;
  tituloModal: string;
  tituloBoton: string;
  Token: string;
  imgSubmenu: Menu;
  CantPersonalPorSucursal:[];
  CantPersonalTotal: number;
  StockSucursal:[];
  StockSucursalPorCategoria:[];
  CantProductos: number;
  CantProductosPorSucursal:[];
  CantProveedores: [];
  CantClientes: [];

  graficoPersonalPorSucursal: GraficoBarra = new GraficoBarra({ xAxisLabel: 'Sucursal', yAxisLabel: 'Personal' });

  graficoStockPorSucursal: GraficoBarra = new GraficoBarra({ xAxisLabel: 'Sucursal', yAxisLabel: 'Stock' });
  animations = true;
  constructor(
    private authService: AuthService,
    private modalService: NgbModal,
    private formBuilder: FormBuilder,
    private imagenService: ImagenService,
    private alertasService: AlertasService, // agregue las alertas
    private HomeService : HomeService,
    private GraficosService : GraficosService,
  ) {}

  ngOnInit() {
    // this.authService.iniciarSeguimientoInactividad();
    this.Token = localStorage.getItem('Token');

    this.obtenerDatosGraficos();
  }

  ngOnDestroy() {
    // this.authService.detenerSeguimientoInactividad();
  }

  obtenerDatosGraficos(){
    this.HomeService.CantPersonalPorSucursal(this.Token).subscribe(data => {
      this.CantPersonalPorSucursal = data.cantPersonalSucursal;
      // console.log(this.CantPersonalPorSucursal, 'CantPersonalPorSucursal');
      // console.log(typeof this.CantPersonalPorSucursal, 'CantPersonalPorSucursal typeof');

      const { datosFormateados, coloresPersonalizados } = this.GraficosService.prepararDatosParaGrafico(this.CantPersonalPorSucursal, 'Sucursal', 'cantPersonal');
      this.graficoPersonalPorSucursal.actualizarDatos(datosFormateados, coloresPersonalizados);

    
    });
    this.HomeService.CantPersonalTotal(this.Token).subscribe(data => {
      this.CantPersonalTotal = data.PersonalTotal
      // console.log(this.CantPersonalTotal, 'CantPersonalTotal');
    });
    this.HomeService.ObtenerStockSucursal(this.Token).subscribe(data => {
      this.StockSucursal = data.StockSucursal
      // console.log(this.StockSucursal, 'StockSucursal');
      // console.log(typeof this.StockSucursal, 'this.StockSucursal typeof');

      const { datosFormateados, coloresPersonalizados } = this.GraficosService.prepararDatosParaGrafico(this.StockSucursal, 'Sucursal', 'TotalProductos');
      this.graficoStockPorSucursal.actualizarDatos(datosFormateados, coloresPersonalizados);


      // console.log(this.graficoStockPorSucursal, 'Datos grafico sucursal');
    });
    // this.HomeService.ObtenerStockSucursalPorCategoria(this.Token, 1).subscribe(data => {
    //   this.StockSucursalPorCategoria = data.StockSucursalPorCategoria
    //   // console.log(this.StockSucursalPorCategoria, 'StockSucursalPorCategoria');
    // });
    this.HomeService.ObtenerCantProductos(this.Token).subscribe(data => {
      this.CantProductos = data.CantProductos
      // console.log(this.CantProductos, 'CantProductos');
    });
    // this.HomeService.ObtenerCantProductosPorSucursal(this.Token).subscribe(data => {
    //   this.CantProductosPorSucursal = data.CantProductosPorSucursal
    //   // console.log(this.CantProductosPorSucursal, 'CantProductosPorSucursal');
    // });

    this.HomeService.ObtenerCantProveedores(this.Token).subscribe(data => {
      this.CantProveedores = data.CantProveedores
      console.log(this.CantProveedores, 'CantProveedores');
    });

    this.HomeService.ObtenerCantClientes(this.Token).subscribe(data => {
      this.CantClientes = data.CantClientes
      console.log(this.CantClientes, 'CantClientes');
    });

  }

  // prepararDatosParaGrafico(datos: any[]): { datosFormateados: any[], coloresPersonalizados: any[] } {
  //   // Creamos un array para almacenar los datos formateados para el gráfico
  //   const datosFormateados = [];
    
  //   // Creamos un array para almacenar los colores personalizados
  //   const coloresPersonalizados = [];
    
  //   // Definimos una lista de colores de ejemplo (puedes personalizar esto)
  //   const colores = ['#5AA454', '#A10A28', '#C7B42C', '#AAAAAA', '#1f77b4', '#ff7f0e', '#2ca02c'];
    
  //   // Iteramos sobre los datos recibidos
  //   datos.forEach((dato, index) => {
  //     // Creamos un objeto con el nombre de la sucursal y la cantidad de personal
  //     const datoFormateado = {
  //       name: dato.Sucursal,
  //       value: dato.cantPersonal
  //     };
      
  //     // Agregamos el objeto al array de datos formateados
  //     datosFormateados.push(datoFormateado);
      
  //     // Creamos un objeto de color personalizado para esta sucursal
  //     const colorPersonalizado = {
  //       name: dato.Sucursal,
  //       value: colores[index % colores.length]  // Usamos colores de manera cíclica si hay más datos que colores disponibles
  //     };
      
  //     // Agregamos el objeto de color personalizado al array de colores personalizados
  //     coloresPersonalizados.push(colorPersonalizado);
  //   });
  
  //   // Retornamos el array de datos formateados y los colores personalizados
  //   return { datosFormateados, coloresPersonalizados };
  // }

  onSelect(event) {
    console.log(event);
  }
}
  