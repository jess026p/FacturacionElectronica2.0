import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { ClientesComponent } from './clientes/clientes.component';
import { ProductosComponent } from './productos/productos.component';
import { PrincipalDashComponent } from './principal-dash.component';
import { FacturacionComponent } from './facturacion/facturacion.component';

const routes: Routes = [
  {
    path: 'principal-dash',component: PrincipalDashComponent,
    children: [
      
      { path: 'productos', component: ProductosComponent },
      { path: 'clientes', component: ClientesComponent },
      { path: 'facturacion', component: FacturacionComponent }
    ]
  }
];


@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class PrincipalDashRoutingModule { }
