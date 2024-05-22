import { Component, OnInit, Input } from '@angular/core';
import { TipoCategoriaService } from '../../../services/parametria/tipocategoria.service';
import { TipoCategoria } from '../../../models/parametria/tipoCategoria'
import { NgbModal, NgbModalRef } from '@ng-bootstrap/ng-bootstrap';
import { FormBuilder, FormGroup, Validators, FormControl, FormArray } from '@angular/forms';
import { Menu } from '../../../models/menu/menu';
import { ImagenService } from '../../../services/imagen/imagen.service';
import { AlertasService } from '../../../services/alertas/alertas.service';

@Component({
  selector: 'app-tipocategoria',
  templateUrl: './tipocategoria.component.html',
  styleUrls: ['./tipocategoria.component.css']
})
export class TipocategoriaComponent implements OnInit {
  @Input() menu: Menu;
  tituloModal: string;
  tituloBoton: string;
  itemGrilla: TipoCategoria; // cada item de la tabla
  listaGrilla: TipoCategoria[]; // tabla completa en donde se cargan los datos
  modalRef: NgbModalRef;
  formItemGrilla: FormGroup;
  formFiltro: FormGroup;
  Token: string;
  imgSubmenu: Menu;

  constructor(private tipoCategoriaService: TipoCategoriaService,
    private modalService: NgbModal,
    private formBuilder: FormBuilder,
    private imagenService: ImagenService,
    private alertasService: AlertasService
  ) {}
  
  ngOnInit(): void {
    this.obtenerImgMenu()
    this.Token = localStorage.getItem('Token');
    this.formItemGrilla = this.formBuilder.group({
      descripcion: new FormControl('', [Validators.required])
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
    this.imagenService.getImagenSubMenu('/parametria/tipocategoria').subscribe(data => {
      this.imgSubmenu = data.ImagenSubmenu[0];
      console.log(data);
      console.log(data.ImagenSubmenu[0]);
    });
  }

  listar(TipoLista: number): void { // 1 habilitados, 2 inhabilitados y 3 todos
    this.tipoCategoriaService.listar(TipoLista).subscribe(
      response => {
        console.log('API response:', response);
        this.itemGrilla = new TipoCategoria();
        this.listaGrilla = response.TipoCategoria || [];
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
    this.itemGrilla = Object.assign({}, new TipoCategoria());
    this.modalRef = this.modalService.open(content, { size: 'sm', centered: true });
  }

  openEditar(content, item: TipoCategoria) {
    this.tituloModal = "Editar";
    this.tituloBoton = "Guardar";
    this.itemGrilla = Object.assign({}, item); // duplica el item para que no cambie por detras y modifiquemos este para enviar al back
    this.modalRef = this.modalService.open(content, { size: 'sm', centered: true });
  }

  openInhabilitar(contentInhabilitar, item: TipoCategoria) {
    this.tituloModal = "Inhabilitar";
    this.itemGrilla = Object.assign({}, item);
    this.modalRef = this.modalService.open(contentInhabilitar, { size: 'sm', centered: true });
  }

  openHabilitar(contentHabilitar, item: TipoCategoria) {
    this.tituloModal = "Habilitar";
    this.itemGrilla = Object.assign({}, item);
    this.modalRef = this.modalService.open(contentHabilitar, { size: 'sm', centered: true });
  }

  guardar(): void {
    if (this.itemGrilla.IdTipoCategoria == null) {
      this.tipoCategoriaService.agregar(this.itemGrilla, this.Token)
        .subscribe(response => {
          this.listar(1);
          this.alertasService.OkAlert('OK', 'Se Agregó Correctamente');
          this.modalRef.close();
        }, error => {
          this.alertasService.ErrorAlert('Error', 'Error al Agregar.');
        })
      }
    else{
      this.tipoCategoriaService.editar(this.itemGrilla, this.Token)
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
    this.tipoCategoriaService.inhabilitar(this.itemGrilla, this.Token)
      .subscribe(response => {
        this.listar(1);
        this.alertasService.OkAlert('OK', 'Se Inhabilitó Correctamente');
        this.modalRef.close();
      }, response => {
        this.alertasService.ErrorAlert('Error', 'Error al Inhabilitarr.');
      });
  }

  habilitar(): void {
    this.tipoCategoriaService.habilitar(this.itemGrilla, this.Token)
      .subscribe(response => {
        this.listar(1);
        this.alertasService.OkAlert('OK', 'Se Habilitó Correctamente');
        this.modalRef.close();
      }, error => {
        this.alertasService.ErrorAlert('Error', 'Error al Habilitar.');
      });
  }




}
