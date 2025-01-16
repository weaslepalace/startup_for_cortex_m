--
--  startup.ads
--

with System;
with Interfaces; use Interfaces;
with Ada.Unchecked_Conversion;

package Startup is

   type Vector_Table_Array is array (Unsigned_8 range <>) of System.Address;

   function Addr_To_U32 is
      new Ada.Unchecked_Conversion (
         Source => System.Address
         , Target => Unsigned_32
      );

   sstack : constant Unsigned_32
      with
      Import,
      Convention => Asm,
      External_Name => "_sstack";

   estack : constant Unsigned_32
      with
      Import,
      Convention => Asm,
      External_Name => "_estack";

   Stack_Size : constant Unsigned_32 := sstack - estack;
   Stack_Start : constant System.Address := sstack'Address;
   Stack_End : constant System.Address := estack'Address;

   procedure Reset_Handler
      with
      Export,
      Convention => Ada,
      External_Name => "Reset_Handler",
      No_Return;

   procedure Default_Handler
      with
      Export,
      Convention => Ada,
      External_Name => "Default_Handler",
      No_Return;

   procedure NMI_Handler;
   pragma Export (Ada, NMI_Handler, "NMI_Handler");
   pragma Weak_External (NMI_Handler);
   pragma Linker_Alias (NMI_Handler, "Default_Handler");

   procedure HardFault_Handler;
   pragma Export (Ada, HardFault_Handler, "HardFault_Handler");
   pragma Weak_External (HardFault_Handler);
   pragma Linker_Alias (HardFault_Handler, "Default_Handler");

   procedure MemManage_Handler;
   pragma Export (Ada, MemManage_Handler, "MemManage_Handler");
   pragma Weak_External (MemManage_Handler);
   pragma Linker_Alias (MemManage_Handler, "Default_Handler");

   procedure BusFault_Handler;
   pragma Export (Ada, BusFault_Handler, "BusFault_Handler");
   pragma Weak_External (BusFault_Handler);
   pragma Linker_Alias (BusFault_Handler, "Default_Handler");

   procedure UsageFault_Handler;
   pragma Export (Ada, UsageFault_Handler, "UsageFault_Handler");
   pragma Weak_External (UsageFault_Handler);
   pragma Linker_Alias (UsageFault_Handler, "Default_Handler");

   procedure SVCall_Handler;
   pragma Export (Ada, SVCall_Handler, "SVCall_Handler");
   pragma Weak_External (SVCall_Handler);
   pragma Linker_Alias (SVCall_Handler, "Default_Handler");

   procedure DebugMonitor_Handler;
   pragma Export (Ada, DebugMonitor_Handler, "DebugMonitor_Handler");
   pragma Weak_External (DebugMonitor_Handler);
   pragma Linker_Alias (DebugMonitor_Handler, "Default_Handler");

   procedure PendSV_Handler;
   pragma Export (Ada, PendSV_Handler, "PendSV_Handler");
   pragma Weak_External (PendSV_Handler);
   pragma Linker_Alias (PendSV_Handler, "Default_Handler");

   procedure SysTick_Handler;
   pragma Export (Ada, SysTick_Handler, "SysTick_Handler");
   pragma Weak_External (SysTick_Handler);
   pragma Linker_Alias (SysTick_Handler, "Default_Handler");

   procedure IRQ0_Handler;
   pragma Export (Ada, IRQ0_Handler, "IRQ0_Handler");
   pragma Weak_External (IRQ0_Handler);
   pragma Linker_Alias (IRQ0_Handler, "Default_Handler");

   procedure main
      with
      Import,
      Convention => Ada,
      External_Name => "main";

   Reserved_Address : constant System.Address :=
      System'To_Address (16#0000_0000#);

   Vector_Table : Vector_Table_Array := (
      Stack_Start
      , Reset_Handler'Address
      , NMI_Handler'Address
      , HardFault_Handler'Address
      , MemManage_Handler'Address
      , BusFault_Handler'Address
      , UsageFault_Handler'Address
      , Reserved_Address
      , Reserved_Address
      , Reserved_Address
      , Reserved_Address
      , SVCall_Handler'Address
      , DebugMonitor_Handler'Address
      , Reserved_Address
      , PendSV_Handler'Address
      , SysTick_Handler'Address
      , IRQ0_Handler'Address
   );
   pragma Linker_Section (Vector_Table, ".vector_table");

end Startup;
