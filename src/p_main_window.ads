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
   type T_Game_Record is record
      Height: natural;
      Width: natural;
      Nb_Mine: natural;
   end record;

   type T_Game is access all T_Game_Record;

   type T_Cell_Tab is array (natural range<>,natural range<>) of T_Cell;
   type T_Cell_Tab_Access is access all T_Cell_Tab;
   procedure free is new Ada.Unchecked_Deallocation(
      T_Cell_Tab,T_Cell_Tab_Access) ;

   type T_Main_Window_Record is new Controlled with record
      Win: Gtk_Window;
      Vbox: Gtk_Vbox;
      Hbox: Gtk_Hbox;
      Counter: Gtk_Label;
      Table: Gtk_Table;
      Cells : access T_Cell_Tab;
      Game: T_Game;
   end record;

   type T_Main_Window is access all T_Main_Window_Record;

   type T_Cell_Callback_Data is record
      Main_Window: T_Main_Window;
      Row : Natural;
      Col : Natural;
   end record;


   procedure Stop_Program(Emetteur : access Gtk_Widget_Record'class);

   procedure Initialize(
      Main_Window : in out T_Main_Window_Record;
      Game: T_Game);

   procedure Init_Main_Window(
      Main_Window: in out T_Main_Window;
      Game: T_Game);

   procedure Finalize(Main_Window : in out T_Main_Window_Record);

   procedure Set_Nb_Mine(
      Main_Window: in out T_Main_Window_Record;
      Nb_Mine : Natural);

   procedure Place_Mine(
      Main_Window: in out T_Main_Window_Record;
      row: Natural;
      col: Natural);

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

   procedure free is new Ada.Unchecked_Deallocation(
      T_Main_Window_Record,T_Main_Window) ;

   procedure free is new Ada.Unchecked_Deallocation(
      T_Game_Record,T_Game) ;

end P_Main_Window;
