with Ada.Text_IO; use Ada.Text_IO;
with Ada.Finalization; use Ada.Finalization;
with Ada.Unchecked_Deallocation ;
with Glib; use Glib;
with Gtk.Alignment; use Gtk.Alignment;
with Gtk.Button; use Gtk.Button;
with Gtk.Enums; use Gtk.Enums;
with Gtk.Image; use Gtk.Image;
with Gtk.Label; use Gtk.Label;
with Gtk.Handlers ;

package P_Cell is

   type T_Cell_State is (Normal, Digged, Flagged);

   type T_Cell_Record is new Controlled with record
      --Some data
      Mined: Boolean := false;
      Nb_Foreign_Mine : Natural := 0;
      State: T_Cell_State := Normal;
      --Gui object
      Alignment: Gtk_Alignment;
      Button: Gtk_Button;
      Image: Gtk_Image;
      Label: Gtk_Label;
   end record;

   type T_Cell is access all T_Cell_Record;

   procedure Init (Cell: not null access T_Cell_Record);

   function  New_T_Cell return T_Cell;

   procedure Finalize (Cell: not null access T_Cell_Record);

   procedure Dig(Cell: not null access T_Cell_Record);

   procedure Loose_Reveal(Cell: not null access T_Cell_Record);

   procedure Win_Reveal(Cell: not null access T_Cell_Record);

   procedure Flag(Cell: not null access T_Cell_Record);

   procedure Unflag(Cell: not null access T_Cell_Record);

   procedure free is new Ada.Unchecked_Deallocation(
      T_Cell_Record,T_Cell) ;

end P_Cell;
