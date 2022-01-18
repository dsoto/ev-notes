# Controller Installation

:::{.instructor}

Notes

:::

It is advisable to bring up a new controller with a current-limited power supply until you are confident that it is assembled and working correctly.
Since a battery can have hundreds of amps of short circuit current, a current-limited power supply will prevent destructive levels of current from entering the controller.
Once you are confident in the operation of the controller, you can start testing with a fused battery.

# Test 3V3 Power Supply

- set power supply to 250 mA and 18 volts
- verify power LED

# Test USB connection

- set power supply to 250 mA and 18 volts
- connect USB cable
- launch vesc tool
- confirm connection between controller and laptop

# Test Voltage Sensing

- connect controller to motor
- set power supply to 250 mA and 18 volts
- set current limit low on controller
- spin wheel
- sample data
- look for smooth sinusoids in BEMF tab of sampled data

# Test Current Sensing

- connect controller to motor
- set power supply to 5 A and 18 volts
- set current limit low on controller
- set braking
- confirm smooth braking
- spin wheel
- sample data
- look for smooth sinusoids in current tab

# Controller Tuning

Roughly speaking, an FOC controller has two main tasks.
First, to maintain a current value proportional to the throttle input.
Second, to inject that current at the correct angle with respect to the rotating permanent magnets.

The controller need three measurements for this, the motor resistance, the motor inductance(s), and the flux linkage.
The wizard performs an adaptive measurement of these three values given a few hints about your motor type and battery.

# Perform Detection with Wizard

Note that the wizard will automatically write the detected parameters to the flash memory on the controller.
If you make other changes to the parameters, be sure to write them to the controller for them to take effect.

After detection, compare the values to the motor specification to be sure you had a valid detection.

:::{.instructor}
- confirm that inductance and resistance are phase-neutral and not line to line
- need a flux linkage to Kv conversion
:::

# Corroborate Resistance Value

- Kelvin connect motor, current limited power supply, voltage meter
- Dial in current with power supply, measure voltage
- Repeat for several points
- Plot points, fit line
- Report data

:::{.instructor}
- TODO: make notebooks for each motor, start with 9CTB
:::

# Corroborate Inductance Value

# Corroborate Flux Linkage

# Test Current Step Response

To determine if the current controller is working correctly, you can send a step input to the controller from VESC tool.
If the current overshoots the set point, this could be a source of overcurrent errors.

- Use current button to provide step input to controller
    - If possible with a loaded motor
- Observe d and q current in realtime foc tab

:::{.instructor}

- TODO: what are expected behaviors of Vd and Vq?
- TODO: What are expected overshoot and ringing
- TODO: What are parameters to adjust to reduce overshoot

:::