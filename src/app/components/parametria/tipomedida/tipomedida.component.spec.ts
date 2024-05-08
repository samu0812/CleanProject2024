import { ComponentFixture, TestBed } from '@angular/core/testing';

import { TipomedidaComponent } from './tipomedida.component';

describe('TipomedidaComponent', () => {
  let component: TipomedidaComponent;
  let fixture: ComponentFixture<TipomedidaComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [TipomedidaComponent]
    })
    .compileComponents();
    
    fixture = TestBed.createComponent(TipomedidaComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
