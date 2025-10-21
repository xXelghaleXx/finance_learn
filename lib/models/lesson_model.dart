class Leccion {
  final int id;
  final String titulo;
  final int nivel;
  final int puntos;
  final String duracion;
  final String descripcion;
  final String contenido;
  final List<QuizQuestion> quiz;

  Leccion({
    required this.id,
    required this.titulo,
    required this.nivel,
    required this.puntos,
    required this.duracion,
    required this.descripcion,
    required this.contenido,
    required this.quiz,
  });
}

class QuizQuestion {
  final String pregunta;
  final List<String> opciones;
  final int respuestaCorrecta; // índice de la respuesta correcta
  final String explicacion;

  QuizQuestion({
    required this.pregunta,
    required this.opciones,
    required this.respuestaCorrecta,
    required this.explicacion,
  });
}

// Contenido de las lecciones
class LeccionesData {
  static final List<Leccion> lecciones = [
    Leccion(
      id: 1,
      titulo: 'Introducción a las Finanzas',
      nivel: 1,
      puntos: 50,
      duracion: '5 min',
      descripcion: 'Aprende los conceptos básicos de finanzas personales y por qué son importantes para tu futuro.',
      contenido: '''
# Introducción a las Finanzas Personales

## ¿Qué son las finanzas personales?

Las finanzas personales se refieren a la gestión de tu dinero, incluyendo ingresos, gastos, ahorros e inversiones. Es fundamental para alcanzar tus metas y tener estabilidad económica.

## Conceptos Clave:

### 1. Ingresos
- Dinero que recibes (salario, negocios, inversiones)
- Pueden ser activos (requieren trabajo) o pasivos (no requieren trabajo constante)

### 2. Gastos
- Todo el dinero que sale de tu bolsillo
- Se dividen en **fijos** (renta, servicios) y **variables** (entretenimiento, comida)

### 3. Ahorro
- Dinero que guardas para el futuro
- Debe ser al menos 10-20% de tus ingresos

### 4. Inversión
- Usar tu dinero para generar más dinero
- Acciones, bonos, bienes raíces, etc.

## La Regla de Oro:

**Gasta menos de lo que ganas y ahorra la diferencia**

## ¿Por qué es importante?

✓ Te da control sobre tu vida
✓ Reduce el estrés financiero
✓ Te permite alcanzar tus sueños
✓ Preparas tu futuro y retiro
✓ Evitas deudas innecesarias

## Primer Paso:

Conoce exactamente cuánto dinero entra y sale cada mes. Esta aplicación te ayudará a hacer eso.

**Recuerda:** No necesitas ser rico para empezar a gestionar tus finanzas. ¡Empieza hoy mismo!
''',
      quiz: [
        QuizQuestion(
          pregunta: '¿Qué porcentaje de tus ingresos deberías ahorrar como mínimo?',
          opciones: ['5%', '10-20%', '50%', '75%'],
          respuestaCorrecta: 1,
          explicacion: 'Se recomienda ahorrar entre 10-20% de tus ingresos mensuales para construir un fondo de emergencia y cumplir tus metas.',
        ),
        QuizQuestion(
          pregunta: '¿Cuál es la regla de oro de las finanzas personales?',
          opciones: [
            'Gastar todo lo que ganas',
            'Pedir préstamos para invertir',
            'Gastar menos de lo que ganas',
            'Solo ahorrar sin gastar'
          ],
          respuestaCorrecta: 2,
          explicacion: 'La regla fundamental es gastar menos de lo que ganas y ahorrar la diferencia. Esto te permite construir riqueza con el tiempo.',
        ),
        QuizQuestion(
          pregunta: '¿Qué son los gastos fijos?',
          opciones: [
            'Gastos que cambian cada mes',
            'Gastos que son siempre iguales como la renta',
            'Solo los gastos de comida',
            'Gastos innecesarios'
          ],
          respuestaCorrecta: 1,
          explicacion: 'Los gastos fijos son aquellos que se mantienen constantes cada mes, como el alquiler, servicios básicos o cuotas de préstamos.',
        ),
      ],
    ),
    Leccion(
      id: 2,
      titulo: 'Creando tu Presupuesto',
      nivel: 1,
      puntos: 75,
      duracion: '7 min',
      descripcion: 'Descubre cómo crear un presupuesto mensual efectivo usando la regla 50/30/20.',
      contenido: '''
# Creando tu Presupuesto Personal

## ¿Qué es un presupuesto?

Un presupuesto es un plan que te ayuda a decidir cómo gastar tu dinero cada mes. Es tu hoja de ruta financiera.

## La Regla 50/30/20

Esta es una forma simple y efectiva de distribuir tus ingresos:

### 50% - Necesidades
- Vivienda (renta/hipoteca)
- Servicios (luz, agua, internet)
- Alimentación básica
- Transporte
- Seguros
- Pagos mínimos de deudas

### 30% - Deseos
- Entretenimiento
- Restaurantes
- Suscripciones (Netflix, Spotify)
- Ropa
- Hobbies
- Vacaciones

### 20% - Ahorros e Inversiones
- Fondo de emergencia
- Jubilación
- Inversiones
- Pago extra de deudas

## Pasos para crear tu presupuesto:

### 1. Calcula tus ingresos netos
Suma todo el dinero que recibes mensualmente después de impuestos.

### 2. Lista tus gastos
Revisa tus estados de cuenta de los últimos 3 meses y anota todos tus gastos.

### 3. Categoriza
Divide tus gastos en necesidades y deseos.

### 4. Aplica la regla 50/30/20
Asigna cada gasto a su categoría correspondiente.

### 5. Ajusta
Si gastas más del 50% en necesidades, busca formas de reducir costos.

## Consejos Prácticos:

✓ Usa esta app para registrar todos tus gastos
✓ Revisa tu presupuesto semanalmente
✓ Sé realista, no muy estricto
✓ Deja un margen para imprevistos
✓ Ajusta mensualmente según sea necesario

## Errores Comunes:

✗ No considerar gastos anuales (seguros, regalos)
✗ Ser demasiado optimista
✗ No trackear gastos pequeños
✗ Abandonar después del primer mes

## Ejemplo Práctico:

**Ingreso mensual:** S/. 3,000

- **50% Necesidades:** S/. 1,500
  - Renta: S/. 800
  - Servicios: S/. 200
  - Comida: S/. 300
  - Transporte: S/. 200

- **30% Deseos:** S/. 900
  - Entretenimiento: S/. 300
  - Salidas: S/. 400
  - Ropa: S/. 200

- **20% Ahorro:** S/. 600
  - Emergencia: S/. 400
  - Inversión: S/. 200

**Recuerda:** Un presupuesto no es una restricción, es un plan para gastar tu dinero con intención.
''',
      quiz: [
        QuizQuestion(
          pregunta: 'Según la regla 50/30/20, ¿qué porcentaje deberías destinar a necesidades?',
          opciones: ['30%', '20%', '50%', '70%'],
          respuestaCorrecta: 2,
          explicacion: 'El 50% de tus ingresos debe destinarse a necesidades básicas como vivienda, alimentación y transporte.',
        ),
        QuizQuestion(
          pregunta: '¿Cuál de estos gastos es una NECESIDAD?',
          opciones: ['Netflix', 'Renta', 'Salir a cenar', 'Vacaciones'],
          respuestaCorrecta: 1,
          explicacion: 'La renta es una necesidad básica. Netflix, salir a cenar y vacaciones son deseos.',
        ),
        QuizQuestion(
          pregunta: '¿Con qué frecuencia deberías revisar tu presupuesto?',
          opciones: ['Una vez al año', 'Semanalmente', 'Nunca', 'Solo cuando hay problemas'],
          respuestaCorrecta: 1,
          explicacion: 'Se recomienda revisar tu presupuesto semanalmente para mantener el control y hacer ajustes oportunos.',
        ),
      ],
    ),
    Leccion(
      id: 3,
      titulo: 'El Poder del Interés Compuesto',
      nivel: 2,
      puntos: 100,
      duracion: '8 min',
      descripcion: 'Entiende cómo el interés compuesto puede multiplicar tus ahorros con el tiempo.',
      contenido: '''
# El Poder del Interés Compuesto

## ¿Qué es el interés compuesto?

El interés compuesto es "interés sobre el interés". Es cuando ganas intereses no solo sobre tu inversión inicial, sino también sobre los intereses acumulados.

## La Octava Maravilla del Mundo

Albert Einstein llamó al interés compuesto "la octava maravilla del mundo". Quien lo entiende, lo gana; quien no, lo paga.

## Cómo Funciona:

### Interés Simple vs Compuesto

**Interés Simple:**
- Solo ganas interés sobre el capital inicial
- Ejemplo: S/. 1,000 al 10% anual = S/. 100 cada año

**Interés Compuesto:**
- Ganas interés sobre el capital + intereses acumulados
- Ejemplo: S/. 1,000 al 10% anual
  - Año 1: S/. 1,100
  - Año 2: S/. 1,210 (S/. 1,100 + 10%)
  - Año 3: S/. 1,331 (S/. 1,210 + 10%)

## La Fórmula Mágica:

**A = P(1 + r/n)^(nt)**

Donde:
- A = Monto final
- P = Principal (inversión inicial)
- r = Tasa de interés anual
- n = Número de veces que se capitaliza al año
- t = Tiempo en años

## Ejemplo Real:

### Escenario 1: Empiezas a los 25 años
- Inviertes S/. 500 mensuales
- Retorno del 10% anual
- A los 65 años: **S/. 3,163,039**
- Solo invertiste: S/. 240,000

### Escenario 2: Empiezas a los 35 años
- Inviertes S/. 500 mensuales
- Retorno del 10% anual
- A los 65 años: **S/. 1,139,663**
- Solo invertiste: S/. 180,000

**¡10 años de diferencia = S/. 2,000,000 menos!**

## Los 3 Factores Clave:

### 1. Tiempo ⏰
El factor más importante. Mientras más temprano empieces, mejor.

### 2. Tasa de Retorno 📈
Busca inversiones con buenos rendimientos (pero seguras).

### 3. Consistencia 💪
Aporta regularmente, aunque sea poco.

## Regla del 72:

Para saber en cuántos años duplicarás tu dinero:

**72 ÷ Tasa de interés = Años para duplicar**

Ejemplos:
- Al 6%: 72 ÷ 6 = 12 años
- Al 10%: 72 ÷ 10 = 7.2 años
- Al 12%: 72 ÷ 12 = 6 años

## Aplicaciones Prácticas:

### Para Ahorros:
✓ Cuenta de ahorros con intereses
✓ Certificados de depósito
✓ Fondos de inversión

### Para Deudas (lado negativo):
✗ Tarjetas de crédito (interés compuesto en tu contra)
✗ Préstamos con intereses altos

## Consejos de Acción:

1. **Empieza HOY**, no mañana
2. Automatiza tus ahorros/inversiones
3. Reinvierte las ganancias
4. No retires el dinero antes de tiempo
5. Aumenta tus aportes con el tiempo

## El Costo de Esperar:

Cada año que esperas para empezar a invertir puede costarte **miles de soles** en el futuro.

**No necesitas mucho dinero para empezar, necesitas TIEMPO.**

## Conclusión:

El interés compuesto puede ser tu mejor amigo o tu peor enemigo. Úsalo a tu favor invirtiendo temprano y consistentemente, y evita que trabaje en tu contra acumulando deudas.

**La mejor inversión que puedes hacer es TIEMPO + CONSISTENCIA**
''',
      quiz: [
        QuizQuestion(
          pregunta: '¿Cuál es el factor MÁS importante del interés compuesto?',
          opciones: ['El monto inicial', 'El tiempo', 'La suerte', 'Tener mucho dinero'],
          respuestaCorrecta: 1,
          explicacion: 'El tiempo es el factor más importante. Mientras más temprano empieces, más poderoso es el efecto del interés compuesto.',
        ),
        QuizQuestion(
          pregunta: 'Si inviertes al 8% anual, ¿en cuántos años duplicarás tu dinero? (Regla del 72)',
          opciones: ['6 años', '9 años', '12 años', '15 años'],
          respuestaCorrecta: 1,
          explicacion: 'Usando la regla del 72: 72 ÷ 8 = 9 años para duplicar tu inversión.',
        ),
        QuizQuestion(
          pregunta: '¿Qué es el interés compuesto?',
          opciones: [
            'Interés solo sobre el capital inicial',
            'Interés sobre el capital e intereses acumulados',
            'Un tipo de préstamo',
            'Una tarjeta de crédito'
          ],
          respuestaCorrecta: 1,
          explicacion: 'El interés compuesto es ganar intereses no solo sobre tu inversión inicial, sino también sobre los intereses que has acumulado.',
        ),
      ],
    ),
    Leccion(
      id: 4,
      titulo: 'Manejo de Deudas',
      nivel: 2,
      puntos: 100,
      duracion: '10 min',
      descripcion: 'Aprende estrategias para manejar y eliminar deudas de manera inteligente.',
      contenido: '''
# Manejo Inteligente de Deudas

## ¿Qué es una deuda?

Una deuda es dinero que debes a alguien más. Puede ser útil o perjudicial, dependiendo de cómo la uses.

## Tipos de Deuda:

### Deuda Buena 💚
- Te ayuda a generar ingresos o aumentar tu patrimonio
- Ejemplos:
  - Préstamo estudiantil para una carrera rentable
  - Hipoteca para comprar una casa
  - Préstamo empresarial para invertir en tu negocio

### Deuda Mala ❌
- No genera valor a largo plazo
- Ejemplos:
  - Tarjetas de crédito para compras innecesarias
  - Préstamos para vacaciones
  - Financiamiento de artículos que se deprecian

## El Problema de las Deudas:

### 1. Intereses Compuestos en tu Contra
Si pagas solo el mínimo, pagarás 2-3 veces el precio original.

### 2. Estrés Financiero
Las deudas te quitan paz mental y libertad.

### 3. Oportunidad Perdida
El dinero que pagas en intereses podría estar en inversiones.

## Estrategias para Pagar Deudas:

### Método Bola de Nieve ❄️

**Cómo funciona:**
1. Lista todas tus deudas de menor a mayor
2. Paga el mínimo en todas
3. Pon dinero extra en la más pequeña
4. Cuando la pagues, ataca la siguiente

**Ventaja:** Motivación psicológica al ver progreso rápido

**Ejemplo:**
- Deuda 1: S/. 500
- Deuda 2: S/. 2,000
- Deuda 3: S/. 5,000

Empiezas con la de S/. 500, luego S/. 2,000, finalmente S/. 5,000.

### Método Avalancha 🏔️

**Cómo funciona:**
1. Lista todas tus deudas por tasa de interés (mayor a menor)
2. Paga el mínimo en todas
3. Pon dinero extra en la de mayor interés
4. Cuando la pagues, ataca la siguiente

**Ventaja:** Ahorras más dinero en intereses

**Ejemplo:**
- Deuda 1: S/. 5,000 al 18%
- Deuda 2: S/. 2,000 al 12%
- Deuda 3: S/. 500 al 8%

Empiezas con la del 18%, luego 12%, finalmente 8%.

## Consolidación de Deudas:

### ¿Qué es?
Combinar múltiples deudas en una sola con menor tasa de interés.

### Ventajas:
✓ Una sola cuota mensual
✓ Posible menor tasa de interés
✓ Más fácil de administrar

### Precauciones:
⚠️ Asegúrate de que la nueva tasa sea menor
⚠️ No acumules nuevas deudas después
⚠️ Lee bien el contrato

## Negociación con Acreedores:

### Pasos:
1. Contacta a tus acreedores
2. Explica tu situación honestamente
3. Propón un plan de pagos realista
4. Pide reducción de intereses o cuota

**Muchos acreedores preferirán negociar antes que no recibir nada.**

## Plan de Acción:

### Paso 1: Haz un inventario completo
Lista todas tus deudas:
- Acreedor
- Saldo total
- Tasa de interés
- Pago mínimo mensual

### Paso 2: Crea un presupuesto
Encuentra dinero extra para atacar deudas.

### Paso 3: Elige tu método
Bola de nieve o avalancha.

### Paso 4: Comprométete
No acumules nuevas deudas mientras pagas.

### Paso 5: Celebra los logros
Cada deuda pagada es una victoria.

## Cómo Evitar Deudas Futuras:

### 1. Fondo de Emergencia
Ahorra 3-6 meses de gastos.

### 2. Compra con Efectivo
Si no puedes pagarlo en efectivo, no lo necesitas.

### 3. Usa el Crédito Sabiamente
Solo para emergencias reales o compras planeadas que puedas pagar.

### 4. Presupuesta
Conoce tu flujo de dinero.

### 5. Espera 24 Horas
Antes de una compra grande, espera un día para pensarlo.

## Tarjetas de Crédito:

### Úsalas Correctamente:
✓ Paga el saldo completo cada mes
✓ No gastes más de lo que tienes
✓ Aprovecha recompensas y beneficios
✓ Construye historial crediticio

### Evita:
✗ Pagar solo el mínimo
✗ Usarlas para gastos diarios
✗ Tener muchas tarjetas
✗ Adelantos de efectivo

## Consejos Finales:

💡 **Ataca las deudas agresivamente** - Mientras más rápido pagues, menos intereses pagarás.

💡 **Genera ingresos extra** - Trabajo freelance, vender cosas, etc.

💡 **Reduce gastos temporalmente** - Sacrifica hoy para tener libertad mañana.

💡 **No te rindas** - Salir de deudas toma tiempo, pero vale la pena.

## Recuerda:

> "Las deudas son como cualquier otra trampa, suficientemente fáciles de caer en ellas, pero suficientemente difíciles de salir." - Henry Wheeler Shaw

**Tu meta: Vivir libre de deudas y usar el crédito como herramienta, no como muleta.**
''',
      quiz: [
        QuizQuestion(
          pregunta: '¿Cuál es un ejemplo de "deuda buena"?',
          opciones: [
            'Tarjeta de crédito para vacaciones',
            'Préstamo estudiantil para una carrera rentable',
            'Financiamiento para un celular nuevo',
            'Préstamo para comprar ropa'
          ],
          respuestaCorrecta: 1,
          explicacion: 'Un préstamo estudiantil para una carrera que aumentará tus ingresos es deuda buena porque es una inversión en tu futuro.',
        ),
        QuizQuestion(
          pregunta: '¿Qué método de pago de deudas te ahorra más dinero en intereses?',
          opciones: ['Bola de nieve', 'Avalancha', 'Pagar el mínimo', 'No pagar'],
          respuestaCorrecta: 1,
          explicacion: 'El método avalancha ahorra más dinero porque atacas primero las deudas con mayor tasa de interés.',
        ),
        QuizQuestion(
          pregunta: '¿Cuántos meses de gastos deberías tener en tu fondo de emergencia?',
          opciones: ['1 mes', '3-6 meses', '1 semana', '12 meses'],
          respuestaCorrecta: 1,
          explicacion: 'Se recomienda tener entre 3-6 meses de gastos en tu fondo de emergencia para cubrir imprevistos sin recurrir a deudas.',
        ),
      ],
    ),
    Leccion(
      id: 5,
      titulo: 'Fondo de Emergencia',
      nivel: 3,
      puntos: 125,
      duracion: '10 min',
      descripcion: 'Descubre por qué necesitas un fondo de emergencia y cómo construirlo paso a paso.',
      contenido: '''
# Fondo de Emergencia: Tu Red de Seguridad Financiera

## ¿Qué es un Fondo de Emergencia?

Es dinero que guardas específicamente para situaciones inesperadas. Es tu colchón financiero para cuando la vida te sorprende.

## ¿Por qué lo necesitas?

### La Vida es Impredecible:
- Pierdes tu trabajo
- Emergencia médica
- Reparación del auto
- Electrodoméstico se daña
- Gastos funerarios
- Pandemia global

**Sin fondo de emergencia → Deudas**
**Con fondo de emergencia → Tranquilidad**

## ¿Cuánto necesitas?

### Nivel 1: Mini Fondo de Emergencia
**S/. 1,000 - 2,000**
- Para empezar
- Cubre emergencias pequeñas
- Construyelo primero antes de pagar deudas agresivamente

### Nivel 2: Fondo Básico
**3 meses de gastos**
- Para trabajadores con empleo estable
- Si tienes ingresos fijos mensuales
- Pareja con dos ingresos

**Ejemplo:** Si gastas S/. 2,000/mes → S/. 6,000

### Nivel 3: Fondo Completo
**6 meses de gastos**
- Para trabajadores independientes
- Ingresos variables
- Un solo ingreso en la familia
- Industria volátil

**Ejemplo:** Si gastas S/. 2,500/mes → S/. 15,000

### Nivel 4: Fondo Robusto
**9-12 meses de gastos**
- Máxima seguridad
- Próximo a jubilación
- Industria en declive
- Salud delicada

## ¿Qué NO es una emergencia?

❌ Ventas de Black Friday
❌ Vacaciones
❌ Nuevo iPhone
❌ Regalos de cumpleaños
❌ Ropa nueva

✅ Emergencias médicas
✅ Pérdida de empleo
✅ Reparaciones esenciales
✅ Gastos legales urgentes

## ¿Dónde guardar tu fondo?

### Características ideales:
1. **Líquido** - Acceso rápido (24-48 horas)
2. **Seguro** - No puede perder valor
3. **Separado** - No en tu cuenta corriente
4. **Con intereses** - Aunque sean bajos

### Opciones:

**1. Cuenta de Ahorros de Alto Rendimiento**
- ✓ Fácil acceso
- ✓ Gana intereses
- ✓ Seguro
- Tasa: 1-3% anual

**2. Cuenta del Mercado Monetario**
- ✓ Buenos intereses
- ✓ Líquido
- Puede requerir saldo mínimo

**3. Certificado de Depósito (CD) Corto Plazo**
- ✓ Mayor interés
- ✗ Menos líquido
- Solo para parte del fondo

**❌ NO guardes en:**
- Acciones (muy volátiles)
- Criptomonedas (muy riesgosas)
- Bajo el colchón (no gana intereses)
- Inversiones de largo plazo

## Cómo Construir tu Fondo:

### Paso 1: Establece tu Meta
Calcula tus gastos mensuales × meses objetivo

### Paso 2: Abre una Cuenta Separada
No mezcles con tu dinero del día a día

### Paso 3: Automatiza
Configura transferencia automática cada quincena/mes

### Paso 4: Empieza Pequeño
Aunque sean S/. 50 por quincena

### Paso 5: Aumenta Gradualmente
Cada aumento de sueldo, incrementa el ahorro

### Paso 6: Usa "Encontradas"
Impuestos devueltos, bonos, regalos → directo al fondo

### Paso 7: Celebra Hitos
Cada S/. 1,000 ahorrado es un logro

## Estrategias para Ahorrar Más Rápido:

### 1. Desafío de las 52 Semanas
- Semana 1: ahorra S/. 10
- Semana 2: ahorra S/. 20
- Semana 3: ahorra S/. 30
- ...
- Semana 52: ahorra S/. 520
**Total anual: S/. 13,780**

### 2. Método del Sobre
Guarda todo el efectivo y monedas en un sobre

### 3. Redondeo Automático
Apps que redondean compras y ahorran la diferencia

### 4. Un Mes Sin Gastos
Desafíate a no comprar nada innecesario por 30 días

### 5. Vende Cosas
Ropa, electrónicos, muebles que no uses

## Mantenimiento del Fondo:

### SI usas el fondo:
1. Úsalo SOLO para verdaderas emergencias
2. Reemplázalo lo antes posible
3. Pausa otros objetivos financieros si es necesario
4. Evalúa qué salió mal para evitar futuras "emergencias"

### Rebalanceo Anual:
- Revisa si tus gastos mensuales cambiaron
- Ajusta tu meta si es necesario
- Considera inflación

## Plan de Acción Detallado:

### Mes 1-3: Mini Fondo
**Meta:** S/. 1,000
- Ahorra S/. 350/mes
- Pausa inversiones
- Reduce gastos no esenciales

### Mes 4-12: Fondo Básico
**Meta:** 3 meses de gastos
- Ahorra 15-20% de ingresos
- Mantén mini fondo intacto
- Empieza a pagar deudas paralelamente

### Mes 13-24: Fondo Completo
**Meta:** 6 meses de gastos
- Aumenta ahorro al 20-25%
- Incrementa con bonos/aumentos
- Ya puedes invertir paralelamente

## Errores Comunes:

❌ **"Empezaré cuando gane más"**
Empieza con lo que tienes ahora

❌ **Usarlo para "semi-emergencias"**
Mantén disciplina

❌ **Guardarlo en inversiones riesgosas**
Seguridad > rendimiento

❌ **No reponerlo después de usarlo**
Es prioridad #1

❌ **Tenerlo en la cuenta corriente**
Demasiada tentación de gastarlo

## Beneficios Psicológicos:

💚 **Paz Mental**
Duermes mejor sabiendo que estás protegido

💚 **Confianza**
Puedes tomar mejores decisiones

💚 **Libertad**
No vives con ansiedad financiera

💚 **Empoderamiento**
Controlas tu vida, no las circunstancias

## La Regla de Oro:

> **"Paga al fondo de emergencia primero, antes que cualquier otra cosa (excepto necesidades básicas)"**

## Conclusión:

Un fondo de emergencia no es opcional, es **esencial**. Es la diferencia entre un pequeño inconveniente y una catástrofe financiera.

**Tu yo del futuro te lo agradecerá.**

### Acción Inmediata:
1. Calcula cuánto necesitas
2. Abre una cuenta de ahorros separada HOY
3. Programa una transferencia automática
4. Comprométete a no tocarlo excepto emergencias

**No esperes a la emergencia para actuar. Actúa antes de la emergencia.**
''',
      quiz: [
        QuizQuestion(
          pregunta: '¿Cuántos meses de gastos debe cubrir un fondo de emergencia completo?',
          opciones: ['1 mes', '3 meses', '6 meses', '12 meses'],
          respuestaCorrecta: 2,
          explicacion: 'Un fondo de emergencia completo debe cubrir 6 meses de gastos, especialmente si tienes ingresos variables o eres trabajador independiente.',
        ),
        QuizQuestion(
          pregunta: '¿Dónde NO deberías guardar tu fondo de emergencia?',
          opciones: [
            'Cuenta de ahorros de alto rendimiento',
            'Cuenta del mercado monetario',
            'Acciones en la bolsa',
            'Certificado de depósito corto plazo'
          ],
          respuestaCorrecta: 2,
          explicacion: 'Las acciones son muy volátiles y pueden perder valor justo cuando necesitas el dinero. El fondo debe estar en instrumentos seguros y líquidos.',
        ),
        QuizQuestion(
          pregunta: '¿Cuál NO es una verdadera emergencia?',
          opciones: [
            'Pérdida del empleo',
            'Emergencia médica',
            'Ventas de Black Friday',
            'Reparación urgente del auto'
          ],
          respuestaCorrecta: 2,
          explicacion: 'Las ventas de Black Friday son compras planeadas y opcionales, no emergencias. El fondo solo debe usarse para situaciones inesperadas y urgentes.',
        ),
      ],
    ),
    Leccion(
      id: 6,
      titulo: 'Introducción a las Inversiones',
      nivel: 3,
      puntos: 150,
      duracion: '12 min',
      descripcion: 'Aprende los conceptos básicos de inversión y cómo empezar con poco dinero.',
      contenido: '''
# Introducción a las Inversiones

## ¿Qué es Invertir?

Invertir es poner tu dinero a trabajar para generar más dinero. En lugar de que tu dinero esté quieto, lo usas para crear riqueza.

## Ahorro vs. Inversión:

### Ahorro 💰
- Guardas dinero
- Seguro y líquido
- Rendimientos bajos (1-3%)
- Para emergencias y metas corto plazo

### Inversión 📈
- Tu dinero crece
- Mayor riesgo
- Rendimientos potencialmente altos (7-15%+)
- Para metas largo plazo (5+ años)

**Necesitas AMBOS**

## ¿Por qué Invertir?

### 1. Combatir la Inflación
Si tu dinero no crece, **pierde valor**.

**Ejemplo:**
- S/. 10,000 hoy en 20 años comprarán menos
- Inflación promedio: 3% anual
- Necesitas que tu dinero crezca más del 3% para ganar poder adquisitivo

### 2. Alcanzar Metas Grandes
- Casa propia
- Educación de hijos
- Jubilación cómoda
- Libertad financiera

### 3. Generar Ingresos Pasivos
Eventualmente, tu dinero genera dinero sin que trabajes.

### 4. Jubilación
La pensión no será suficiente. Necesitas complementar.

## Conceptos Fundamentales:

### Riesgo vs. Rendimiento
**Más riesgo = Potencialmente más ganancia**
**Menos riesgo = Ganancias más modestas pero seguras**

### Diversificación
**"No pongas todos los huevos en una canasta"**

Distribuye tu dinero en diferentes tipos de inversiones:
- Acciones
- Bonos
- Bienes raíces
- Fondos de inversión

### Horizonte de Tiempo
Cuánto tiempo puedes dejar el dinero invertido:
- Corto plazo: 0-3 años
- Mediano plazo: 3-10 años
- Largo plazo: 10+ años

**Mientras más largo, puedes asumir más riesgo**

### Interés Compuesto
Ya lo aprendiste - ¡es tu mejor amigo!

## Tipos de Inversiones:

### 1. Acciones (Stocks) 📊

**¿Qué son?**
Compras una parte de una empresa.

**Rendimiento promedio:** 10% anual (largo plazo)

**Ventajas:**
✓ Alto potencial de crecimiento
✓ Dividendos (pagos periódicos)
✓ Puedes empezar con poco

**Desventajas:**
✗ Volatilidad (sube y baja)
✗ Requiere investigación
✗ Riesgo de pérdida

**Para quién:**
- Horizonte de 5+ años
- Tolerancia al riesgo
- Jóvenes

### 2. Bonos (Bonds) 📋

**¿Qué son?**
Prestas dinero a gobiernos o empresas que te pagan intereses.

**Rendimiento promedio:** 3-6% anual

**Ventajas:**
✓ Más estables que acciones
✓ Ingresos predecibles
✓ Menor riesgo

**Desventajas:**
✗ Rendimientos más bajos
✗ Inflación puede reducir ganancias

**Para quién:**
- Buscan estabilidad
- Cerca de jubilación
- Complemento de portafolio

### 3. Fondos Mutuos y ETFs 🏦

**¿Qué son?**
Colección de acciones/bonos administrada profesionalmente.

**Rendimiento promedio:** 7-12% anual

**Ventajas:**
✓ Diversificación automática
✓ Administración profesional
✓ Fácil de entender
✓ Puedes empezar con poco

**Desventajas:**
✗ Comisiones de administración
✗ Menos control

**Para quién:**
- **Principiantes** ← ¡COMIENZA AQUÍ!
- Quieren diversificación fácil
- Poco tiempo para investigar

### 4. Bienes Raíces 🏠

**¿Qué es?**
Compras propiedades para rentar o revender.

**Rendimiento promedio:** 8-12% anual

**Ventajas:**
✓ Activo tangible
✓ Ingresos por renta
✓ Apreciación de valor

**Desventajas:**
✗ Requiere mucho capital inicial
✗ Mantenimiento y gestión
✗ Menos líquido

**Para quién:**
- Mayor capital
- Quieren invertir tiempo
- Inversión de largo plazo

### 5. REITs (Fideicomisos de Bienes Raíces)

**¿Qué son?**
Inviertes en bienes raíces sin comprar propiedad física.

**Rendimiento promedio:** 8-10% anual

**Ventajas:**
✓ Bienes raíces con poco capital
✓ Líquido (compras/vendes fácil)
✓ Dividendos regulares

**Para quién:**
- Quieren exposición a bienes raíces
- Sin capital para comprar propiedad

## Estrategias de Inversión:

### 1. Dollar-Cost Averaging (Promedio de Costo)

**¿Qué es?**
Invertir una cantidad fija regularmente, sin importar el precio.

**Ejemplo:**
Inviertes S/. 500 cada mes durante un año
- A veces compras caro
- A veces compras barato
- **Promedio:** precio justo

**Ventaja:** Elimina emociones y timing del mercado

### 2. Asignación de Activos

**Regla Simple:**
**% de bonos = tu edad**
**% de acciones = 100 - tu edad**

Ejemplos:
- 30 años: 70% acciones, 30% bonos
- 50 años: 50% acciones, 50% bonos
- 60 años: 40% acciones, 60% bonos

### 3. Rebalanceo Anual

Cada año, ajusta tu portafolio a tu asignación objetivo.

## Cómo Empezar a Invertir:

### Paso 1: Prepárate
✓ Ten fondo de emergencia
✓ Paga deudas de alto interés
✓ Define tus metas

### Paso 2: Edúcate
✓ Lee libros (esta lección es un inicio)
✓ Sigue fuentes confiables
✓ Evita "hacerse rico rápido"

### Paso 3: Abre una Cuenta
- Bróker tradicional
- Robo-advisors (automático)
- Apps de inversión

### Paso 4: Empieza Pequeño
- No necesitas S/. 10,000
- Algunos fondos permiten desde S/. 100

### Paso 5: Sé Consistente
- Invierte regularmente
- Automatiza si es posible
- No pares por volatilidad

### Paso 6: Sé Paciente
- No revises a diario
- Piensa en décadas, no días
- No vendas en pánico

## Errores de Principiantes:

❌ **Esperar el "momento perfecto"**
El mejor momento fue ayer, el segundo mejor es hoy.

❌ **Poner todo en una inversión**
Diversifica siempre.

❌ **Seguir consejos de "expertos" en redes**
Haz tu propia investigación.

❌ **Vender en pánico cuando baja**
El mercado siempre tiene altibajos.

❌ **Intentar "timing" del mercado**
Nadie puede predecir el mercado consistentemente.

❌ **No reinvertir las ganancias**
Deja que el interés compuesto trabaje.

❌ **Invertir dinero que necesitas pronto**
Solo invierte dinero que no necesitarás en 5+ años.

## Reglas de Oro:

1. **Invierte solo lo que puedas perder**
2. **Diversifica**
3. **Piensa a largo plazo**
4. **Reinvierte las ganancias**
5. **Empieza temprano**
6. **Sé consistente**
7. **Edúcate constantemente**
8. **No persigas "hot tips"**
9. **Mantén las emociones fuera**
10. **Revisa anualmente, no diariamente**

## Plan de Inversión para Principiantes:

### Si tienes S/. 500/mes para invertir:

**Opción 1: Conservador**
- 70% Fondo indexado (ETF)
- 20% Bonos
- 10% Acciones individuales (aprende)

**Opción 2: Moderado**
- 60% Fondo indexado
- 30% Acciones individuales
- 10% REITs

**Opción 3: Agresivo (joven)**
- 80% Fondo indexado de acciones
- 15% Acciones individuales
- 5% Bonos

## Recursos para Aprender Más:

### Libros Recomendados:
- "El Inversor Inteligente" - Benjamin Graham
- "Padre Rico, Padre Pobre" - Robert Kiyosaki
- "El Millonario de la Puerta de al Lado"

### Apps para Practicar:
- Apps de simulación de inversiones
- Cuentas demo de brókers

## Advertencias Importantes:

⚠️ **Evita:**
- Esquemas Ponzi
- "Duplica tu dinero en 30 días"
- Criptomonedas sin entender (altamente especulativo)
- Trading diario (day trading) como principiante
- Invertir en lo que no entiendes

⚠️ **Señales de Alerta:**
- Promesas de rendimientos garantizados muy altos
- Presión para invertir rápido
- Falta de transparencia
- No está regulado

## Aspectos Fiscales:

✓ Aprende sobre impuestos a las ganancias de capital
✓ Algunas cuentas tienen beneficios fiscales
✓ Consulta un contador cuando sea relevante

## Conclusión:

Invertir no es solo para ricos. Es para **cualquiera** que quiera construir riqueza a largo plazo.

**La mejor inversión que puedes hacer es en tu educación financiera.**

### Acción Inmediata:

1. ✅ Asegura tu fondo de emergencia
2. ✅ Define una meta de inversión
3. ✅ Investiga un fondo indexado para empezar
4. ✅ Abre una cuenta de inversión
5. ✅ Haz tu primera inversión (aunque sea pequeña)
6. ✅ Automatiza inversiones mensuales
7. ✅ Sigue aprendiendo

**Recuerda:**
> "El mejor momento para plantar un árbol fue hace 20 años. El segundo mejor momento es ahora." - Proverbio chino

**¡Empieza tu viaje de inversión hoy!**
''',
      quiz: [
        QuizQuestion(
          pregunta: '¿Cuál es el rendimiento promedio histórico de las acciones a largo plazo?',
          opciones: ['3%', '5%', '10%', '20%'],
          respuestaCorrecta: 2,
          explicacion: 'El rendimiento promedio histórico de las acciones a largo plazo es aproximadamente 10% anual, aunque varía año con año.',
        ),
        QuizQuestion(
          pregunta: '¿Qué tipo de inversión es mejor para principiantes?',
          opciones: [
            'Acciones individuales',
            'Trading diario',
            'Fondos indexados y ETFs',
            'Criptomonedas'
          ],
          respuestaCorrecta: 2,
          explicacion: 'Los fondos indexados y ETFs son ideales para principiantes porque ofrecen diversificación automática y administración profesional.',
        ),
        QuizQuestion(
          pregunta: '¿Qué es el Dollar-Cost Averaging?',
          opciones: [
            'Comprar solo cuando el precio es bajo',
            'Invertir una cantidad fija regularmente',
            'Vender cuando sube el precio',
            'Guardar dinero en efectivo'
          ],
          respuestaCorrecta: 1,
          explicacion: 'Dollar-Cost Averaging es invertir una cantidad fija regularmente, sin importar el precio del mercado, lo que reduce el riesgo y elimina las emociones.',
        ),
      ],
    ),
  ];
}
