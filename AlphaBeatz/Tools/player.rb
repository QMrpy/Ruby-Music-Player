require "tk"
require "gosu"
require_relative "config"
class Mediaplayer
	attr_accessor :path,:songtime,:songduration,:volume,
    def initialize(path, song_time,song_duration,volume)
        @path=path                      # Song Playing Song
        @volume=volume                  # Song Volume Update
        @songtime=song_time             # Song Time Variable
        @songduration=song_duration     # Song Duration
        @player=Gosu::Song.new()          # pyglet Media Player
        @player.volume=1.5              # 
        self.time_thread()                  # Time Updating Thread

        self.play_song(@path)
        self.volume_(@volume)
    end
        
    def jump(time)
        begin
            @player.seek(time)
            return 
        rescue
            puts '[+] Jump is Not Possible'
            return
        end
    end
        
        
    def now()
        storeobj=self.player.time
    end

    
    def now_()
        time=int(self.now())
        k=Time.new()
        k.sec=time
      	k.to_s
    end

        
    def pause()
        self.player.pause()    
    end

    def play()
        self.player.play()
    end
    
    def stop()
        self.reset_player()
    end
    
    def volume_()
        begin
            self.player.volume=@volume
        rescue
        
        end
    end

    
    def time_thread()
        Thread.new{ self.update_time_}
    end
    
        
    def update_time_()
        while true
            now=self.now_()
            begin
                self.songtime.set(now)
            rescue Exception => e
                print e.message
            end
        end
    end
        
    
    def duration()
        begin
            storeobj=self.player.source.duration
            return storeobj
        rescue
            return '0'
        end
    end

    def duration_()
        time=self.duration()+10.0
        k=Time.new
        k.sec=time
        k.to_s()
    end

    
    def reset_player()
        self.player.pause()
    end
            
            
    
    def play_song(*args, **kwargs)
        if self.path.get()
            begin
                self.reset_player()
                begin
                    @player.new(@path)
                    self.play()
                    
                    self.songduration.set(self.duration_())   # Updating duration Time
                    
                rescue Exception => e
                    puts "[+] Something wrong when playing song"+ e.message
                    return 
                end
            rescue Exception => e
                puts ' [+] Please Check Your File Path'  + self.path.get()
                puts ' [+] Error: Problem On Playing '+ e.message
                return 
            end
        else
            puts ' [+] Please Check Your File Path'  + self.path.get()
        end
    end

    def fast_forward()
        time = self.player.time + jump_distance
        begin
            if self.duration() > time
                self.player.seek(time)
            else
                self.player.seek(self.duration())
            end
        rescue 
        	
        end
    end

    def rewind()
        time = self.player.time - jump_distance
        begin
            self.player.seek(time)
        rescue
            self.player.seek(0)
        end
    end
end
