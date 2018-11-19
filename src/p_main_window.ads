with Ada.Finalization; use Ada.Finalization;
with Gtk.Window; use Gtk.window;
with Gtk.Enums; use Gtk.Enums;


package P_Main_Window is
   type T_Main_Window is new Controlled with record
      Win: Gtk_Window;
   end record;

   procedure Initialize(Main_Window : in out T_Main_Window);

end P_Main_Window;
