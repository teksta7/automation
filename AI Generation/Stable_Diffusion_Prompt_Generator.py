from tkinter import *
from tkinter import ttk
from tkinter.filedialog import asksaveasfile
from english_words import get_english_words_set



class stable_diffusion_prompt_gen(object):
    import PySimpleGUI as PySGUI
    import random
    
    promptPhrases = []
    wordListMaxValue = 235970
    
    web2lowerset = get_english_words_set(['web2'], lower=True)
    PySGUI.theme('BluePurple')
    layout = [[PySGUI.Text('This tool will generate a prompt for Automatic1111 Stable Diffusion AI gen tool in JSON format that can be easily imported into that tool')],
              [PySGUI.Text('Please state what your subject is to generate prompts around')],
               [PySGUI.Text(size=(150,1), key='+OUTPUT+')], [PySGUI.Input(key='+INPUT+')],
               [PySGUI.Button('Next'), PySGUI.Button('Exit')]]
    window = PySGUI.Window("Stable Diffusion Prompt Geneartor", layout)
    
    while True:
        event, values = window.read()
        #print(event, values)
        if event == PySGUI.WIN_CLOSED or event == 'Exit':
         break
        if event == 'Next':
            window['+OUTPUT+'].update("Generating prompts for " + values['+INPUT+'] + " please wait...")
            randomWordIndex = random.randint(1, wordListMaxValue)
            web2lowersetlist = list(web2lowerset)
            randomWord = web2lowersetlist[randomWordIndex]            
    
            files = [('JSON File', '*.json')]
            generatedVideoPromptJson = asksaveasfile(filetypes = files, initialfile="GeneratedStableDiffusionImageGenPrompts.json", mode='w', defaultextension=".json")
            if generatedVideoPromptJson is None: 
                break
            length = 420
            fps = (length / 30) + 1
            initialFPS = 0
            generatedVideoPromptJson.write("{")
            for x in range(int(fps)):
                randomWordIndex = random.randint(1, wordListMaxValue)
                randomWord = web2lowersetlist[randomWordIndex]            
                if x == fps-1:
                    generatedVideoPromptJson.write("\n" + " \"" + str(initialFPS) + "\"" + ": " + "\"" + values['+INPUT+'] + ", " + "RAW photo, subject, (high detailed skin:1.2), 8k uhd, dslr, soft lighting, high quality, film grain, Fujifilm XT3, " + randomWord + "\"")
                else:
                    generatedVideoPromptJson.write("\n" + " \"" + str(initialFPS) + "\"" + ": " + "\"" + values['+INPUT+'] + ", " + "RAW photo, subject, (high detailed skin:1.2), 8k uhd, dslr, soft lighting, high quality, film grain, Fujifilm XT3, " + randomWord + "\"" + ",")
                initialFPS = initialFPS + 30
            generatedVideoPromptJson.write("\n"+ "}")
            generatedVideoPromptJson.close()
            window['+OUTPUT+'].update("Prompt file generated!")
    window.close()