require "tk"
require_relative "config"
class Player
    
    def initialize(root, song, time, duration)
        @root=TkFrame.new(root){
            pack(side='top')
        }
        @song=song
        @time=time
        @duration=duration
        self.create_console()
        self.auto_bind()
    end

    attr_accessor :root,:song,:time,:duration,

    def auto_bind()
        @song.trace=self.update_song_title
        @time=self.update_time
        @duration=self.update_duration
        return
    end

    def create_console()
        @back_time_label=TkPhotoImage.new(:file=>"Icons/background.gif")
        # consoleframe=Tkinter.LabelFrame(self.root, text='Display Panel', bg='aqua')
        # consoleframe.pack(side='top', expand='yes', fill='x')
        @canvas=TkCanvas.new(@root){
            width 400 
            height 100
            background 'skyblue'
            pack()
            } 
        
        #self.canvas.image=self.back_time_label
        TkcImage.new(@canvas,0, 0, 'anchor'=>"nw", 'image'=>@back_time_label)
        @time_display=TkText.new(@canvas){
            anchor "nw"
            fill 'cornsilk'
            font Digital_Clock_Font_Setting
            text '0:00:00'
            }
        @time_display.at(10, 25)
        @song_display=TkText.new(@canvas){
            anchor "nw"
            fill 'cornsilk'
            font Songs_playing_Font_Setting
            text 'Nothing For Playing'
            }
        @song_display.at(220, 40)
        @song_duration=TkText.new(@canvas){
            anchor "nw"
            fill 'cornsilk'
            font duration_time_Font_Setting
            text '0:00:00'
            }
        @song_duration.at(220, 65)
    end
    
    def song_title_filter(text)
        if File.basename(text).length>22
            name=File.basename(text)[0...20]+'...'
        else
            name=File.basename(text)
        end
        return name
    end
                    
    def update_duration(*args,**kwargs)
        raw_text=@duration
        text="[%s]" %[raw_text]
        @canvas.itemconfig(@song_duration, text=text)
    end
    
    def update_time(*args, **kwargs)
        text=@time
        @canvas.itemconfig(@time_display, text=text)
    end

    def update_song_title(*args, **kwargs)
        text=@song
        text=self.song_title_filter(text)
        self.canvas.itemconfig(@song_display, text=text)
    end
end
        
if __FILE__==$0
    root=TkRoot.new(){
        title 'Player Module'
    }
    Var=TkVariable.new()
    var1=TkVariable.new()
    entry1=TkEntry.new(root)
    entry1.textvariable=var1
    entry1.place(side='top')
    var2=TkVariable.new()
    entry2=TkEntry.new(root)
    entry2.textvariable=var2
    entry2.place(side='top')
    var3=TkVariable.new()
    entry3=TkEntry.new(root)
    entry3.textvariable=var3
    entry3.place(side='top')
    playah=Player.new(root, var1, var2, var3)
    while true
        root.update()
        root.update_idletask()
    end
end