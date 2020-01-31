with MicroBit.IOs; use MicroBit.IOs;
with MicroBit.Time; use MicroBit.Time;
with HAL;      use HAL;
with NeoPixel; use NeoPixel;
with LED_Demo; use LED_Demo;
with MicroBit.Servos; use MicroBit.Servos;


-- goal is to program a real locking system or rather a game

procedure Main is

   -- this is necessary to limit the idle;
   countTime : Time_Ms := Clock;
   -- this is necessary to make the variable above comparable;
   countTimeUInt64 : UInt64;
   -- this is necessary to make the counter and current time/Clock unequal at start
   bootTime : constant UInt64 := 5000;

   -- LED can be controlled with all colors
   Strip : LED_Strip := Create (Mode => GRB, Count => 18);

   dialValue : Analog_Value;
   dialValueColor : Analog_Value;
   
   -- used to compare red,blue and green
   -- red = 0
   -- green = 1
   -- blue = 2
   -- the first variable is to save during the gametime and will be used to assign to the index
   Dial_Color : Integer;
   Dial_Color_First : Integer;
   Dial_Color_Second : Integer;
   Dial_Color_Third : Integer;
   Dial_Color_Fourth : Integer;

   LED_Index : Natural := 4;
   
   All_White_Color_Values : constant LED_Values := (LED_Green => 255,LED_Red => 255,LED_Blue=>255,LED_White=>255);
   All_Green_Color_Values : constant LED_Values := (LED_Green => 255,LED_Red => 0,LED_Blue=>0,LED_White=>255);
   All_Red_Color_Values : constant LED_Values := (LED_Green => 0,LED_Red => 255,LED_Blue=>0,LED_White=>255);
   All_Blue_Color_Values : constant LED_Values := (LED_Green => 0,LED_Red => 0,LED_Blue=>255,LED_White=>255);
   Color_Values : LED_Values := (LED_Green => 255,LED_Red => 255,LED_Blue=>255,LED_White=>255);

   t : Analog_Value := 100;

begin
   -- close the Lock
   Go(0,50);
   Delay_Ms(1000);
   Stop(0);

   for I in  1..4 loop
      -- color can be changued for each LED individually
      if I = 1 then
         LED_Index := 4;
      elsif I = 2 then
         LED_Index := 3;
      elsif I = 3 then
         LED_Index := 7;
      else
         LED_Index := 0;
      end if;

      -- signal for the players which light has to be controlled next
      for I in 1..3 loop
         Set_Color (Strip, LED_Index, All_Red_Color_Values);
         Show (Strip, Kitronik_Write'Access);
         Delay_Ms(500);
         Set_Color (Strip, LED_Index, All_Green_Color_Values);
         Show (Strip, Kitronik_Write'Access);
         Delay_Ms(500);
         Set_Color (Strip, LED_Index, All_Blue_Color_Values);
         Show (Strip, Kitronik_Write'Access);
         Delay_Ms(500);
         Set_Color (Strip, LED_Index, All_White_Color_Values);
         Show (Strip, Kitronik_Write'Access);
         Delay_Ms(500);
      end loop;

      countTime := Clock;
      countTimeUInt64 := UInt64(countTime);
   -- the player has 5 seconds to choose a color for a LED
      while countTimeUInt64+bootTime > UInt64(Clock) loop
      
      -- after reading the potentiometer...
         dialValue := Analog(1);
      -- the input needs to be adjusted because the coditional statement is made from red to red but I want red to purple
         dialValueColor := dialValue*5/6;

         if dialValue < 160 then
            Dial_Color := 0;
            Set_Color (Strip, LED_Index, All_Red_Color_Values);
         elsif dialValue < 530 then
            Dial_Color := 1;
            Set_Color (Strip, LED_Index, All_Green_Color_Values);
         else
            Dial_Color := 2;
            Set_Color (Strip, LED_Index, All_Blue_Color_Values);

         end if;
         Show (Strip, Kitronik_Write'Access);

      end loop;

      if I = 1 then
         Dial_Color_First := Dial_Color;
      elsif I = 2 then
         Dial_Color_Second := Dial_Color;
      elsif I = 3 then
         Dial_Color_Third := Dial_Color;
      else
         Dial_Color_Fourth := Dial_Color;
      end if;

   end loop;

   --  Thief lose
    if Dial_Color_First = Dial_Color_Second and Dial_Color_First = Dial_Color_Third and Dial_Color_First = Dial_Color_Fourth then

         Go(0,50);
     Delay_Ms(1000);
      Stop(0);
    --  Thief win
   elsif (Dial_Color_First = Dial_Color_Second and Dial_Color_First = Dial_Color_Third) or (Dial_Color_First = Dial_Color_Second and Dial_Color_First = Dial_Color_Fourth) or (Dial_Color_Fourth = Dial_Color_Second and Dial_Color_Fourth = Dial_Color_Third) then

   Go(0,0);
     Delay_Ms(1000);
      Stop(0);
   --  Thief lose
   else

         Go(0,50);
     Delay_Ms(1000);
      Stop(0);
   end if;
   --  the program restarts if the program ends and therefore we include an empty infinite loop after the game is over
   loop

      null;

   end loop;
end Main;
