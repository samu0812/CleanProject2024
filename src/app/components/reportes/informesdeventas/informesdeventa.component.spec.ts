import { ComponentFixture, TestBed } from '@angular/core/testing';

import { InformesdeventaComponent } from './informesdeventa.component';

describe('InformesdeventaComponent', () => {
  let component: InformesdeventaComponent;
  let fixture: ComponentFixture<InformesdeventaComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [InformesdeventaComponent]
    })
    .compileComponents();
    
    fixture = TestBed.createComponent(InformesdeventaComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
