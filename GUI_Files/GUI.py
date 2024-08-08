import pandas
import pandas as pd
import pyarrow.feather as f
import tkinter as tk
import customtkinter as ctk
from functools import partial
import sys
import RetrieveData as rd

# runtime params

ui = 0  # 1 for yes, 0 for no


ctk.set_appearance_mode("System")  # enum: System, Dark, Light
ctk.set_default_color_theme("blue")  # enum: blue, green, dark-blue


class App(ctk.CTk):
    frames = {}
    current = None
    bg = ""

    def __init__(self):
        super().__init__()

        self.num_of_frames = 0
        self.bg = self.cget("fg_color")

        # configure window
        self.title("Burdgorithm v0.1")
        self.geometry(f"{1100}x{580}")

        # root!
        main_container = ctk.CTkFrame(self, corner_radius=8, fg_color=self.bg)
        main_container.pack(fill=ctk.BOTH, expand=True, padx=8, pady=8)

        # left side panel -> for frame selection
        self.left_side_panel = ctk.CTkFrame(
            main_container, width=280, corner_radius=8, fg_color=self.bg
        )
        self.left_side_panel.pack(
            side=ctk.LEFT, fill=ctk.Y, expand=False, padx=18, pady=10
        )

        # right side panel -> to show the frame1 or frame 2, or ... frame + n where n <= 5
        self.right_side_panel = ctk.CTkFrame(
            main_container, corner_radius=18, fg_color="#212121"
        )
        self.right_side_panel.pack(
            side=ctk.LEFT, fill=ctk.BOTH, expand=True, padx=0, pady=0
        )
        self.right_side_panel.configure(border_width=1)
        self.right_side_panel.configure(border_color="#323232")
        self.create_nav(
            self.left_side_panel, frame_id="frame1", frame_color="#212121", label="NFL"
        )
        self.create_nav(
            self.left_side_panel, frame_id="frame2", frame_color="#212121", label="MLB"
        )
        self.create_nav(
            self.left_side_panel, frame_id="frame3", frame_color="#212121", label="NHL"
        )
        self.create_nav(
            self.left_side_panel,
            frame_id="frame4",
            frame_color="#212121",
            label="Console",
        )
        self.create_nav(
            self.left_side_panel,
            frame_id="frame5",
            frame_color="#212121",
            label="Settings",
        )

    def toggle_frame_by_id(self, frame_id):
        if App.frames[frame_id] is not None:
            if App.current is App.frames[frame_id]:
                App.current.pack_forget()
                App.current = None
            elif App.current is not None:
                App.current.pack_forget()
                App.current = App.frames[frame_id]
                App.current.pack(
                    in_=self.right_side_panel,
                    side=ctk.TOP,
                    fill=ctk.BOTH,
                    expand=True,
                    padx=0,
                    pady=0,
                )
            else:
                App.current = App.frames[frame_id]
                App.current.pack(
                    in_=self.right_side_panel,
                    side=ctk.TOP,
                    fill=ctk.BOTH,
                    expand=True,
                    padx=0,
                    pady=0,
                )

    # method to create a pair button selector and its related frame
    def create_nav(self, parent, frame_id, frame_color, label):
        self.frame_selector_bt(parent, frame_id, label)
        self.create_frame(frame_id, frame_color)

    def frame_selector_bt(self, parent, frame_id, label):
        # create frame
        bt_frame = ctk.CTkButton(parent)
        # style frame
        bt_frame.configure(height=40)
        # creates a text label
        bt_frame.configure(text=label)
        bt_frame.configure(
            command=partial(
                self.toggle_frame_by_id, "frame" + str(self.num_of_frames + 1)
            )
        )
        # set layout
        bt_frame.grid(pady=34, row=self.num_of_frames, column=0)
        # update state
        self.num_of_frames = self.num_of_frames + 1

    # create the frame
    def create_frame(self, frame_id, color):
        App.frames[frame_id] = ctk.CTkFrame(self, fg_color=self.cget("fg_color"))
        App.frames[frame_id].configure(corner_radius=8)
        App.frames[frame_id].configure(fg_color=color)
        App.frames[frame_id].configure(border_width=2)
        App.frames[frame_id].configure(border_color="#323232")
        App.frames[frame_id].padx = 8

        bt_from_frame1 = ctk.CTkButton(
            App.frames[frame_id],
            text="Test " + frame_id,
            command=lambda: print("test " + frame_id),
        )
        bt_from_frame1.place(relx=0.5, rely=0.5, anchor=ctk.CENTER)

        if frame_id == "frame4":  # Console
            bt_from_frame1.pack(pady=1, anchor="sw")
            console = tk.Text(App.frames[frame_id], wrap="word")
            console.tag_configure("stderr", foreground="#b22222")
            console.pack(side="top", fill="both", expand=True)
            # redirect stdout and stderr to our text box
            sys.stdout = TextRedirector(console, "stdout")
            sys.stderr = TextRedirector(console, "stderr")


class TextRedirector(object):
    def __init__(self, widget, tag="stdout"):
        self.widget = widget
        self.tag = tag

    def write(self, string):
        self.widget.configure(state="normal")
        self.widget.insert("end", string, (self.tag,))
        self.widget.configure(state="disabled")
        self.widget.see(tk.END)
