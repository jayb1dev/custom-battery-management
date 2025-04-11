#
# custom-battery-management
#

## Ubuntu systemd service for battery power management

This systemd service uses an external smart plug 
to enable and disable battery charging 
on systems which do not support 
`charge_control_start_threshold`
and 
`charge_control_end_threshold`

E.g. 

See: https://askubuntu.com/questions/1526046/setting-the-battery-charge-threshold-in-ubuntu-24-04-lts

```
/sys/class/power_supply/BAT0/charge_control_start_threshold = (not available) 
/sys/class/power_supply/BAT0/charge_control_end_threshold   = (not available) 
```

See also: https://gitlab.com/yakopov/battery-threshold-smart-plug

## Pre-reqs

### Hardware

```
TODO add hardware info here
```

### Software

#### Install tlp.

> NOTE: TLP can conflict with PPD (power-profiles-daemon).
> You should uninstall power-profiles-daemon before installing tlp. 

> See: https://askubuntu.com/questions/1534116/ubuntu-24-04-and-tlp


```
sudo apt install tlp
```

#### Install python libs

```
TODO add this here
```

## Install custom-battery-management

Clone the git repo.

E.g.

```
git clone https://github.com/jayb1dev/custom-battery-management.git
```

From within the cloned dir, as root run:

```
./install.sh
```




