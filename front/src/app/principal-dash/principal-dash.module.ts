import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { PrincipalDashRoutingModule } from './principal-dash-routing.module';
import { ProductosComponent } from './productos/productos.component';
import { FacturacionComponent } from './facturacion/facturacion.component';
import { ClientesComponent } from './clientes/clientes.component';


@NgModule({
  declarations: [
    ProductosComponent,
    FacturacionComponent
  ],
  imports: [
    CommonModule,
    PrincipalDashRoutingModule
  ]
})
export class PrincipalDashModule { }
