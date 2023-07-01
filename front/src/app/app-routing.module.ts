import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { LoginComponent } from './components/login/login.component';
import { PrincipalDashComponent } from './principal-dash/principal-dash.component';
import { NavegacionComponent } from './navegacion/navegacion.component';

const routes: Routes = [
 {path:'',component:LoginComponent},
{path:'principal',component: NavegacionComponent},


];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
