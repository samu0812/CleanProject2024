import { Component, OnInit, Input } from '@angular/core';
import { TipoRol } from '../../../models/seguridad/TipoRol';
import { NgbModal, NgbModalRef } from '@ng-bootstrap/ng-bootstrap';
import { TiporolService } from '../../../services/seguridad/tiporol.service';
import { Menu } from '../../../models/menu/menu';
import { FormBuilder, FormGroup, Validators, FormControl, FormArray } from '@angular/forms';
import { ImagenService } from '../../../services/imagen/imagen.service';

@Component({
  selector: 'app-tiporoles',
  templateUrl: './tiporoles.component.html',
  styleUrl: './tiporoles.component.css'
})
export class TiporolesComponent {
  @Input() menu: Menu;
  tituloModal: string;
  tituloBoton: string;
  itemGrilla: TipoRol; // cada item de la tabla
  listaGrilla: TipoRol[]; // tabla completa en donde se cargan los datos
  modalRef: NgbModalRef;
  formItemGrilla: FormGroup;
  formFiltro: FormGroup;
  Token: string;
  imgSubmenu: Menu;

  constructor(private TiporolService: TiporolService,
    private modalService: NgbModal,
    private formBuilder: FormBuilder,
    private imagenService: ImagenService
  ){

  }
  ngOnInit(): void {
    this.obtenerImgMenu();
    this.Token = localStorage.getItem('Token');
    this.formItemGrilla = this.formBuilder.group({
      Descripcion: new FormControl('', [Validators.required])
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
    this.imagenService.getImagenSubMenu('/seguridad/tiporoles').subscribe(data => {
      this.imgSubmenu = data.ImagenSubmenu[0];

    });
  }

  listar(TipoLista: number): void { // 1 habilitados, 2 inhabilitados y 3 todos
    this.TiporolService.listar(TipoLista).subscribe(
      response => {
        this.itemGrilla = new TipoRol();
        this.listaGrilla = response.TiposRol || [];
      },
      error => {
        console.error('Error al cargar tipos de roles:', error);
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
    this.itemGrilla = Object.assign({}, new TipoRol());
    this.modalRef = this.modalService.open(content, { size: 'sm', centered: true });
  }

  openEditar(content, item: TipoRol) {
    this.tituloModal = "Editar";
    this.tituloBoton = "Guardar";
    this.itemGrilla = Object.assign({}, item); // duplica el item para que no cambie por detras y modifiquemos este para enviar al back
    this.modalRef = this.modalService.open(content, { size: 'sm', centered: true });
  }

  openInhabilitar(contentInhabilitar, item: TipoRol) {
    this.tituloModal = "Inhabilitar";
    this.itemGrilla = Object.assign({}, item);
    this.modalRef = this.modalService.open(contentInhabilitar, { size: 'sm', centered: true });
  }

  openHabilitar(contentHabilitar, item: TipoRol) {
    this.tituloModal = "Habilitar";
    this.itemGrilla = Object.assign({}, item);
    this.modalRef = this.modalService.open(contentHabilitar, { size: 'sm', centered: true });
  }

  guardar(): void {
    if (this.itemGrilla.IdTipoRol== null) {
      this.TiporolService.agregar(this.itemGrilla, this.Token)
        .subscribe(response => {
          this.listar(1);
          this.modalRef.close();
        }, error => {
          console.error('Error al agregar tipo de categoría:', error);
        })
      }
    else{
      this.TiporolService.editar(this.itemGrilla, this.Token)
      .subscribe(response => {
        this.listar(1);
        this.modalRef.close();
      }, error => {
        console.error('Error al modificar tipo de categoría:', error);
      })
    };
  }

  inhabilitar(): void {
    this.TiporolService.inhabilitar(this.itemGrilla, this.Token)
      .subscribe(response => {
        this.listar(1);
        this.modalRef.close();
      }, error => {
        console.error('Error al inhabilitar tipo de categoría:', error);
      });
  }

  habilitar(): void {
    this.TiporolService.habilitar(this.itemGrilla, this.Token)
      .subscribe(response => {
        this.listar(1);
        this.modalRef.close();
      }, error => {
        console.error('Error al habilitar tipo de categoría:', error);
      });
  }
}
