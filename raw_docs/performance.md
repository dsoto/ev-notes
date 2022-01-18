```{.python .cb.run include_file=set_figure_location.py}
```

:::{.instructor}

Limits

- maximum initial acceleration limited by phase current
- thermal limits of motor wire enamel
- thermal limits of motor hall sensors
- thermal limits of wires
- thermal limits of battery
- thermal limits of controller

:::

# Performance Characteristics

- Acceleration
    - achieved through increased phase amps
    - minimum gear/lever arm
- Top Speed
    - determine wind resistance power at top speed
    - sufficient battery voltage to provide necessary current at top speed
- Efficiency
    - low phase amp, high RPM operating condition


# Initial Acceleration

Initial torque is determined by the maximum phase amps through the motor.
Using a simple DC motor model, the torque is the product of the motor constant, $k$, and the phase current $I$.

$$ \tau = k I $$

Controllers usually have a specification for the maximum phase current they can produce.
To see if your battery and motor are capable of delivering that maximum phase current, you must know the battery voltage, battery internal resistance, and motor resistance.

:::{.instructor}

TODO: diagram of DC motor model

TODO: diagram of 3-phase motor model

:::


```{.python .cb.run}
import schemdraw
import schemdraw.elements as elm
d = schemdraw.Drawing()
# d += elm.BatteryCell().up().reverse().label('V').length(6)
d += elm.BatteryCell().up().reverse().label('V')
d += elm.Resistor().label('$R_{battery}$')
d += elm.Line().right()
d += elm.Resistor().down().label('$R_{motor}$')
d += elm.Motor().down().label('EMF')
d += elm.Line().left()

d.draw(show=False)
filename = 'figures/motor-model-phase-current.svg'
d.save(filename)
markdown = '![](' + filename + ')'
```

`markdown`{.python .cb.expr}

The maximum phase amps possible is given by Ohm's Law.
At zero RPM, the motor EMF is zero and we get the full battery voltage across the two resistances.
Take your battery voltage and divide by the sum of the battery internal resistance and motor resistance

$$ V = I R = I (R_{battery} + R_{motor}) $$
$$ I = V / (R_{battery} + R_{motor}) $$

For a typical 14s4p battery and hub motor the resistances are about 100 mOhms.

$$ 52 V / (0.1 \Omega + 0.1 \Omega) = 260 A $$

If I bought a controller capable of 400 phase amps, I wouldn't be able to utilize its full potential.

The Lightning Rods big block has a resistance closer to 30 mOhms, so:

$$ I = V / (R_{battery} + R_{motor}) $$
$$ 52 V / (0.1 \Omega + 0.03 \Omega) = 400 A $$


:::{.instructor}
TODO: add citations
:::

:::{.instructor}
Mid-Band Acceleration

TODO:
:::

# Top Speed

```{.python .cb.nb}

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

cd = 1.0
density = 1.2
area = 0.504 # Morchin and Oman pg 25
drag_coeff = cd * density * area / 2

# speed_mps = 13.4

speed_mps = np.linspace(0,20,20)
force_N = speed_mps**2 * drag_coeff
power_W = force_N * speed_mps
fig, ax = plt.subplots()
ax.plot(speed_mps, power_W)

```

```{.python .cb.run}
ax.set_xlabel('Speed (mps)')
ax.set_ylabel('Drag Power (W)')
ax.grid(True)
filename = 'figures/drag.svg'
fig.savefig(filename)
markdown = '![](' + filename + ')'
```

`markdown`{.python .cb.expr}

So we need our mechanical power to be equal to this wind drag power and we need a system that can provide the electrical power necessary to acheive this.

:::{.instructor}

- use rpm to get angular velocity to get torque needed.
- how to get voltage sag on battery to be sure we get sufficient voltage and current across EMF.

:::