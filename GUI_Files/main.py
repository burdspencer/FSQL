import customtkinter as ctk
import time as t
ctk.set_appearance_mode("System")
ctk.set_default_color_theme("blue")

app = ctk.CTk()
app.geometry("1920x1080")

class App(ctk.CTk):
    def __init__(self):
        super().__init__()

        #configure window data
        self.title("Burdgorithm GUI v0.1")
        self.geometry(f"{1920}x{1080}")

        #configure grid
        self.grid_columnconfigure(1, weight=1)
        self.grid_columnconfigure((2,3), weight=0)
        self.rowconfigure((0,1,2),weight=1)


        #nav sidebar
        self.sidebar_frame = ctk.CTkFrame(self, width = 140,corner_radius=0)
        self.sidebar_frame.grid 

def button_function():
    print(t.localtime())



#Use CTkButton instead of tkinter Button
button = ctk.CTkButton(master=app,text="CTkButton", command=button_function)
button.place(relx=0.1,rely=0.1,anchor=ctk.CENTER)

if __name__ == "__main__":
    app = App()
    app.mainloop()
