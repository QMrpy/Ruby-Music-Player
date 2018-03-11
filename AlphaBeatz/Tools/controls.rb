require 'tk'
class Controls
    attr_accessor :root,:status,:playervolume,:playing,:player,:songtime,:volume_label
    def initialize(root, playing, player, volume)
        @playervolume=volume
        @root=TkFrame.new
        @root.pack()
        @status=TkVariable.new() # For Song Status
        @playing=playing
        @player=player
        @var=TkVariable.new # For Volume Bar
        @var=1.0
        @songtime=TkVariable.new()
        self.create_control_panel()
    end
        #self.time_thread()
        #print self.player.playing

    def time_thread()
        Thread.new{ self.update_time_}
    end
    
        
    def update_time_()
        while true
            sleep(2)
            if self.player.player.playing
                
            else
                begin
                    puts 'Playing Next Music'
                    self.Next()
                rescue    

                else
                    puts 'Playing Next Music- Error'
                end
            end
        end
    end
                
                
    def create_control_panel()
        
        frame=TkFrame.new(){
            pack('expand'=>'yes','fill'=>'x','side'=>'top')
        }
        
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
        @muteicon=TkPhotoImage.new(:file=>"Icons/mute.gif")
        @unmuteicon=TkPhotoImage.new(:file=>"Icons/unmute.gif")
        delete_selectedicon=TkPhotoImage.new(:file=>"Icons/delete_selected.gif")

        list_file={
            playicon: 'self.play',
            pauseicon:'self.pause',
            stopicon:'self.stop',
            previous_trackicon: 'self.previous',
            rewindicon: 'self.rewind',
            fast_forwardicon: 'self.fast',
            next_trackicon: 'self.Next',
        }
        list_file.each{
            |i,j|
            storeobj=TkButton.new(frame){
                image  i.to_s
                command j
                pack('side'=>'left')
            }
        }

        @volume_label=TkButton.new(frame){
            image self.unmuteicon
            pack('side'=>'right')
        }
                
        volume=TkScale.new(frame){
        from Volume_lowest_value
        to Volume_highest_value 
        variable self.var 
        command self.update_volume
        pack('side'=>'right', 'padx'=>10, )
        }
    end

    
    def update_volume(event=None)
        if Volume_lowest_value==@var
            @volume_label.config('state'=>'active')
            @volume_label.config('image'=>self.muteicon)
            @playervolume.set(0.0)
            @volume_label.config('state'=>'disabled')
        else
            @volume_label.config('state'=>'active')
            @volume_label.config('image'=>self.unmuteicon)
            @playervolume.set(self.volume_equalize())
            @volume_label.config('state'=>'disabled')
        end
    end
    
    def volume_equalize()
        str=String.new
        str=@var.to_s
        if str.length==1
            val='0.{}'.format(str[0])
        elsif @var.to_s.length==2
            val='{}.{}'.format(str[0],str[1])
        else
            val=@var
        end
        return float(val)
    end
    
    def mute
        @var=0
        self.update_volume()
    end

    def unmute()
        @var=11
        self.update_volume()
    end

    def increase_volume()
        high=Volume_highest_value+5
        @var+=5 if @var < high
        self.update_volume()
    end

    def decrease_volume()
        low=6
        @var-=5 if @var > low
        self.update_volume()
    end
            
    def play()
        if self.status.get()==0
            k=self.player.play_song()
            self.status.set(1)
            return k
        elsif self.status.get()==1
            k=self.player.play()
            self.status.set(0)
            return k
        else
            puts 'something wrong on controls.Controls.play'
            puts 'or playing variable is empty'
            return 'Nothing'
        end
    end
    
    def pause()
        if self.status.get()==0 || self.status.get()==1
            self.player.pause()
        end
        return
    end
        
    def stop()
        self.player.stop()
        return
    end
    
    def previous()
        begin
            dirbase=Dir.new(@playing)
            dirt=Dir.entries(dirbase)
            base=File.basename(@playing)
            k=dirt.index(base)-1
            path=File.join(dirbase, dirt[k])
            puts path
            self.playing.set(path)
        rescue

        end
    end

    def fast()
        self.player.fast_forward()
    end
    
    def Next()
        begin
            dirbase=Dir.new(@playing)
            dirt=Dir.entries(dirbase)
            base=File.basename(@playing)
            k=dirt.index(base)+1
            path=File.join(dirbase, dirt[k])
            puts path
            self.playing.set(path)
        rescue

        end
    end

    def rewind()
        self.player.rewind
    end
end
        
class Main
    def initialize(root)
        @root=TkFrame.new(root){
            pack('side'=>'top')
        }
        
        @path=TkVariable.new()          # For Song Path
        @song_time=TkVariable.new()     # For Song Playing Time
        @song_duration=TkVariable.new()  # For Song Duration
        @volume=TkVariable.new()           # For Song Volume

        # ============= Creating Media Player       ======================================================
        mediaplayer=player.mediaplayer(self.path, self.song_time, self.song_duration, self.volume)

        # ============= Creating Display Panel      ======================================================
        DisplayPanel.Player(self.root, self.path, self.song_time, self.song_duration)

        # ============= Creating Control Panel      ======================================================
        lit2=Controls(self.root, self.path, mediaplayer, self.volume)
        self.hook2=lit2
        # ============= Here Connecting List Panel  ======================================================
        lit=ListPanel.main(self.root, self.path)
        self.hook=lit.hook
    end
end
        
        
if __FILE__==$0
    root=TkRoot.new()
    Main.new(root)
    Tk.mainloop()
end
