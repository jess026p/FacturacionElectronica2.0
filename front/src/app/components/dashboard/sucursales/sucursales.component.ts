import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormControl, FormGroup, Validators } from '@angular/forms';
import { Observable } from 'rxjs';
import { map, startWith } from 'rxjs/operators';
import { SucursalService } from './services/sucursal.service';

export interface Sucursal {
  identificacion: string;
  nombre: string;
  descripcion: string;
  direccion: string;
  telefono: string;
}

@Component({
  selector: 'app-sucursales',
  templateUrl: './sucursales.component.html',
  styleUrls: ['./sucursales.component.scss']
})
export class SucursalesComponent implements OnInit {
  myControl = new FormControl<string | Sucursal>('');
  options: Sucursal[] = [];
  filteredOptions: Observable<Sucursal[]> | undefined;
  sucursales: Sucursal[] = [];
  filteredSucursales: Sucursal[] = [];

  formulario!: FormGroup;
  mostrarFormulario = false;

  constructor(private formBuilder: FormBuilder, private sucursalService: SucursalService) {}

  ngOnInit(): void {
    this.formulario = this.formBuilder.group({
      identificacion: ['', Validators.required],
      nombre: ['', Validators.required],
      descripcion: ['', Validators.required],
      direccion: ['', Validators.required],
      telefono: ['', Validators.required]
    });

    this.obtenerSucursales();

    this.filteredOptions = this.myControl.valueChanges.pipe(
      startWith(''),
      map(value => {
        const identificacion = typeof value === 'string' ? value : value?.identificacion;
        return identificacion ? this._filterCodigo(identificacion as string) : this.options.slice();
      })
    );
  }

  obtenerSucursales(): void {
    this.sucursalService.obtenerSucursales().subscribe(
      response => {
        this.sucursales = response.map((sucursal: any) => ({
          identificacion: sucursal.Identificacion,
          nombre: sucursal.NombreComercial,
          descripcion: sucursal.RazonSocial,
          direccion: sucursal.Direccion,
          telefono: sucursal.Telefono
        }));

        this.filteredSucursales = [...this.sucursales]; // Copiar todas las sucursales al filtrado inicial
      },
      error => {
        console.error(error);
      }
    );
  }

  displayFn(sucursal: Sucursal): string {
    return sucursal && sucursal.identificacion ? sucursal.identificacion : '';
  }

  private _filterCodigo(identificacion: string): Sucursal[] {
    const filterValue = identificacion.toLowerCase();
    return this.options.filter(option => option.identificacion.toLowerCase().includes(filterValue));
  }

  editarElemento(elemento: Sucursal) {
    // Lógica para editar el elemento
  }

  eliminarElemento(elemento: Sucursal) {
    this.sucursalService.eliminarSucursal(elemento.identificacion).subscribe(
      response => {
        // Eliminar la sucursal de la lista filtrada
        this.filteredSucursales = this.filteredSucursales.filter(sucursal => sucursal.identificacion !== elemento.identificacion);
      },
      error => {
        console.error(error);
      }
    );
  }

  toggleForm() {
    this.mostrarFormulario = !this.mostrarFormulario;
  }

  selectOption(option: Sucursal) {
    this.myControl.setValue(option);
  }

  submitForm() {
    if (this.formulario.valid) {
      const nuevaSucursal: Sucursal = {
        identificacion: this.formulario.value.identificacion,
        nombre: this.formulario.value.nombre,
        descripcion: this.formulario.value.descripcion,
        direccion: this.formulario.value.direccion,
        telefono: this.formulario.value.telefono
      };

      // Lógica para guardar la nueva sucursal

      // Agregar la nueva sucursal a la lista filtrada
      this.filteredSucursales.push(nuevaSucursal);

      // Restablecer el formulario y ocultar el formulario de agregar
      this.formulario.reset();
      this.toggleForm();
    }
  }

  searchSucursales(event: Event) {
    const searchTerm = (event.target as HTMLInputElement).value.toLowerCase();
    this.filteredSucursales = this.sucursales.filter(sucursal =>
      sucursal.nombre.toLowerCase().includes(searchTerm) ||
      sucursal.descripcion.toLowerCase().includes(searchTerm) ||
      sucursal.direccion.toLowerCase().includes(searchTerm) ||
      sucursal.telefono.toLowerCase().includes(searchTerm)
    );
  }
}
