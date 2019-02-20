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

   procedure Draw_Nb_Foreign_Mine (
      Cell: not null access T_Cell_Record) is
   begin
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
   end Draw_Nb_Foreign_Mine;

   function Set_Text (N: Integer) return String is
   begin
      case N is
         when 1 => return "1";
         when 2 => return "2";
         when 3 => return "3";
         when 4 => return "4";
         when 5 => return "5";
         when 6 => return "6";
         when 7 => return "7";
         when 8 => return "8";
         when others => return "";
      end case;
   end Set_Text;
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
      Cell.Alignment.Destroy;
      Cell.Alignment := null;
   end Destroy;

   procedure Finalize (Cell: in out T_Cell_Record) is
   begin
      null;
   end;

   procedure Dig(Cell : not null access T_Cell_Record) is
   begin
      if Cell.State = normal then
         Cell.Button.Destroy;
         Cell.Button := null;
         if Cell.Mined then
            Cell.State := Exploded;
            Cell.Image := Gtk_Image_New_From_File(
               Get_Explode_Filename(Cell.Style));
            Cell.Alignment.Add(Cell.Image);
         else
            Cell.State := Digged;
            Cell.Label := Gtk_Label_New;
            Cell.Label.Set_Markup(Set_Text(Cell.Nb_Foreign_Mine));
            Cell.Alignment.Add(Cell.Label);
         end if;
         Cell.Alignment.Show_All;
      end if;
   end Dig;

   procedure Loose_Reveal(Cell : not null access T_Cell_Record) is
   begin
      case Cell.State is
         when Normal =>
            if Cell.Mined then
               Cell.State:= Mine_Revealed;
               Cell.Button.Destroy;
               Cell.Button := null;
               Cell.Image := Gtk_Image_New_From_File(
                  Get_Mine_Filename(Cell.Style));
               Cell.Alignment.Add(Cell.Image);
               Cell.Alignment.Show_All;
            end if;
         when Flagged =>
            if Cell.Mined then
               Cell.State := Rightly_Flagged;
            else
               Cell.State := Wrongly_Flagged;
               Cell.Image.Set(Get_Wrong_Flag_Filename(Cell.Style));
               Cell.Button.Add(Cell.Image);
               Cell.Button.Show_All;
            end if;
         when others =>
            null;
      end case;
   end Loose_Reveal;

   procedure Win_Reveal(Cell : not null access T_Cell_Record) is
   begin
      case Cell.State is
         when Normal|Flagged =>
            if Cell.Mined then
               Cell.State := Rightly_Flagged;
               Cell.Image.Set(Get_Flag_Filename(Cell.Style));
               Cell.Button.Add(Cell.Image);
               Cell.Button.Show_All;
            end if;
         when others =>
            null;
      end case;
   end Win_Reveal;

   procedure Flag(Cell: not null access T_Cell_Record) is
   begin
      if Cell.State = Normal then
         Cell.State := Flagged;
         Gtk_New(Cell.Image,Get_Flag_Filename(Cell.Style));
         Cell.Button.Add(Cell.Image);
         Cell.Button.Show_All;
      end if;
   end Flag;

   procedure Unflag(Cell: not null access T_Cell_Record) is
   begin
      if Cell.State = Flagged then
         Cell.State := Normal;
         Cell.Image.Destroy;
         Cell.Image := null;
      end if;
   end Unflag;

   procedure Redraw(Cell: not null access T_Cell_Record) is
   begin
      case Cell.State is
         when Normal => null;
         when Digged =>
            Cell.Label.Set_Markup(Set_Text(Cell.Nb_Foreign_Mine));
         when Flagged | Rightly_Flagged =>
            Cell.Image.Set(Get_Flag_Filename(Cell.Style));
         when Exploded =>
            Cell.Image.Set( Get_Explode_Filename(Cell.Style));
         when Mine_Revealed =>
            Cell.Image.Set(Get_Mine_Filename(Cell.Style));
         when Wrongly_Flagged =>
            Cell.Image.Set(Get_Wrong_Flag_Filename(Cell.Style));
      end case;
   end Redraw;
end P_Cell;
