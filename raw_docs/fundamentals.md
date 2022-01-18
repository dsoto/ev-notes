```{.python .cb.run include_file=set_figure_location.py}
```

:::{.instructor}

- put in torque speed curve to illustrate stall torque and no-load speed
- can you overlay a torque speed relationship (ungeared) for a motor with a certain aerodynamic profile?

- need BLV stuff
- need torque angular velocity power equation and source
- cover section 3.4.4 of hughes and drury with constant torque and constant power region of torque speed curve.
- section 9.7.4 of hughes and drury has a torque speed curve with an I^2R limit curve

:::


# Motor principles

The operation of a motor relies on the interaction of current and magnetic fields.

# Linear Motor

This linear DC motor allows us to predict the behavior of many motor types.

- The force on a wire is proportional to the magnetic field, the current in the wire, and the length of the wire and is independent of the velocity of the wire.
- The voltage induced in the wire (back-EMF) is proportional to the magnetic field, the length of the wire, and the wire's velocity.


$$T = BIl$$

$$E = Blv$$

![](./figures_static/simple-DC-motor-fields.png)
![](./figures_static/simple-DC-motor.png)

# DC Motor Constant

When we look at a rotating motor, the magnetic and wire properties are combined in the motor constant $k$.

The torque is proportional to the current through the motor and this constant, $k$.

$$ T = k I $$

The induced back EMF is proportional to the speed of the motor, $\omega$ and this constant $k$.

$$ E = k \omega $$

Motor specification sheets often publish another form of $k$, called $Kv$ which is in units of RPM per volt.

$$ E = RPM / Kv $$




# Equivalent Circuit

To understand the behavior of a motor at steady state, an equivalent circuit with a speed dependent voltage and a resistor is used.
Much of the intuition we gain from this simple 2-terminal DC motor applies to the 3-terminal BLDC motor.

Here is the circuit of the motor connected to the voltage source.

```{.python .cb.run}
import schemdraw
import schemdraw.elements as elm
d = schemdraw.Drawing()
d += elm.BatteryCell().up().reverse().label('V')
d += elm.Line().right()
d += elm.Motor().down()
d += elm.Line().left()

d.draw(show=False)
filename = 'figures/motor-circuit.svg'
d.save(filename)
markdown = '![](' + filename + ')'
```

`markdown`{.python .cb.expr}

Here is the equivalent circuit for the motor.

```{.python .cb.run}
import schemdraw
import schemdraw.elements as elm
d = schemdraw.Drawing()
d += elm.BatteryCell().up().reverse().label('V').length(6)
d += (topline := elm.Line().right())
d += elm.CurrentLabel().at(topline).label(r'$I=\tau/k$')
d += elm.Resistor().down().label('R')
d += elm.Source().down().label('$E=k\omega$')
d += elm.Line().left()

d.draw(show=False)
filename = 'figures/motor-model.svg'
d.save(filename)
markdown = '![](' + filename + ')'
```

`markdown`{.python .cb.expr}

With this model we can estimate

- The power lost to heat in the motor. ($I^2 R$)
- The difference between the applied voltage and the back-EMF based on the voltage drop from the resistance. ($IR$)

The torque-current and speed-voltage relationships still apply.

:::{.instructor}
TODO: image of motor turning shaft with power torque etc.
:::

To model the dynamic electrical behavior of the motor, we add an inductor to our model.
With this model, we can show how the current responds to rapid changes in voltage.
These details are important for the current control loop of the motor.

```{.python .cb.run}
import schemdraw
import schemdraw.elements as elm
d = schemdraw.Drawing()
d += elm.BatteryCell().up().reverse().label('V').length(9)
d += (topline := elm.Line().right())
# d += elm.CurrentLabel().at(topline).label(r'$I=\tau/k$')
d += elm.Resistor().down().label('R')
d += elm.Inductor().down().label('L')
d += elm.Source().down().label('E')
d += elm.Line().left()

d.draw(show=False)
filename = 'figures/motor-model-RL.svg'
d.save(filename)
markdown = '![](' + filename + ')'
```

`markdown`{.python .cb.expr}

## Power, Torque, and Angular Velocity

The mechanical output energy is equal to the torque times the angle over which that torque was applied.

$$E = \tau \theta$$

This is analagous to work equals force multiplied by distance.

$$P = \tau \omega$$

The mechanical power equals torque multiplied by the angular velocity.

## Voltage Constant

- Often called Kv and expressed in rpm/volt
- We can convert this to radians per second per volt

$$\frac{rev}{min}\frac{1}{volt}\frac{2\pi\ rad}{rev}\frac{min}{60 sec} = \frac{rad}{volt \cdot sec} $$

## Torque Constant

Note that the torque constant is the reciprocal of the voltage constant when the voltage constant is in radians per volt per second.

$$\frac{rad}{volt \cdot sec} = \frac{rad \cdot coulomb}{joule \cdot sec} = \frac{amp}{newton \cdot meter} $$

:::{.instructor}

big block motor is 62 rpm per volt

so a 52 volt battery will yield 3224 rpm.

note, 2 meter wheel circumference at 14 meters per second is 7 rev per second or 420 rpm.

3224/420 implies a 7.6 to 1 reduction for 30 mph at no-load speed.

This needs to be refined for the torque at 30 mph


:::

# No-Load Speed

# 10 No load speed

You have a motor with an 10 rpm/V motor constant.
You connect it to a 50 volt battery.

We want to know how fast it will spin.

To use this formula correctly we need to be sure our units are correct.
Our simplified model assumes that no current is flowing so that the entire battery voltage is equal to the back EMF.

In the language of the universe, we have this equation.

