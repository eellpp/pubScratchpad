## Floating point truncation leads to death of 28 soldiers

https://en.wikipedia.org/wiki/MIM-104_Patriot#

A government investigation revealed that the failed intercept at Dhahran had been caused by a software error in the system's handling of timestamps.[46][47] The Patriot missile battery at Dhahran had been in operation for 100 hours, by which time the system's internal clock had drifted by one-third of a second. Due to the missile's speed this was equivalent to a miss distance of 600 meters.

The radar system had successfully detected the Scud and predicted where to look for it next. However, the timestamps of the two radar pulses being compared were converted to floating point differently: one correctly, the other introducing an error proportionate to the operation time so far (100 hours) caused by the truncation in a 24-bit fixed-point register. As a result, the difference between the pulses was wrong, so the system looked in the wrong part of the sky and found no target. With no target, the initial detection was assumed to be a spurious track and the missile was removed from the system.[48][49] No interception was attempted, and the Scud impacted on a makeshift barracks in an Al Khobar warehouse, killing 28 soldiers, the first Americans to be killed from the Scuds that Iraq had launched against Saudi Arabia and Israel.

