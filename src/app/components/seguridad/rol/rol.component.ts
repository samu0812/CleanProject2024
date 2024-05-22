import { Component, OnInit, Input } from '@angular/core';
import { ModulosporrolService } from '../../../services/seguridad/modulosporrol.service';
import { ModulosPorRol } from '../../../models/seguridad/modulosporrol'
import { NgbModal, NgbModalRef } from '@ng-bootstrap/ng-bootstrap';
import { FormBuilder, FormGroup, Validators, FormControl, FormArray } from '@angular/forms';
import { Menu } from '../../../models/menu/menu';
import { ImagenService } from '../../../services/imagen/imagen.service';
import { AlertasService } from '../../../services/alertas/alertas.service';
import { TiporolService } from '../../../services/seguridad/tiporol.service';
import { TipoRol } from '../../../models/seguridad/TipoRol';

@Component({
  selector: 'app-rol',
  templateUrl: './rol.component.html',
  styleUrl: './rol.component.css'
})
export class RolComponent {
  @Input() menu: Menu;
  tituloModal: string;
  tituloBoton: string;
  itemGrilla: ModulosPorRol; // cada item de la tabla
  listaGrilla: ModulosPorRol[]; // tabla completa en donde se cargan los datos
  modalRef: NgbModalRef;
  formItemGrilla: FormGroup;
  formFiltro: FormGroup;
  Token: string;
  imgSubmenu: Menu;
  lTipoRol: TipoRol[];

  constructor(private modulosPorRolService: ModulosporrolService,
    private tipoRolService: TiporolService,
    private modalService: NgbModal,
    private formBuilder: FormBuilder,
    private imagenService: ImagenService,
    private alertasService: AlertasService
  ) {}

  ngOnInit(): void {
    this.obtenerImgMenu();
    this.obtenerListas();
    this.Token = localStorage.getItem('Token');
    this.formItemGrilla = this.formBuilder.group({
      tiporol: new FormControl('', [Validators.required]),
      tipomodulo: new FormControl('', [Validators.required]),
      tipopermiso: new FormControl('', [Validators.required])
    });

    this.formFiltro = this.formBuilder.group({
      idFiltroMostrar: new FormControl('1', [Validators.required]),
      idFiltroRoles: new FormControl(null)
    });

    this.listar(1);
    this.formFiltro.get('idFiltro').valueChanges.subscribe(value => {
      this.listar(value);
    });

  }
  obtenerImgMenu(){
    this.imagenService.getImagenSubMenu('/seguridad/rolmodulo').subscribe(data => {
      this.imgSubmenu = data.ImagenSubmenu[0];
    });
  }

  obtenerListas(){
    this.tipoRolService.listar(1).subscribe(data => {
      this.lTipoRol = data;
      });
    }

  listar(TipoLista: number): void { // 1 habilitados, 2 inhabilitados y 3 todos
    this.modulosPorRolService.listar(TipoLista, this.idFiltroRoles).subscribe(
      response => {
        console.log(response, "ceci")
        this.itemGrilla = new ModulosPorRol();
        this.listaGrilla = response.ModulosPorRol || [];
      },
      error => {
        this.alertasService.ErrorAlert('Error', 'Error al Cargar la lista.');
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
    this.itemGrilla = Object.assign({}, new ModulosPorRol());
    this.modalRef = this.modalService.open(content, { size: 'sm', centered: true });
  }

  openInhabilitar(contentInhabilitar, item: ModulosPorRol) {
    this.tituloModal = "Inhabilitar";
    this.itemGrilla = Object.assign({}, item);
    this.modalRef = this.modalService.open(contentInhabilitar, { size: 'sm', centered: true });
  }

  openHabilitar(contentHabilitar, item: ModulosPorRol) {
    this.tituloModal = "Habilitar";
    this.itemGrilla = Object.assign({}, item);
    this.modalRef = this.modalService.open(contentHabilitar, { size: 'sm', centered: true });
  }

  guardar(): void {
    this.modulosPorRolService.agregar(this.itemGrilla, this.Token)
      .subscribe(response => {
        this.listar(1);
        this.alertasService.OkAlert('OK', 'Se Agregó Correctamente');
        this.modalRef.close();
      }, error => {
        this.alertasService.ErrorAlert('Error', 'Error al agregar.');
      })
    }

  inhabilitar(): void {
    this.modulosPorRolService.inhabilitar(this.itemGrilla, this.Token)
      .subscribe(response => {
        this.listar(1);
        this.alertasService.OkAlert('OK', 'Se Inhabilitó Correctamente');
        this.modalRef.close();
      }, response => {
        this.alertasService.ErrorAlert('Error', 'Error al Inhabilitarr.');
      });
  }

  habilitar(): void {
    this.modulosPorRolService.habilitar(this.itemGrilla, this.Token)
      .subscribe(response => {
        this.listar(1);
        this.alertasService.OkAlert('OK', 'Se Habilitó Correctamente');
        this.modalRef.close();
      }, error => {
        this.alertasService.ErrorAlert('Error', 'Error al Habilitar.');
      });
  }
}
