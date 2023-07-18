import { ComponentFixture, TestBed } from '@angular/core/testing';

import { AdministracionComponent } from './administracion.component';

describe('AdministracionComponent', () => {
  let component: AdministracionComponent;
  let fixture: ComponentFixture<AdministracionComponent>;

  beforeEach(() => {
    TestBed.configureTestingModule({
      declarations: [AdministracionComponent]
    });
    fixture = TestBed.createComponent(AdministracionComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
