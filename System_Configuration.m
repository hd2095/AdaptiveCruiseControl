classdef System_Configuration
    
    methods(Static)
        
        function arduino_obj = initialize_arduino() % initialize arduino function 
        arduino_obj = arduino('COM3','Uno','Libraries',{'Ultrasonic', 'ExampleLCD/LCDAddOn'}); % invoke in-built arduino function with necessary libraries
        end
        
        function lcd = initialize_lcd(arduino_obj)
        lcd = addon(arduino_obj,"ExampleLCD/LCDAddon",'RegisterSelectPin','D7','EnablePin','D6','DataPins',{'D5','D4','D3','D2'}); % invoke in-built addon function with necessary parameters.
        initializeLCD(lcd); % invoking in-built initializeLCD method.
        end
        
        function ultrasonicsensor = initialize_ultrasonic_sensor(arduino_obj)
        ultrasonicsensor = ultrasonic(arduino_obj,'D9','D8','OutputFormat','double'); % invoke in-built ultrasonic function with necessary parameters.
        end
        
    end
end