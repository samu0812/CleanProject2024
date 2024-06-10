import { Component, OnInit, Input, TemplateRef } from '@angular/core';
import { NgbModalRef } from '@ng-bootstrap/ng-bootstrap';
import { FormBuilder, FormGroup, Validators, FormControl } from '@angular/forms';
import { NgIfContext } from '@angular/common';
import { AlertasService } from '../../../services/alertas/alertas.service';
import { ImagenService } from '../../../services/imagen/imagen.service';
import { SnackbarService } from '../../../services/snackbar/snackbar.service';
import { TipofacturaService } from '../../../services/parametria/tipofactura.service';
import { TipoformadepagoService } from '../../../services/parametria/tipoformadepago.service';
import { StockService } from '../../../services/recursos/stock.service';
import { Menu } from '../../../models/menu/menu';
import { TipoFacturas } from '../../../models/parametria/tipofactura';
import { TipoFormaDePago } from '../../../models/parametria/tipoformadepago';
import { Productos } from '../../../models/recursos/productos';
import  jsPDF from 'jspdf';
import autoTable  from 'jspdf-autotable';

@Component({
  selector: 'app-realizarventa',
  templateUrl: './realizarventa.component.html',
  styleUrl: './realizarventa.component.css'
})
export class RealizarventaComponent implements OnInit {
  @Input() menu: Menu;
  tituloModal: string;
  tituloBoton: string;
  itemGrilla: Productos; 
  listaGrilla: Productos[]; 
  modalRef: NgbModalRef;
  formItemGrilla: FormGroup;
  formFiltro: FormGroup;
  Token: string;
  imgSubmenu: Menu;
  paginaActual = 1;
  elementosPorPagina = 10;
  loading: boolean = true;
  Busqueda = "";
  noData: TemplateRef<NgIfContext<boolean>>;
  showToast: boolean = false;
  toastTimeout: any;
  lTipoFacturas: TipoFacturas[];
  lFormaDePago: TipoFormaDePago[];

  constructor(
    private stockService: StockService,
    private formBuilder: FormBuilder,
    private imagenService: ImagenService,
    private alertasService: AlertasService,
    private snackbarService: SnackbarService,
    private tipofacturaService: TipofacturaService, 
    private tipoformadepagoService: TipoformadepagoService
  ) {}

  ngOnInit(): void {
    this.obtenerImgMenu();
    this.Token = localStorage.getItem('Token');
    this.formItemGrilla = this.formBuilder.group({
      descripcion: new FormControl('', [Validators.required])
    });

    this.formFiltro = this.formBuilder.group({
      idFiltro: new FormControl('1', [Validators.required]),
      busqueda: new FormControl('') // Control de búsqueda
    });

    this.listar(1);

    this.formFiltro.get('idFiltro').valueChanges.subscribe(value => {
      this.listar(value);
    });

    this.formFiltro.get('busqueda').valueChanges.subscribe(value => {
      this.Busqueda = value;
    });
    this.obtenerListas();
  }
  imprimirTicketPDF(): void {
    const doc = new jsPDF();
  
    
    // Agregar imagen del logo
    const logo = new Image();
    logo.src = '../../../../assets/img/cleanlogo.png'; // Ajusta la ruta de acuerdo a la ubicación de tu imagen
    
    // Información de la empresa
    doc.setFontSize(8);
    doc.addImage(logo, 'PNG', 10, 10, 50, 30); // Ajusta las coordenadas y dimensiones según tu preferencia
    doc.setFontSize(12);
    doc.text('Fecha: ' + new Date().toLocaleDateString(), 170,10);
    doc.setFontSize(8);
    doc.text('Formosa Argentina', 70, 20); // Ajusta las coordenadas según tu preferencia
    doc.text('Teléfono: (123) 456-7890', 70, 25);
    doc.text('Email: cleanfsa@empresa.com', 70, 30);
    doc.text('Documento: Ticket/Factura', 70, 35);
    
    // Encabezados de la tabla
    const headers = [
      ['Código Producto', 'Producto', 'Precio Unitario', 'Marca', 'Cantidad', 'Precio por Cantidad']
    ];
    
    // Datos de la tabla (estos son ejemplos, debes reemplazarlos con tus datos reales)
    const data = [
      ['111111', 'Detergente', '1000', 'Ariel', '2', '2000'],
      // Agrega más filas según sea necesario
    ];
    
    // Posición de inicio de la tabla
    let startY = 50;
    
  // Dibujar la tabla
  autoTable(doc, {
    head: headers,
    body: data,
    startY: startY,
    styles: { 
      fontSize: 10,
      fillColor: '#FFA07A', // Color de fondo de las celdas de encabezado
      textColor: 'white' // Color del texto en las celdas de encabezado
    },
    columnStyles: {
      0: { textColor: 'black' }, // Establecer el color del texto de la primera columna a negro
      1: { textColor: 'black' }, // Establecer el color del texto de la segunda columna a negro
      2: { textColor: 'black' }, // Establecer el color del texto de la tercera columna a negro
      3: { textColor: 'black' }, // Establecer el color del texto de la cuarta columna a negro
      4: { textColor: 'black' }, // Establecer el color del texto de la quinta columna a negro
      5: { textColor: 'black' }  // Establecer el color del texto de la sexta columna a negro
    }
  });
    
    // Posición después de la tabla
    const finalY = (doc as any).lastAutoTable.finalY;
    
    // Totales
    doc.text('Subtotal: S./ 0.00', 10, finalY + 10);
    doc.text('Descuentos: S./ 0.00', 10, finalY + 15);
    doc.text('Vuelto: S./ 0.00', 10, finalY + 20);
    doc.text('Total: S./ 0.00', 10, finalY + 25);
    
    // Abrir el PDF en una nueva pestaña
    const string = doc.output('datauristring');
    const iframe = '<iframe width="100%" height="100%" src="' + string + '"></iframe>';
    const x = window.open();
    x.document.open();
    x.document.write(iframe);
    x.document.close();
  }
  
  
  
 

  obtenerImgMenu() {
    this.imagenService.getImagenSubMenu('/gestion/realizarventa').subscribe(data => {
      this.imgSubmenu = data.ImagenSubmenu[0];
    });
  }

  listar(TipoLista: number): void {
    this.loading = true;
    this.stockService.listar(TipoLista).subscribe(
      response => {
        this.itemGrilla = new Productos();
        this.listaGrilla = response.Productos || [];
        this.loading = false;
      },
      error => {
        this.alertasService.ErrorAlert('Error', error.error.message);
        this.loading = false;
      }
    );
  }

  obtenerListas() {
    this.tipofacturaService.listar(1).subscribe(data => {
      this.lTipoFacturas = data.TipoFacturas;
    });
    this.tipoformadepagoService.listar(1).subscribe(data => {
      this.lFormaDePago = data.TipoFormaDePago;
    });
  }

  cambiarFiltro(): void {
    const filtro = this.formFiltro.get('idFiltro').value;
    this.listar(filtro);
  }

  generarVenta(): void {
    const snackbarRef = this.snackbarService.openSnackbar('Generando venta...', '', 60000);
    snackbarRef.afterDismissed().subscribe(() => {
      console.log('Snackbar cerrado');
    });
  }

  cancelarVenta(): void {
    this.snackbarService.openSnackbar('Venta cancelada', '', 3000);
  }
}
