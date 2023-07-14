import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormControl, FormGroup, Validators } from '@angular/forms';
import { Observable, map, startWith } from 'rxjs';

export interface Ventas {
  cantidad: string;
  descripcion: string;
  precioU: string;
  tarifa: string;
  descuento: string;
  valorT: string;
}

export interface Persona {
  identificacion: string;
  tipoIdentificacion: string;
  nombre: string;
  apellido: string;
  direccion: string;
  telefono: string;
  celular: string;
  correoElectronico: string;
}

@Component({
  selector: 'app-ventas',
  templateUrl: './ventas.component.html',
  styleUrls: ['./ventas.component.scss']
})
export class VentasComponent implements OnInit {
  myControl = new FormControl<string | Persona>('');
  options: Persona[] = [
    { identificacion: 'hola', tipoIdentificacion: '', nombre: '', apellido: '', direccion: '', telefono: '', celular: '', correoElectronico: '' },
    { identificacion: 'weno', tipoIdentificacion: '', nombre: '', apellido: '', direccion: '', telefono: '', celular: '', correoElectronico: '' }
  ];
  filteredOptions: Observable<Persona[]> | undefined;

  formulario!: FormGroup;
  mostrarFormulario = false;
  data: Ventas[] = [
    { cantidad: '123456789', descripcion: 'John', precioU: 'Doe', tarifa: 'Calle Principal 123', descuento: '555-1234', valorT: '555-5678' },
    // Añade más objetos de ejemplo para completar la tabla
  ];
  columnas: string[] = ['cantidad', 'descripcion', 'precioU', 'tarifa', 'descuento', 'valorT', 'acciones'];

  constructor(private formBuilder: FormBuilder) {}

  ngOnInit(): void {
    this.formulario = this.formBuilder.group({
      identificacion: ['', Validators.required],
      tipoIdentificacion: ['', Validators.required],
      nombre: ['', Validators.required],
      apellido: ['', Validators.required],
      direccion: ['', Validators.required],
      telefono: ['', Validators.required],
      celular: ['', Validators.required],
      correoElectronico: ['', [Validators.required, Validators.email]],
    });

    this.filteredOptions = this.myControl.valueChanges.pipe(
      startWith(''),
      map(value => {
        const identificacion = typeof value === 'string' ? value : value?.identificacion;
        return identificacion ? this._filter(identificacion as string) : this.options.slice();
      }),
    );
  }

  displayFn(persona: Persona): string {
    return persona && persona.identificacion ? persona.identificacion : '';
  }

  private _filter(identificacion: string): Persona[] {
    const filterValue = identificacion.toLowerCase();

    return this.options.filter(option => option.identificacion.toLowerCase().includes(filterValue));
  }

  toggleForm() {
    this.mostrarFormulario = !this.mostrarFormulario;
  }

  selectOption(option: Persona) {
    this.myControl.setValue(option);
  }

  submitForm() {
    if (this.formulario.valid) {
      const nuevoCliente: Persona = {
        identificacion: this.formulario.value.identificacion,
        tipoIdentificacion: this.formulario.value.tipoIdentificacion,
        nombre: this.formulario.value.nombre,
        apellido: this.formulario.value.apellido,
        direccion: this.formulario.value.direccion,
        telefono: this.formulario.value.telefono,
        celular: this.formulario.value.celular,
        correoElectronico: this.formulario.value.correoElectronico,
      };
      // Aquí puedes hacer lo que necesites con el nuevo cliente, como agregarlo a una lista
      console.log(nuevoCliente);
      this.formulario.reset();
      this.mostrarFormulario = false;
    }
  }

  editarElemento(elemento: Ventas) {
    // Lógica para editar el elemento
  }

  eliminarElemento(elemento: Ventas) {
    // Lógica para eliminar el elemento
  }
}
