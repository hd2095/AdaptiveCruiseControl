clear all; % Clear all objects and variables.
clc; % Clear screen.

global arduino_object; % Global arduino object.
global lcd; % Global lcd object.
global ultrasonicsensor; % Global ultrasonic sensor.

arduino_object = System_Configuration.initialize_arduino(); % Create Arduino object to allow communication between matlab and arduino.

lcd = System_Configuration.initialize_lcd(arduino_object); % Create LCD object to print speed and mode.

ultrasonicsensor = System_Configuration.initialize_ultrasonic_sensor(arduino_object);  % Create Ultrasonic sensor object to read distance between car and obstacles.

car_controller_obj = Car_Controller.intialize_car_controller(); % Initialize Car speed to 0.

while(inf) % infinite loop to read all buttons pressed by user.
    
    increase_button_pressed = readVoltage(arduino_object,'A0'); % Read increase button
    
    decrement_button_pressed = readVoltage(arduino_object,'A1'); % Read decrease button
    
    set_speed_button_pressed = readVoltage(arduino_object,'A2'); % Read set speed button
    
    adaptive_control_button_pressed = readVoltage(arduino_object,'A3'); % Read adaptive control button
    
    stop_button_pressed = readVoltage(arduino_object,'A4'); % Read stop button
    
    distance = readDistance(ultrasonicsensor); % Read ultrasonic sensor
    
    if ~strcmp(car_controller_obj.mode, string(Mode.Adaptive)) % Check if mode is adaptive
        
        car_controller_obj = Car_Controller.change_speed_in_adaptive(car_controller_obj); % set change speed flag to true
        
    end
    
    if(increase_button_pressed < 3.8 && ~strcmp(car_controller_obj.mode, string(Mode.Adaptive))) % Check if increase button is pressed
        
        disp('increase button pressed..'); % printing increase button pressed.
        
        car_controller_obj = Car_Controller.speed_up(car_controller_obj); % Increase Speed
        
    elseif(decrement_button_pressed < 3.8 && ~strcmp(car_controller_obj.mode, string(Mode.Adaptive))) % Check if decrease button is pressed
        
        disp('decrease button pressed..'); % printing decrease button pressed.
        
        car_controller_obj = Car_Controller.speed_down(car_controller_obj);  % Decrease Speed
        
    elseif(set_speed_button_pressed < 3.8) % Check if set speed button is pressed
        
        disp('set speed button pressed..');
        
        car_controller_obj = Car_Controller.set_mode(car_controller_obj, string(Mode.SetSpeed)); % Change mode to set speed
        
    elseif(stop_button_pressed < 3.8) % Check if cancel button is pressed
        
        disp('Stop button pressed..'); % printing stop button pressed.
        
        car_controller_obj = Car_Controller.set_mode(car_controller_obj, string(Mode.Normal)); % Change mode to normal
        
    elseif(adaptive_control_button_pressed < 3.8 || strcmp(car_controller_obj.mode, string(Mode.Adaptive))) %adaptive mode
        
        disp('adaptive control button pressed..'); % printing adaptive control button pressed.
        
        car_controller_obj = Car_Controller.set_mode(car_controller_obj, string(Mode.Adaptive)); % Change mode to adaptive
        
        if car_controller_obj.change_adaptive_speed % check if change_adaptive_speed flag is true
            
            car_controller_obj = Car_Controller.set_top_speed_in_adaptive(car_controller_obj); % set top speed in adaptive mode
            
        end
        
        if distance < 0.2 % check if distance between car and object is less than 0.2
            
            car_controller_obj = Car_Controller.speed_down(car_controller_obj); % Decrease speed
            
            pause(0.7); % add delay
            
        else
            
            if car_controller_obj.speed < car_controller_obj.top_speed_in_adaptive % check if current speed of the car is less than speed of car when adaptive mode was set.
                
                car_controller_obj = Car_Controller.speed_up(car_controller_obj); % Increase Speed
                
            end
            
        end
        
    else
        
        if car_controller_obj.speed > 0 && strcmp(car_controller_obj.mode, string(Mode.Normal)) > 0 % Check if car is in normal mode and speed is greater than 0.
            
            pause(0.7); % add delay
            
            car_controller_obj = Car_Controller.speed_down(car_controller_obj); % Decrease speed when no button is pressed.
            
        end
        
    end
    
    printLCD(lcd, char("Mode : " + car_controller_obj.mode)); % print on LCD
    
    printLCD(lcd, char("Speed : " + car_controller_obj.speed + " km/h")); % print on LCD
    
    if strcmp(car_controller_obj.mode, string(Mode.Adaptive)) % check if mode is adaptive
        
        clearLCD(lcd); % Clear LCD
        
        pause(0.2); % add delay.
        
        printLCD(lcd, char("Mode : " + car_controller_obj.mode)); % print on LCD
        
        printLCD(lcd, char("Speed : " + car_controller_obj.speed + " km/h")); % print on LCD
        
    end
    
end

