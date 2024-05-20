import { Component, OnInit } from '@angular/core';
import { TipoMedidas } from '../../../models/parametria/tipomedida';
import { TipomedidaService } from '../../../services/parametria/tipomedida.service';
import { NgbModal, NgbModalRef } from '@ng-bootstrap/ng-bootstrap';
import { FormBuilder, FormGroup, Validators, FormControl } from '@angular/forms';

@Component({
  selector: 'app-tipomedida',
  templateUrl: './tipomedida.component.html',
  styleUrl: './tipomedida.component.css'
})
export class TipomedidaComponent {


  itemGrilla: TipoMedidas; // cada item de la tabla
  listaGrilla: TipoMedidas[] = []; // tabla completa en donde se cargan los datos
  modalRef: NgbModalRef;
  formItemGrilla: FormGroup;
  formFiltro: FormGroup;
  Token: string;

  constructor(
    private tipomedidaService: TipomedidaService,
    private modalService: NgbModal,
    private formBuilder: FormBuilder
  ) {}

  ngOnInit(): void {
    this.Token = localStorage.getItem('Token');
    this.listar(1);
    this.formItemGrilla = this.formBuilder.group({
      descripcion: new FormControl('', [Validators.required])
    });

    this.formFiltro = this.formBuilder.group({
      idFiltro: new FormControl('', [Validators.required])
    });
  }

  listar(TipoLista: number): void { // 1 habilitados, 2 inhabilitados y 3 todos
    console.log(TipoLista, "sa");
    this.tipomedidaService.listar(TipoLista)
      .subscribe(response => {
        this.listaGrilla = response.TipoDestinatarioFacturas || [];
        console.log(this.listaGrilla, "sasass");
      }, error => {
        console.error('Error al cargar tipos de categoría:', error);
      });
  }
}
