# Simu-Microscope
Simu-Microscope is an open-source STM control system developed by **SPMM Lab (Scanning Probe Metrology and Manufacturing Laboratory)**.

Scanning Tunneling Microscopy (STM), as a key member of the Scanning Probe Microscopy (SPM) family, is widely used in nanotechnology due to its ultra-high spatial resolution. However, the development of STM control systems that balance cost, performance, and development efficiency remains a critical challenge.

In this work, we propose **Simu-Microscope**, an open-source STM control system based on Model-Based Design (MBD) using Simulink. The system is implemented on the Texas Instruments TMS320F28379D microcontroller.

## Key Features

- Simu-Microscope achieves effective cost control while maintaining high-performance STM control.  
- MBD with Simulink enables continuous identification and correction of errors by integrating testing with the design process, significantly enhancing development efficiency.
- By leveraging the mature algorithm ecosystem of Simulink, the development complexity of STM controllers is substantially reduced.  
## Validation

Simu-Microscope fully implements the required STM system functions and integrates a dedicated graphical user interface (GUI). After integrating the control system into a home-made STM platform, topographic imaging of a DVD-R sample was performed. The results show that the obtained grating image is consistent with measurements from a commercial atomic force microscope (AFM), validating the feasibility and effectiveness of the proposed control system.
