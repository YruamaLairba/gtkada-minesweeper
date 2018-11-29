with Ada.Finalization; use Ada.Finalization;
with Gtk.Enums; use Gtk.Enums;
with Gtk.Handlers ;
with Gtk.Main; use Gtk.Main;
with Gtk.Widget; use Gtk.Widget;
with Gtk.Window; use Gtk.window;
with P_Cell; use P_Cell;


package P_Main_Window is
   type T_Main_Window is new Controlled with record
      Win: Gtk_Window;
      Cell: T_Cell;
   end record;

   procedure Stop_Program(Emetteur : access Gtk_Widget_Record'class);

   procedure Initialize(Main_Window : in out T_Main_Window);

   package P_Handlers is new Gtk.Handlers.Callback(Gtk_Widget_Record) ;
   use P_Handlers ;

end P_Main_Window;
