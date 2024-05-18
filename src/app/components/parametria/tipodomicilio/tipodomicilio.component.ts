import { Component } from '@angular/core';
import { NgbModal, NgbModalRef } from '@ng-bootstrap/ng-bootstrap';
import { FormBuilder, FormGroup, Validators, FormControl } from '@angular/forms';
import { TipodomicilioService } from '../../../services/parametria/tipodomicilio.service';
import { TipoDomicilios } from '../../../models/parametria/tipodomicilio';

@Component({
  selector: 'app-tipodomicilio',
  templateUrl: './tipodomicilio.component.html',
  styleUrl: './tipodomicilio.component.css'
})
export class TipodomicilioComponent {

  itemGrilla: TipoDomicilios; // cada item de la tabla
  listaGrilla: TipoDomicilios[] = []; // tabla completa en donde se cargan los datos
  modalRef: NgbModalRef;
  formItemGrilla: FormGroup;
  formFiltro: FormGroup;
  Token: string;

  constructor(
    private tipodomicilioService: TipodomicilioService,
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
    this.tipodomicilioService.listar(TipoLista)
      .subscribe(response => {
        console.log(response)
        this.listaGrilla = response.TipoDomicilios || [];
      }, error => {
        console.error('Error al cargar tipos de categoría:', error);
      });
  }
}
