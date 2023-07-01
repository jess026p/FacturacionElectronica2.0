import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { MatSnackBar } from '@angular/material/snack-bar';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.scss']
})
export class LoginComponent implements OnInit {
form:FormGroup ;

  constructor(private fb:FormBuilder,private _snackBar: MatSnackBar){
    this.form = this.fb.group({
      usuario:['', Validators.required],
      contrasena:['', Validators.required]
    })
  }
  ngOnInit(): void {
      
  }
  ingresar(){
    const usuario = this.form.value.usuario;
    const contrasena = this.form.value.contrasena;


    if(usuario=='teamCalidad'&& contrasena=='123'){
  //redireccion a la pagina principal
    }else{
      //mostramos un mensaje de error
       this.error();
    }

    
  }
  error(){
    this._snackBar.open('usuario o contrasena incorrecta','',{
      duration: 5000,
      horizontalPosition:'center',
      verticalPosition:'bottom'
    });
 

 
  }
}
