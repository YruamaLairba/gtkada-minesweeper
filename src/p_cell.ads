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
with System.Address_Image;

package P_Cell is

   type T_Cell_State is (
      Normal, --initial state, diggable cell
      Digged, --Empty cell digged by player 
      Flagged, --Flag putted by player
      Exploded, --Mined cell digged by player
      Mine_Revealed, --To Show unexploded mine when you loose
      Rightly_Flagged, --At game end, Flag putted by player was good
      Wrongly_Flagged --At game end, Flag putted by player was bad
      );

   type T_Cell_Icons is record
      Mine: Gtk_Image; --Mine revealed when loosing
      Explode: Gtk_Image;--Cell exploding because mined and clicked
      Flag: Gtk_Image;--Flag
      Wrong_Flag: Gtk_Image;--When loosing, Misplaced Flag
   end record;

   type T_Style is (Style1,Style2);

   function Get_Mine_Filename(Style : T_Style) return String;

   function Get_Explode_Filename(Style : T_Style) return String;

   function Get_Flag_Filename(Style : T_Style) return String;

   function Get_Wrong_Flag_Filename(Style : T_Style) return String;

   type T_Cell_Record is new Controlled with record
      --Some data
      Mined: Boolean := false;
      Nb_Foreign_Mine : Natural := 0;
      State: T_Cell_State := Normal;
      Style : T_Style := Style1;
      --Gui object
      Alignment: Gtk_Alignment;
      Button: Gtk_Button;
      Image: Gtk_Image;
      Label: Gtk_Label;
   end record;

   type T_Cell is access all T_Cell_Record;

   procedure Init (Cell: not null access T_Cell_Record);

   function  New_T_Cell return T_Cell;

   procedure Destroy (Cell: not null access T_Cell_Record);

   procedure Finalize (Cell: in out T_Cell_Record);

   procedure Dig(Cell: not null access T_Cell_Record);

   procedure Loose_Reveal(Cell: not null access T_Cell_Record);

   procedure Win_Reveal(Cell: not null access T_Cell_Record);

   procedure Reset(Cell: not null access T_Cell_Record);

   procedure Flag(Cell: not null access T_Cell_Record);

   procedure Unflag(Cell: not null access T_Cell_Record);

   procedure Redraw(Cell: not null access T_Cell_Record);

   procedure free is new Ada.Unchecked_Deallocation(
      T_Cell_Record,T_Cell) ;

end P_Cell;
