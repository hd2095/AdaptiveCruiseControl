classdef Car_Controller < handle % Implementing handle class to define objects/references of car_controller_obj
    
    properties
        speed
        mode
        top_speed_in_adaptive
        change_adaptive_speed % Properties of Car_Controller Class
    end
    
    methods(Static)
        
        function car_controller_obj = intialize_car_controller(car_controller_obj) % function to initialize/set default values of car_controller_obj
        car_controller_obj.speed = 0; % default start speed
        car_controller_obj.mode = string(Mode.Normal); % default mode
        car_controller_obj.top_speed_in_adaptive = 0;  % default speed in adpative mode
        car_controller_obj.change_adaptive_speed = true; % default flag in adaptive mode
        end
        
        function car_controller_obj = speed_up(car_controller_obj) % function to increase speed
        car_controller_obj.speed = car_controller_obj.speed + 1; % increase current speed of car by 1.
        end
        
        function car_controller_obj = speed_down(car_controller_obj) % function to decrease speed
        car_controller_obj.speed = car_controller_obj.speed - 1; % decrease current speed of car by 1.
        if(car_controller_obj.speed == 0 || car_controller_obj.speed < 0) % check if car current speed is 0.
            car_controller_obj.speed = 0; % set current speed to 0.
        end
        end
        
        function car_controller_obj = set_mode(car_controller_obj, mode) % function to set mode of the car
        car_controller_obj.mode = mode; % update mode property of car_controller_object.
        end
        
        function car_controller_obj = set_top_speed_in_adaptive(car_controller_obj)
        car_controller_obj.top_speed_in_adaptive = car_controller_obj.speed; % update top_speed_in_adaptive property of car_controller_object to current speed.
        car_controller_obj.change_adaptive_speed = false; % update change_adaptive_speed property of car_controller_object to false.
        end
        
        function car_controller_obj = change_speed_in_adaptive(car_controller_obj) % functipn to change_speed_in_adaptive flag.
        car_controller_obj.change_adaptive_speed = true; % update change_adaptive_speed property of car_controller_object to true.
        end
        
    end
end