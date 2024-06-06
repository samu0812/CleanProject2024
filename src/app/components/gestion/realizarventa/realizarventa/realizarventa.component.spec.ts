import { ComponentFixture, TestBed } from '@angular/core/testing';

import { RealizarventaComponent } from './realizarventa.component';

describe('RealizarventaComponent', () => {
  let component: RealizarventaComponent;
  let fixture: ComponentFixture<RealizarventaComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [RealizarventaComponent]
    })
    .compileComponents();
    
    fixture = TestBed.createComponent(RealizarventaComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
