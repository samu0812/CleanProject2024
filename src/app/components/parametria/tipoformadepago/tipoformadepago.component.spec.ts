import { ComponentFixture, TestBed } from '@angular/core/testing';

import { TipoformadepagoComponent } from './tipoformadepago.component';

describe('TipoformadepagoComponent', () => {
  let component: TipoformadepagoComponent;
  let fixture: ComponentFixture<TipoformadepagoComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [TipoformadepagoComponent]
    })
    .compileComponents();
    
    fixture = TestBed.createComponent(TipoformadepagoComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
