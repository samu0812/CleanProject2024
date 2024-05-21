import { ComponentFixture, TestBed } from '@angular/core/testing';

import { TiposucursalComponent } from './tiposucursal.component';

describe('TiposucursalComponent', () => {
  let component: TiposucursalComponent;
  let fixture: ComponentFixture<TiposucursalComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [TiposucursalComponent]
    })
    .compileComponents();
    
    fixture = TestBed.createComponent(TiposucursalComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
