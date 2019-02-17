package body P_Cell is

   function Get_Mine_Filename(Style : T_Style) return String is
   begin
      case Style is
         when Style1 => return "share/icons/mine-noire.png";
         when Style2 => return "share/icons/style2/mine.png";
      end case;
   end Get_Mine_Filename;

   function Get_Explode_Filename(Style : T_Style) return String is
   begin
      case Style is
         when Style1 => return "share/icons/mine-rouge.png";
         when Style2 => return "share/icons/style2/explode.png";
      end case;
   end Get_Explode_Filename;

   function Get_Flag_Filename(Style : T_Style) return String is
   begin
      case Style is
         when Style1 => return "share/icons/drapeau-bleu.png";
         when Style2 => return "share/icons/style2/flag.png";
      end case;
   end Get_Flag_Filename;

   function Get_Wrong_Flag_Filename(Style : T_Style) return String is
   begin
      case Style is
         when Style1 => return "share/icons/drapeau-bleu-barre.png";
         when Style2 => return "share/icons/style2/wrong-flag.png";
      end case;
   end Get_Wrong_Flag_Filename;

   procedure Init (Cell: not null access T_Cell_Record) is
   begin
      Gtk_New(Cell.Alignment,0.5,0.5,1.0,1.0);
      Gtk_New(Cell.Button);
      Cell.Alignment.Add(Cell.Button);
   end Init;

   function  New_T_Cell return T_Cell is
      Cell : T_Cell := new T_Cell_Record;
   begin
      Cell.Init;
      return Cell;
   end;

   procedure Destroy (Cell: not null access T_Cell_Record) is
   begin
      Cell.Button.Destroy;
      Cell.Alignment.Destroy;
   end Destroy;

   procedure Finalize (Cell: in out T_Cell_Record) is
   begin
      null;
   end;

   procedure Dig(Cell : not null access T_Cell_Record) is
   begin
      if Cell.State = normal then
         Cell.State := Digged;
         Cell.Button.Set_Relief(Relief_None);
         Cell.Button.Set_Sensitive(false);
         if Cell.Mined then
            Cell.Button.Set_Image(
               Gtk_Image_New_From_File(Get_Explode_Filename(Cell.Style)));
         else
            case Cell.Nb_Foreign_Mine is
               when 0 => Cell.Button.Set_Label("");
               when 1 => Cell.Button.Set_Label("1");
               when 2 => Cell.Button.Set_Label("2");
               when 3 => Cell.Button.Set_Label("3");
               when 4 => Cell.Button.Set_Label("4");
               when 5 => Cell.Button.Set_Label("5");
               when 6 => Cell.Button.Set_Label("6");
               when 7 => Cell.Button.Set_Label("7");
               when 8 => Cell.Button.Set_Label("8");
               when others => null;
            end case;
         end if;
      end if;
   end Dig;

   procedure Loose_Reveal(Cell : not null access T_Cell_Record) is
   begin
      Cell.Button.Set_Sensitive(false);
      case Cell.State is
         when Normal =>
            if Cell.Mined then
               Cell.Button.Set_Relief(Relief_None);
               Cell.Button.Set_Image(
                  Gtk_Image_New_From_File(Get_Mine_Filename(Cell.Style)));
            end if;
         when Flagged =>
            if not Cell.Mined then
               Cell.Button.Set_Image(
                  Gtk_Image_New_From_File(
                     Get_Wrong_Flag_Filename(Cell.Style)));
            end if;
         when others =>
            null;
      end case;
   end Loose_Reveal;

   procedure Win_Reveal(Cell : not null access T_Cell_Record) is
   begin
      Cell.Button.Set_Sensitive(false);
      case Cell.State is
         when Normal =>
            if Cell.Mined then
               Cell.Button.Set_Image(
                  Gtk_Image_New_From_File(Get_Flag_Filename(Cell.Style)));
            end if;
         when others =>
            null;
      end case;
   end Win_Reveal;

   procedure Reset(Cell: not null access T_Cell_Record) is
   begin
      Cell.Mined := false;
      Cell.Nb_Foreign_Mine := 0;
      Cell.State := Normal;
      Cell.Button.Set_Image( Gtk_Image_New);
      Cell.Button.Set_Label("");
      Cell.Button.Set_Sensitive(true);
      Cell.Button.Set_Relief(Relief_Normal);
   end Reset;


   procedure Flag(Cell: not null access T_Cell_Record) is
   begin
      if Cell.State = Normal then
         Cell.State := Flagged;
         Cell.Button.Set_Image(
            Gtk_Image_New_From_File(Get_Flag_Filename(Cell.Style)));
      end if;
   end Flag;

   procedure Unflag(Cell: not null access T_Cell_Record) is
   begin
      if Cell.State = Flagged then
         Cell.State := Normal;
         Cell.Button.Set_Image( Gtk_Image_New);
      end if;
   end Unflag;

   procedure Redraw(Cell: not null access T_Cell_Record) is
   begin
      case Cell.State is
         when Normal => null;
         when Digged =>
            Cell.Button.Set_Relief(Relief_None);
            Cell.Button.Set_Sensitive(false);
            if Cell.Mined then
               Cell.Button.Set_Image(
                  Gtk_Image_New_From_File(Get_Explode_Filename(Cell.Style)));
            else
               case Cell.Nb_Foreign_Mine is
                  when 0 => Cell.Button.Set_Label("");
                  when 1 => Cell.Button.Set_Label("1");
                  when 2 => Cell.Button.Set_Label("2");
                  when 3 => Cell.Button.Set_Label("3");
                  when 4 => Cell.Button.Set_Label("4");
                  when 5 => Cell.Button.Set_Label("5");
                  when 6 => Cell.Button.Set_Label("6");
                  when 7 => Cell.Button.Set_Label("7");
                  when 8 => Cell.Button.Set_Label("8");
                  when others => null;
               end case;
            end if;
         when Flagged =>
            Cell.Button.Set_Image(
               Gtk_Image_New_From_File(Get_Flag_Filename(Cell.Style)));
      end case;
   end Redraw;
end P_Cell;
