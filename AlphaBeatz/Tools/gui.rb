require 'tk'
require_relative 'controls'
require_relative 'config'
class MainGUI
    def initialize(*args, **kwargs)
        ct=MainCon.new(self)
        @hook=ct.hook
        @controls_=ct.hook2
        self.creating_menu_bar()
    end
    def creating_menu_bar()
        begin
            add_fileicon=TkPhotoImage.new(:file=>"Icons/add_file.gif")
            add_directoryicon=TkPhotoImage.new(:file=>"Icons/add_directory.gif")
            exiticon=TkPhotoImage.new(:file=>"Icons/exit.gif")
            playicon=TkPhotoImage.new(:file=>"Icons/play.gif")
            pauseicon=TkPhotoImage.new(:file=>"Icons/pause.gif")
            stopicon=TkPhotoImage.new(:file=>"Icons/stop.gif")
            rewindicon=TkPhotoImage.new(:file=>"Icons/rewind.gif")
            fast_forwardicon=TkPhotoImage.new(:file=>"Icons/fast_forward.gif")
            previous_trackicon=TkPhotoImage.new(:file=>"Icons/previous_track.gif")
            next_trackicon=TkPhotoImage.new(:file=>"Icons/next_track.gif")
            muteicon=TkPhotoImage.new(:file=>"Icons/mute.gif")
            unmuteicon=TkPhotoImage.new(:file=>"Icons/unmute.gif")
            delete_selectedicon=TkPhotoImage.new(:file=>"Icons/delete_selected.gif")
    
        rescue Exception => e
            puts "[ Script Detected Change or Missing Something ]"
            puts e.message
            exit(0)
        end

        menu_bar=TkMenu.new(self)    # MAIN BAR

        #   [ FILE ]  OPTIONS
        file_menu=TkMenu.new(menu_bar){             # menu_bar should be replaced with root
        tearoff 0
        }
        file_menu.add('command','label'=>"Open_file",'accelerator'=>"Ctrl+O",'compound'=>"left", 'underline'=>0, 'image'=>add_fileicon, 'command'=>self.hook.ask_for_play_song_direct) 
        file_menu.add('command','label'=>"Open_folder",'accelerator'=>"Ctrl+Shift+O",'compound'=>"left", 'underline'=>0, 'image'=>add_directoryicon, 'command'=>self.hook.ask_for_directory)
        file_menu.add('command','label'=>"Open_Disk",'accelerator'=>"Ctrl+D",'compound'=>"left", 'underline'=>0, 'image'=>add_directoryicon, 'command'=>self.hook.ask_for_directory)
        file_menu.add('separator')
        file_menu.add('command','label'=>"Quit",'accelerator'=>"Alt+F4",'compound'=>"left", 'underline'=>0, 'image'=>exiticon, 'command'=>self.destroy)

        #   [ EDIT ] OPTIONS
        edit_menu=TkMenu.new(menu_bar){             # menu_bar should be replaced with root
        tearoff 0
        }
        edit_menu.add('command','label'=>"Play",'accelerator'=>"Space",'compound'=>"left", 'underline'=>0, 'image'=>playicon, 'command'=>self.controls_.play)
        edit_menu.add('command','label'=>"Pause",'accelerator'=>"Space",'compound'=>"left", 'underline'=>0, 'image'=>pauseicon, 'command'=>self.controls_.pause)
        edit_menu.add('command','label'=>"Stop",'accelerator'=>"Ctrl+T",'compound'=>"left", 'underline'=>0, 'image'=>stopicon, 'command'=>self.controls_.stop)
        edit_menu.add('separator')
        edit_menu.add('command','label'=>"Rewind Track",'accelerator'=>"Ctrl+R",'compound'=>"left", 'underline'=>0, 'image'=>rewindicon, 'command'=>self.controls_.rewind)
        edit_menu.add('command','label'=>"Fast_Forward",'accelerator'=>"Ctrl+F",'compound'=>"left", 'underline'=>0, 'image'=>fast_forwardicon, 'command'=>self.controls_.fast)
        edit_menu.add('separator')
        edit_menu.add('command','label'=>"Previous Track",'accelerator'=>"Ctrl+P",'compound'=>"left", 'underline'=>0, 'image'=>previous_trackicon, 'command'=>self.controls_.previous)
        edit_menu.add('command','label'=>"Next Track",'accelerator'=>"Ctrl+N",'compound'=>"left", 'underline'=>0, 'image'=>next_trackicon,'command'=>self.controls_.Next)
        edit_menu.add('separator')
        edit_menu.add('command','label'=>"Mute",'accelerator'=>"Ctrl+M",'compound'=>"left", 'underline'=>0, 'image'=>muteicon, 'command'=>self.controls_.mute)
        edit_menu.add('command','label'=>"Un-mute",'accelerator'=>"Ctrl+N",'compound'=>"left", 'underline'=>0, 'image'=>unmuteicon, 'command'=>self.controls_.unmute)
        edit_menu.add('separator')
        edit_menu.add('command','label'=>"Increase Volume",'accelerator'=>"Ctrl++",'compound'=>"left", 'underline'=>0, 'image'=>add_fileicon, 'command'=>self.controls_.increase_volume)
        edit_menu.add('command','label'=>"Decrease Volume",'accelerator'=>"Ctrl+-",'compound'=>"left", 'underline'=>0, 'image'=>delete_selectedicon, 'command'=>self.controls_.decrease_volume)


        #   [ ABOUT ] OPTIONS
        about_menu=TkMenu.new(menu_bar){             # menu_bar should be replaced with root
        tearoff 0
        }
        about_menu.add('command','label'=>'Help', 'accelerator'=>'F1', 'compound'=>'left', 'underline'=>0)
        about_menu.add('separator')
        about_menu.add('command','label'=>'About', 'accelerator'=>'F2' ,'compound'=>'left', 'underline'=>0)

        #-------[ Joining menu sections with main menu ]----------------------
        menu_bar.add_cascade('label'=>'File', 'menu'=>file_menu)
        menu_bar.add_cascade('label'=>'Edit', 'menu'=>edit_menu)
        menu_bar.add_cascade('label'=>'About', 'menu'=>about_menu)

        #------[ Joining with root ]------------------------------------------
        self.config('menu'=>'menu_bar')
    end
end


if __FILE__==$0
    root=TkRoot.new
    root=MainGUI.new()
    Tk.mainloop()
end