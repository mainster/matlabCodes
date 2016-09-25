% Programm system_2.m zur Parametrierung des Modells 
% system_2.mdl

tf1 = tf(1, [1,1])
tf2 = tf(1, [1,2,8])

my_sys = [tf2*tf1, tf2*tf1*tf1]

my_sys1 = ss(my_sys)
