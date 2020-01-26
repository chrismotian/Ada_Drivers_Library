with MicroBit.IOs; use MicroBit.IOs;
with MicroBit.Time; use MicroBit.Time;
with HAL;      use HAL;

-- goal is to program a light which will be used to substitute a real locking system
-- real locking system could be a servo
-- turned on light is same as a locked lock

-- the lock can't be unlocked because there is no input yet and therefore the light is turned on forever
procedure Main is

   -- this is necessary to limit the idle;
   countTime : Time_Ms := Clock;
   -- this is necessary to make the variable above comparable;
   countTimeUInt64 : UInt64;
   -- this is necessary to make the counter and current time/Clock unequal at start
   bootTime : constant UInt64 := 10000;

begin

   --  Turn on the LED connected to pin 0
   Set (0, True);

   countTimeUInt64 := UInt64(countTime);
   --  lockLight light up forever
   while countTimeUInt64 < UInt64(Clock)+bootTime loop

      null;

   end loop;
end Main;
