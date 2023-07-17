import { Injectable } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class EstablecimientoService {
  private apiUrl = 'http://127.0.0.1:8000/api/empresas';

  constructor(private http: HttpClient) {}

  obtenerEstablecimientos(): Observable<any[]> {
    return this.http.get<any[]>(this.apiUrl);
  }

  buscarClientes(busqueda: string): Observable<any> {
    const params = new HttpParams().set('busqueda', busqueda);
    return this.http.get('http://127.0.0.1:8000/api/personas', { params });
  }

}
