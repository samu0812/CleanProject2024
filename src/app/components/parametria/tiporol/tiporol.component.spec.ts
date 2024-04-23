import { ComponentFixture, TestBed } from '@angular/core/testing';

import { TiporolComponent } from './tiporol.component';

describe('TiporolComponent', () => {
  let component: TiporolComponent;
  let fixture: ComponentFixture<TiporolComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [TiporolComponent]
    })
    .compileComponents();
    
    fixture = TestBed.createComponent(TiporolComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
