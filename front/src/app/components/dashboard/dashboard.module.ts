import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { DashboardRoutingModule } from './dashboard-routing.module';
import { SharedModule } from '../shared/shared.module';
import { DashboardComponent } from './dashboard.component';
import { FacturacionComponent } from './facturacion/facturacion.component';
import { ClientesComponent } from './clientes/clientes.component';
import { ProductosComponent } from './productos/productos.component';
import { NavbarComponent } from './navbar/navbar.component';
import { EmpresaComponent } from './empresa/empresa.component';
import { VentasComponent } from './ventas/ventas.component';
import { TrabajadorComponent } from './trabajador/trabajador.component';
import { AdministracionComponent } from './administracion/administracion.component';
@NgModule({
  declarations: [
    DashboardComponent,
    FacturacionComponent,
    
    ClientesComponent,
    ProductosComponent,
    NavbarComponent,
    EmpresaComponent,
    VentasComponent,
    TrabajadorComponent,
    AdministracionComponent
   
  ],
  imports: [
    CommonModule,
    DashboardRoutingModule,
    SharedModule,
    
   
  ]
})
export class DashboardModule { }
