require "tk"
require_relative "config"
class ListPanel
    attr_accessor :playing,:root,:var1,:directory,
    def initialize(root, playing)
        @playing=playing            # Playing Song Directory
        @root=TkFrame.new(root){
            background 'skyblue'
            pack(side='top')
        }
        @var1=TkVariable.new()       # For Search Songs
        @directory=TkVariable.new()  # For Directory
        @directory='.'
        self.create_song_list_panel()
    end
       
    def create_song_list_panel()
        # Creating Picture Canvas as Background
        background=TkPhotoImage.new(:file=>"../Icons/background.gif")
        mainframe=TkCanvas.new(@root)
        mainframe.pack(side='top', expand='yes', fill='both')
        mainframe.image=background
        TkcImage.new(mainframe,0, 0, anchor="nw", image=background)
        
        frame0=TkFrame.new(mainframe)
        frame0.pack(side='top')
        TkLabel.new(frame0){
            text 'Search : '
            bg 'skyblue'
            pack(side='left', expand='yes', fill='x')
        } 
        entry=TkEntry.new(frame0)
        entry.textvariable=@var1
        entry.pack(side='left', expand='yes', fill='x')
        frame0.bind_all('<Any-KeyPress>',self.search_song_trigger)
        frame=TkFrame.new(mainframe) {
            background 'skyblue'
            pack(side='top')
        }
        @list_box=TkListbox.new(frame){ 
            background 'powderblue' 
            font list_box_song_list_font
            width list_box_width 
            height list_box_height
        }
        scrollbar=TkScrollbar.new(frame){ 
            background 'skyblue'
            pack(side='right',expand='yes',fill='y')
        }
        scrollbar.config(command=self.list_box.yview)
        @list_box.config(yscrollcommand=scrollbar.set)
        @list_box.pack(expand='yes',fill='both',side='right')
        frame1=TkFrame.new(mainframe){ 
            background 'blue'
            pack(side='top', expand='yes',fill='x')
        }
        add_fileicon=TkPhotoImage.new(:file=>"Icons/add_file.gif")
        add_directoryicon=TkPhotoImage.new(:file=>"Icons/add_directory.gif")
        list_file={
        add_fileicon: 'self.ask_for_play_song_direct',
        add_directoryicon: 'self.ask_for_directory',
        }
        list_file.each{
                storeobj=TkButton.new(frame1){
                        image i
                        command eval(j)
                        background 'blue'
                        pack(side='left')
                    } 
            }
        @list_box.bind('<Double-Button-1>',self.play_on_click)
        self.update_list_box_songs()
    end
        

    def search_song_trigger(event=None)
            string=@var1
            list_dir=Dir.new(@directory)
            self.list_box.delete('0','end')
            for i in list_dir do
                    if string == i
                        self.list_box.insert(0, i) unless (i.reverse)[0]=='~'
                    end
                end
    end
                       
    def play_on_click(event=None)
            store=@list_box.selection_get()
            if @directory=='.'
                    path=File.join(Dir.pwd(),store)
                    @playing=path
                    puts '[+] Song Variable Update Path : #{path}'
                    return 
            else
                    path=File.join(@directory,store)
                    @playing=path
                    puts '[+] Song Variable Update Path : #{path}'
                    return
            end
    end 
        

    def update_list_box_songs(dirs='.')
            files=Dir.new(dirs)
            files.reverse!
            @list_box.delete('0','end')
            for i in files do
                    if string == i
                        self.list_box.insert(0, i) unless (i.reverse)[0]=='~'
                    end
            end
    end
        
    def ask_for_play_song_direct()
            path=Tk.getOpenFile(title='Play Selected Song')
            if path
                    @playing=path
                    puts '[+] Song Variable Update Path : #{path}'
            end
    end       

                    
    def ask_for_directory()
            path=Tk.chooseDirectory(title='Select Directory For Playlist')
            if path
                    @directory=path
                    print (path)
                    self.update_list_box_songs(dirs=path)
            end
    end
    
    
class Main
    def init(root, var1)
        @playing=var1
        @root=TkFrame.new(root)
        @root.pack()
        @anchorvar=TkVariable.new()
        @anchorvar=1
        @anchor_button=TkButton.new(@root){
            text='[ Close ]' 
            command self.check_drawer 
            background 'skyblue'
            activebackground 'powderblue'
            pack(side='top',expand='yes',fill='x')
        } 
        @mainframe=TkFrame.new(@root)
        @mainframe.pack()
        obj=ListPanel(@mainframe, @playing)
        @hook=obj
    end

    def open_drawer()
        if @anchorvar==1
            @anchorvar=0
            @mainframe.pack_forget()
            @anchor_button.config(text=' [ Open ]')
        end
    end

    def close_drawer()
        if @anchorvar==0
            @anchorvar=1
            @mainframe.pack(side='top',expand='yes',fill='both')
            @anchor_button.config(text=' [ Close ]') 
        end
    end

    def check_drawer()
        if @anchorvar==1
            @anchorvar=0
            @mainframe.pack_forget()
            @anchor_button.config(text=' [ Open ]')
        else
            @anchorvar=1
            @mainframe.pack(side='top',expand='yes',fill='both')
            @anchor_button.config(text=' [ Close ]')
        end
    end        
end

if __FILE__==$0
    root=TkRoot.new
    playing=TkVariable.new()
    var1=TkVariable.new() # For Playing Song
    entry=TkEntry.new(root){
        textvariable var1
        pack(side='top')
    }   
    main.new(root,var1)
    Tk.mainloop()
end