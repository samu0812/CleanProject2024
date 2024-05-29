import { Component, OnInit, Input } from '@angular/core';
import { NgbModal, NgbModalRef } from '@ng-bootstrap/ng-bootstrap';
import { FormBuilder, FormGroup, Validators, FormControl, FormArray } from '@angular/forms';
import { Menu } from '../../../models/menu/menu';
import { ImagenService } from '../../../services/imagen/imagen.service';
import { AlertasService } from '../../../services/alertas/alertas.service';
import { Productos } from '../../../models/recursos/productos';
import { StockService } from '../../../services/recursos/stock.service';
import { TipoMedidas } from '../../../models/parametria/tipomedida';
import { TipomedidaService } from '../../../services/parametria/tipomedida.service';
import { TipoCategoria } from '../../../models/parametria/tipoCategoria';
import { TipoCategoriaService } from '../../../services/parametria/tipocategoria.service';
import { TipoProducto } from '../../../models/parametria/tipoproducto';
import { TipoproductoService } from '../../../services/parametria/tipoproducto.service';

@Component({
  selector: 'app-stock',
  templateUrl: './stock.component.html',
  styleUrl: './stock.component.css'
})
export class StockComponent {
  
  tituloModal: string;
  tituloBoton: string;
  itemGrilla: Productos; // cada item de la tabla
  listaGrilla: Productos[]; // tabla completa en donde se cargan los datos
  modalRef: NgbModalRef;
  formItemGrilla: FormGroup;
  formFiltro: FormGroup;
  Token: string;
  imgSubmenu: Menu;
  lTipoMedidas: TipoMedidas[];
  lTipoCategoria: TipoCategoria[];
  lTipoProducto: TipoProducto[];

  constructor(private stockService: StockService,
    private modalService: NgbModal,
    private formBuilder: FormBuilder,
    private imagenService: ImagenService,
    private alertasService: AlertasService,
    private tipomedidaService: TipomedidaService,
    private tipoCategoriaService: TipoCategoriaService,
    private tipoproductoService: TipoproductoService
  ) {}
  
  ngOnInit(): void {
    this.obtenerImgMenu()
    this.Token = localStorage.getItem('Token');
    this.formItemGrilla = this.formBuilder.group({
       Codigo: new FormControl('', [Validators.required]),
       Nombre: new FormControl('', [Validators.required]),
       Marca: new FormControl('', [Validators.required]),
       PrecioCosto: new FormControl('', [Validators.required]),
       Tamano: new FormControl('', [Validators.required]),
       CantMaxima: new FormControl('', [Validators.required]),
       CantMinima: new FormControl('', [Validators.required]),
       tipoMedida: new FormControl('', [Validators.required]),
       tipoCategoria:new FormControl('', [Validators.required]),
       tipoProducto: new FormControl('', [Validators.required])
    });

    this.formFiltro = this.formBuilder.group({
      idFiltro: new FormControl('1', [Validators.required]) // Default value set to 1
    });

    this.listar(1); // Initially list only enabled items

    // Listen for changes in the filter and update the list accordingly
    this.formFiltro.get('idFiltro').valueChanges.subscribe(value => {
      this.listar(value);
    });

    this.obtenerListas();
  }
  obtenerListas(){
    this.tipoCategoriaService.listar(1).subscribe(data => {
      this.lTipoCategoria = data.TipoCategoria;
    });
    this.tipomedidaService.listar(1).subscribe(data => {
      this.lTipoMedidas = data.TipoMedidas;
    });
    this.tipoproductoService.listar(1).subscribe(data => {
      this.lTipoProducto = data.TipoProducto;
    });
  }
  
  obtenerImgMenu(){
    this.imagenService.getImagenSubMenu('/recursos/inventario').subscribe(data => {
      this.imgSubmenu = data.ImagenSubmenu[0];
    });
  }

  listar(TipoLista: number): void { // 1 habilitados, 2 inhabilitados y 3 todos
    this.stockService.listar(TipoLista).subscribe(
      response => {
        this.itemGrilla = new Productos();
        this.listaGrilla = response.Productos || [];
        console.log(response.Productos);
        console.log(response);
      },
      error => {
        this.alertasService.ErrorAlert('Error', error.error.message);
      }
    );
  }

  cambiarFiltro(): void {
    const filtro = this.formFiltro.get('idFiltro').value;
    this.listar(filtro);
  }

  openAgregar(content) {
    this.tituloModal = "Agregar";
    this.tituloBoton = "Agregar";
    this.itemGrilla = Object.assign({}, new Productos());
    this.modalRef = this.modalService.open(content, { size: 'lg', centered: true });
  }

  openEditar(content, item: Productos) {
    this.tituloModal = "Editar";
    this.tituloBoton = "Guardar";
    this.itemGrilla = Object.assign({}, item); // duplica el item para que no cambie por detras y modifiquemos este para enviar al back
    this.modalRef = this.modalService.open(content, { size: 'md', centered: true });
  }

  openInhabilitar(contentInhabilitar, item: Productos) {
    this.tituloModal = "Inhabilitar";
    this.itemGrilla = Object.assign({}, item);
    this.modalRef = this.modalService.open(contentInhabilitar, { size: 'md', centered: true });
  }

  openHabilitar(contentHabilitar, item: Productos) {
    this.tituloModal = "Habilitar";
    this.itemGrilla = Object.assign({}, item);
    this.modalRef = this.modalService.open(contentHabilitar, { size: 'md', centered: true });
  }

  guardar(): void {
    if (this.itemGrilla.IdProducto == null) {
      this.stockService.agregar(this.itemGrilla, this.Token)
        .subscribe(response => {
          console.log(response);
          this.listar(1);
          this.alertasService.OkAlert('OK', 'Se Agregó Correctamente');
          this.modalRef.close();
        }, error => {
          this.alertasService.ErrorAlert('Error', error.error.Message);
        })
      }
    else{
      this.stockService.editar(this.itemGrilla, this.Token)
      .subscribe(response => {
        this.listar(1);
        this.alertasService.OkAlert('OK', 'Se Modificó Correctamente');
        this.modalRef.close();
      }, error => {
        this.alertasService.ErrorAlert('Error', error.error.Message);
      })
    };
  }
  

  inhabilitar(): void {
    this.stockService.inhabilitar(this.itemGrilla, this.Token)
      .subscribe(response => {
        this.listar(0);
        this.alertasService.OkAlert('OK', 'Se Inhabilitó Correctamente');
        this.modalRef.close();
      }, response => {
        this.alertasService.ErrorAlert('Error', response.error.Message);
      });
  }

  habilitar(): void {
    this.stockService.habilitar(this.itemGrilla, this.Token)
      .subscribe(response => {
        this.listar(1);
        this.alertasService.OkAlert('OK', 'Se Habilitó Correctamente');
        this.modalRef.close();
      }, error => {
        this.alertasService.ErrorAlert('Error', error.error.Message);
      });
  }




}

