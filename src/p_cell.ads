with Ada.Text_IO; use Ada.Text_IO;
with Ada.Finalization; use Ada.Finalization;
with Glib; use Glib;
with Gtk.Button; use Gtk.Button;
with Gtk.Enums; use Gtk.Enums;
with Gtk.Image; use Gtk.Image;
with Gtk.Handlers ;

package P_Cell is

   type T_Cell_State is (Normal, Digged, Flagged);

   type T_Cell is new Controlled with record
      Button: Gtk_Button;
      Mined: Boolean := false;
      Nb_Foreign_Mine : Natural := 0;
      State: T_Cell_State := Normal;
      Image: Gtk_Image;
   end record;

   type T_Cell_Access is access all T_Cell;

   procedure Initialize (Cell: in out T_Cell);

   procedure Clicked_Callback(
      Emetteur : access Gtk_Button_Record'class;
      Cell: T_Cell);

end P_Cell;
