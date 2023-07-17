import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';

export interface Trabajador {
  id: number;
  nombre: string;
  apellido: string;
  usuario: string;
  contrasena: string;
  correoElectronico: string;
}

@Injectable({
  providedIn: 'root'
})
export class TrabajadorService {
  private apiUrl = 'http://127.0.0.1:8000/api/vendedores';

  constructor(private http: HttpClient) {}

  obtenerTrabajadores(): Observable<Trabajador[]> {
    return this.http.get<Trabajador[]>(this.apiUrl);
  }
}
