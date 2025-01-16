--
--  startup.adb
--

package body Startup is

   type Section_Array is array (Unsigned_32 range <>) of Unsigned_8;

   procedure Reset_Handler is

      Data_Section_Start : Unsigned_8
         with
         Import,
         Convention => Asm,
         External_Name => "_sdata";

      Data_Section_End : Unsigned_8
         with
         Import,
         Convention => Asm,
         External_Name => "_edata";

      Data_Size : constant Unsigned_32 :=
         Addr_To_U32 (Data_Section_End'Address)
         - Addr_To_U32 (Data_Section_Start'Address);

      Data_In_Flash : Section_Array (1 .. Data_Size)
         with
         Import,
         Convention => Asm,
         External_Name => "_load";

      Data_In_Ram : Section_Array (1 .. Data_Size)
         with
         Import,
         Convention => Asm,
         External_Name => "_sdata";

      BSS_Section_Start : Unsigned_8
         with
         Import,
         Convention => Asm,
         External_Name => "_sbss";

      BSS_Section_End : Unsigned_8
         with
         Import,
         Convention => Asm,
         External_Name => "_ebss";

      BSS_Size : constant Unsigned_32 :=
         Addr_To_U32 (BSS_Section_End'Address)
         - Addr_To_U32 (BSS_Section_Start'Address);

      BSS_In_Ram : Section_Array (1 .. BSS_Size)
         with
         Import,
         Convention => Asm,
         External_Name => "_sbss";

   begin

      for byte in Data_In_Ram'First .. Data_In_Ram'Last loop
         Data_In_Ram (byte) := Data_In_Flash (byte);
      end loop;

      for byte in BSS_In_Ram'First .. BSS_In_Ram'Last loop
         BSS_In_Ram (byte) := 16#00#;
      end loop;

      main;

      loop
         null;
      end loop;
   end Reset_Handler;

   procedure Default_Handler is
   begin
      loop
         null;
      end loop;
   end Default_Handler;

   procedure NMI_Handler is null;
   procedure HardFault_Handler is null;
   procedure MemManage_Handler is null;
   procedure BusFault_Handler is null;
   procedure UsageFault_Handler is null;
   procedure SVCall_Handler is null;
   procedure DebugMonitor_Handler is null;
   procedure PendSV_Handler is null;
   procedure SysTick_Handler is null;
   procedure IRQ0_Handler is null;

end Startup;
