import { TipoimpuestoService } from './../../../services/parametria/tipoimpuesto.service';
import { Component, OnInit, Input } from '@angular/core';
import { TipoImpuesto } from '../../../models/parametria/tipoimpuesto';
import { NgbModal, NgbModalRef } from '@ng-bootstrap/ng-bootstrap';
import { FormBuilder, FormGroup, Validators, FormControl, FormArray } from '@angular/forms';
import { Menu } from '../../../models/menu/menu';
import { ImagenService } from '../../../services/imagen/imagen.service';
import { AlertasService } from '../../../services/alertas/alertas.service';

@Component({
  selector: 'app-tipoimpuesto',
  templateUrl: './tipoimpuesto.component.html',
  styleUrl: './tipoimpuesto.component.css'
})
export class TipoimpuestoComponent {
  @Input() menu: Menu;
  tituloModal: string;
  tituloBoton: string;
  itemGrilla: TipoImpuesto; // cada item de la tabla
  listaGrilla: TipoImpuesto[]; // tabla completa en donde se cargan los datos
  modalRef: NgbModalRef;
  formItemGrilla: FormGroup;
  formFiltro: FormGroup;
  Token: string;
  imgSubmenu: Menu;

  constructor(private tipoImpuestoService: TipoimpuestoService,
    private modalService: NgbModal,
    private formBuilder: FormBuilder,
    private imagenService: ImagenService,
    private alertasService: AlertasService
  ) {}
  
  ngOnInit(): void {
    this.obtenerImgMenu()
    this.Token = localStorage.getItem('Token');
    this.formItemGrilla = this.formBuilder.group({
      detalle: new FormControl('', [Validators.required]),
      porcentaje: new FormControl('', [Validators.required, Validators.min(0)]) // Agregado
    });
    

    this.formFiltro = this.formBuilder.group({
      idFiltro: new FormControl('1', [Validators.required]) // Default value set to 1
    });

    this.listar(1); // Initially list only enabled items

    // Listen for changes in the filter and update the list accordingly
    this.formFiltro.get('idFiltro').valueChanges.subscribe(value => {
      this.listar(value);
    });
  }
  obtenerImgMenu(){
    this.imagenService.getImagenSubMenu('/parametria/tipoimpuesto').subscribe(data => {
      this.imgSubmenu = data.ImagenSubmenu[0];
      console.log(data);
      console.log(data.ImagenSubmenu[0]);
    });
  }


  listar(TipoLista: number): void { // 1 habilitados, 2 inhabilitados y 3 todos
    this.tipoImpuestoService.listar(TipoLista).subscribe(
      response => {
        console.log('API response:', response);
        this.itemGrilla = new TipoImpuesto();
        this.listaGrilla = response.TipoImpuesto || [];
      },
      error => {
        console.error('Error al cargar tipos de impuesto:', error);
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
    this.itemGrilla = Object.assign({}, new TipoImpuesto());
    this.modalRef = this.modalService.open(content, { size: 'sm', centered: true });
  }

  openEditar(content, item: TipoImpuesto) {
    this.tituloModal = "Editar";
    this.tituloBoton = "Guardar";
    this.itemGrilla = Object.assign({}, item); // duplica el item para que no cambie por detras y modifiquemos este para enviar al back
    this.modalRef = this.modalService.open(content, { size: 'sm', centered: true });
  }

  openInhabilitar(contentInhabilitar, item: TipoImpuesto) {
    this.tituloModal = "Inhabilitar";
    this.itemGrilla = Object.assign({}, item);
    this.modalRef = this.modalService.open(contentInhabilitar, { size: 'sm', centered: true });
  }

  openHabilitar(contentHabilitar, item: TipoImpuesto) {
    this.tituloModal = "Habilitar";
    this.itemGrilla = Object.assign({}, item);
    this.modalRef = this.modalService.open(contentHabilitar, { size: 'sm', centered: true });
  }

  guardar(): void {
    if (this.itemGrilla.IdTipoImpuesto == null) {
      this.tipoImpuestoService.agregar(this.itemGrilla, this.Token)
        .subscribe(response => {
          this.listar(1);
          this.alertasService.OkAlert('OK', 'Se Agregó Correctamente');
          this.modalRef.close();
        }, error => {
          this.alertasService.ErrorAlert('Error', 'Error al Agregar.');
        })
      }
    else{
      this.tipoImpuestoService.editar(this.itemGrilla, this.Token)
      .subscribe(response => {
        this.listar(1);
        this.alertasService.OkAlert('OK', 'Se Modificó Correctamente');
        this.modalRef.close();
      }, error => {
        this.alertasService.ErrorAlert('Error', 'Error al Modificar.');
      })
    };
  }
  

  inhabilitar(): void {
    this.tipoImpuestoService.inhabilitar(this.itemGrilla, this.Token)
      .subscribe(response => {
        this.listar(1);
        this.alertasService.OkAlert('OK', 'Se Inhabilitó Correctamente');
        this.modalRef.close();
      }, error => {
        this.alertasService.ErrorAlert('Error', 'Error al Inhabilitarr.');
      });
  }

  habilitar(): void {
    this.tipoImpuestoService.habilitar(this.itemGrilla, this.Token)
      .subscribe(response => {
        this.listar(1);
        this.alertasService.OkAlert('OK', 'Se Habilitó Correctamente');
        this.modalRef.close();
      }, error => {
        this.alertasService.ErrorAlert('Error', 'Error al Habilitar.');
      });
  }




}
