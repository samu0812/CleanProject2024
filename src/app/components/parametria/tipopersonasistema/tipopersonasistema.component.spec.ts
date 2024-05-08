import { ComponentFixture, TestBed } from '@angular/core/testing';

import { TipopersonasistemaComponent } from './tipopersonasistema.component';

describe('TipopersonasistemaComponent', () => {
  let component: TipopersonasistemaComponent;
  let fixture: ComponentFixture<TipopersonasistemaComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [TipopersonasistemaComponent]
    })
    .compileComponents();
    
    fixture = TestBed.createComponent(TipopersonasistemaComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