$$ E = k \omega $$

In the language of vehicle enthusists, we have this equation.

$$ RPM = E \cdot K_v $$

We multiply the motor constant by the voltage to get the no load RPM.

$$ RPM = 50V \cdot 10 rpm/volt = 500 RPM $$

You can use your gearing and wheel size to convert this to a speed, but that speed will be an overestimate since it will take torque and current to overcome the air resistance at high speed.

# Example

You have a motor with an motor constant, Kv of 8.5 rpm/volt.
The motor has an internal resistance of 1 ohm.
(This is equivalent to 1.12 N-m/amp.)
You want your motor to spin at 60 rpm while providing 10 N-m of torque.

- What should your applied voltage V be?

Note that this is essentially a voltage divider question, so we use the same strategies but the physical conditions of the motor tell us about the induced voltage and the current flowing through the motor.

The voltage to operate the motor is the sum of the induced (back EMF) voltage, E, and the voltage across the resistor.
We find E from the rpm and the motor constant.
We find the voltage across the resistor from the current which we find from the torque.

$$ E = 60 rpm \cdot \frac{volt}{8.5\ rpm} = 7.1 V $$
$$ I = 10 Nm \cdot \frac{amp}{1.12 Nm} = 8.9 A $$

We use this current to find the voltage drop on the resistor.

$$ V = IR = 8.9 A \cdot 1 \Omega  = 8.9 V $$

The necessary voltage is then 8.9V + 7.1V = 16V.

To find the efficiency, we divide the mechanical power by the power delivered by the voltage source.
The power delivered to the motor is $P = IV = 16V \cdot 8.9A = 142W$

In the resistor we lose $P = I^2R = (8.9A)^2 \cdot 1 \Omega = 79 W$

The mechanical power is the torque times the angular velocity.

$$P = \tau \omega = 10 Nm \frac{60\ rev}{min} \frac{2\pi\ rad}{rev} \frac{min}{60\ sec}$$
$$ = 63 W $$

So 142 total watts delivered by the voltage source equals 63 W mechanical power plus 79 watts of heat in the coils.

$$ \eta = \frac{63\ W\ mech}{142\ W\ input} = 0.44 $$




:::{.instructor}

![](./figures_static/motors/2021-03-15 15.10.25.jpg)
![](./figures_static/motors/2021-03-15 15.14.27.jpg)
![](./figures_static/motors/2021-03-15 15.33.30.jpg)
![](./figures_static/motors/2021-03-15 15.37.31.jpg)
![](./figures_static/motors/2021-03-15 16.52.04.jpg)
![](./figures_static/motors/2021-03-17 15.07.19.jpg)
![](./figures_static/motors/2021-03-17 15.24.03.jpg)

:::


## Induction motor video
[Induction motor video](http://www.youtube.com/watch?v=LtJoJBUSe28&list=TLmiKVvq4MYHnL-89BeJyEEqPBZSzC1sH9)

## Squirrel cage can motor
[motor video](https://www.youtube.com/watch?v=P-eTLmJC2cQ)

## Further Investigation

Jantzen Lee has an excellent
[series of videos](https://www.youtube.com/user/jtlee1108/videos)
on motor operation.

## DIY Brushed Motor Video

[Brushed Motor](https://www.youtube.com/watch?v=g0eanHgpRKg)

[Things in Motion Blog](https://things-in-motion.blogspot.com/2019/05/understanding-bldc-pmsm-electric-motors.html)

# Control

https://jpieper.com/2021/04/13/auto-tuning-current-control-loops/

Plant:

$$ P = \frac{1}{R + Ls} $$

Control:

$$ C = K_p + \frac{Ki}{s} $$

Open Loop Gain:

$$ C P $$

$$ CP = \frac{K_p s + K_i}{Ls^2 + Rs} $$

:::{.instructor}
how do we use open loop gain to derive closed loop gain?
:::

Closed Loop Gain:

$$ \frac{CP}{1 + CP} $$


$$ \frac{\frac{K_p s + K_i}{Ls^2 + Rs}}
        {1 + \frac{K_p s + K_i}{Ls^2 + Rs}} $$

$$ \frac{K_p s + K_i}
        {Ls^2 + (R + K_p)s + K_i} $$

$$ K_i = K_p \frac{R}{L} $$
$$ K_p = \omega L $$
$$ K_i = \omega R $$

For my vesc control loops it appears $\omega = 1000$.

$$ \frac{\omega (L s + R)}
        {Ls^2 + (R + \omega L)s + \omega R} $$

$$ \frac{\omega (L s + R)}
        {(L s + R)(s + \omega)}$$

The closed-loop gain after this choice of $K_p$ and $K_i$ is:

$$ \frac{\omega}
        {s + \omega}$$

Gain at $\omega$ is 1/2 or -3dB.

Substituting into the open-loop gain:

$$ CP = \frac{\omega (L s + R)}{Ls^2 + Rs} $$

Dave Wilson uses a series PI controller which defines $K_b = R/L$ and $K_a = L \cdot bandwidth$.
This formulation has $K_b$ as the controller zero defined as $R/L$.

:::{.instructor}
This zero is used to cancel out the pole in the plant function which I think means the O dB crossing in the closed loop gain is there.
:::

$$ K_a = K_p $$
$$ K_b = K_i / K_p$$

So, the constants as defined by Dave converted to the parallel form are:

$$ K_p = K_a = L \cdot bandwidth $$
$$ K_i = K_b \cdot K_p = R/L \cdot L \cdot bandwidth $$

These match our definitions above.

:::{.instructor}
Why does the series show the zero as R/L but the parallel the zero is the bandwidth?
:::