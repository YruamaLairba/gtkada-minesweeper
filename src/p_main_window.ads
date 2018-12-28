with Ada.Finalization; use Ada.Finalization;
with Ada.Unchecked_Deallocation ;
with Glib; use Glib;
with Gdk.Event; use Gdk.Event;
with Gtk.Box; use Gtk.Box;
with Gtk.Button; use Gtk.Button;
with Gtk.Frame; use Gtk.Frame;
with Gtk.Enums; use Gtk.Enums;
with Gtk.Handlers ;
with Gtk.Label; use Gtk.Label;
with Gtk.Table; use Gtk.Table;
with Gtk.HButton_Box ;   use Gtk.HButton_Box ;
with Gtk.Main; use Gtk.Main;
with Gtk.Widget; use Gtk.Widget;
with Gtk.Window; use Gtk.window;
with P_Cell; use P_Cell;



package P_Main_Window is
   type T_Game is record
      Height: natural;
      Width: natural;
      Nb_Mine: natural;
   end record;

   type T_Cell_Tab is array (natural range<>,natural range<>) of T_Cell;
   type T_Cell_Tab_Access is access all T_Cell_Tab;
   procedure free is new Ada.Unchecked_Deallocation(
      T_Cell_Tab,T_Cell_Tab_Access) ;

   type T_Main_Window is new Controlled with record
      Win: Gtk_Window;
      Vbox: Gtk_Vbox;
      Hbox: Gtk_Hbox;
      Counter: Gtk_Label;
      Table: Gtk_Table;
      Cells : access T_Cell_Tab;
      Game: T_Game;
   end record;

   type T_Cell_Callback_Data is record
      Cell_Tab_Access: T_Cell_Tab_Access;
      Row : Natural;
      Col : Natural;
   end record;

   procedure Stop_Program(Emetteur : access Gtk_Widget_Record'class);

   procedure Initialize(Main_Window : in out T_Main_Window);

   procedure Finalize(Main_Window : in out T_Main_Window);

   procedure Dig_Around(
      Cells : access T_Cell_Tab;
      Row : Natural;
      Col : Natural);

   package P_Handlers is new Gtk.Handlers.Callback(Gtk_Widget_Record) ;
   use P_Handlers ;
   package P_Button_UHandlers is new Gtk.Handlers.User_Callback(
      Gtk_Button_Record,
      T_Cell) ;
   use P_Button_UHandlers ;

   package P_Button_URHandlers is new Gtk.Handlers.User_Return_Callback(
      Gtk_Button_Record,
      Boolean,
      T_Cell_Callback_Data) ;
   use P_Button_URHandlers ;

   function Cell_Clicked_Callback(
      Emetteur : access Gtk_Button_Record'class;
      Event : GDK_Event;
      Data: T_Cell_Callback_Data) return Boolean;

end P_Main_Window;
