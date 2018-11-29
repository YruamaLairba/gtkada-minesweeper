with Ada.Finalization; use Ada.Finalization;
with Glib; use Glib;
with Gtk.Button; use Gtk.Button;
with Gtk.Enums; use Gtk.Enums;
with Gtk.Handlers ;

package P_Cell is

   type T_Cell_State is (Normal, Digged, Flagged);

   type T_Cell is new Controlled with record
      Button: Gtk_Button;
      Mined: Boolean := false;
      State: T_Cell_State := Normal;
   end record;

   procedure Initialize (Cell: in out T_Cell);

end P_Cell;
