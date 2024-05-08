import { ComponentFixture, TestBed } from '@angular/core/testing';

import { RealizarpedidosComponent } from './realizarpedidos.component';

describe('RealizarpedidosComponent', () => {
  let component: RealizarpedidosComponent;
  let fixture: ComponentFixture<RealizarpedidosComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [RealizarpedidosComponent]
    })
    .compileComponents();
    
    fixture = TestBed.createComponent(RealizarpedidosComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
