function y = mono2bi32x2(obj,x_filtered)

Temp(:,1)=x_filtered(:,1)-x_filtered(:,2);
Temp(:,2)=x_filtered(:,2)-x_filtered(:,3);
Temp(:,3)=x_filtered(:,3)-x_filtered(:,4);
Temp(:,4)=x_filtered(:,4)-x_filtered(:,5);
Temp(:,5)=x_filtered(:,5)-x_filtered(:,6);
Temp(:,6)=x_filtered(:,6)-x_filtered(:,7);
Temp(:,7)=x_filtered(:,7)-x_filtered(:,8);


Temp(:,1+7)=x_filtered(:,9)-x_filtered(:,10);
Temp(:,2+7)=x_filtered(:,10)-x_filtered(:,11);
Temp(:,3+7)=x_filtered(:,11)-x_filtered(:,12);
Temp(:,4+7)=x_filtered(:,12)-x_filtered(:,13);
Temp(:,5+7)=x_filtered(:,13)-x_filtered(:,14);
Temp(:,6+7)=x_filtered(:,14)-x_filtered(:,15);
Temp(:,7+7)=x_filtered(:,15)-x_filtered(:,16);


Temp(:,1+14)=x_filtered(:,17)-x_filtered(:,18);
Temp(:,2+14)=x_filtered(:,18)-x_filtered(:,19);
Temp(:,3+14)=x_filtered(:,19)-x_filtered(:,20);
Temp(:,4+14)=x_filtered(:,20)-x_filtered(:,21);
Temp(:,5+14)=x_filtered(:,21)-x_filtered(:,22);
Temp(:,6+14)=x_filtered(:,22)-x_filtered(:,23);
Temp(:,7+14)=x_filtered(:,23)-x_filtered(:,24);

Temp(:,1+21)=x_filtered(:,25)-x_filtered(:,26);
Temp(:,2+21)=x_filtered(:,26)-x_filtered(:,27);
Temp(:,3+21)=x_filtered(:,27)-x_filtered(:,28);
Temp(:,4+21)=x_filtered(:,28)-x_filtered(:,29);
Temp(:,5+21)=x_filtered(:,29)-x_filtered(:,30);
Temp(:,6+21)=x_filtered(:,30)-x_filtered(:,31);
Temp(:,7+21)=x_filtered(:,31)-x_filtered(:,32);

Temp(:,1+28)=x_filtered(:,33)-x_filtered(:,34);
Temp(:,2+28)=x_filtered(:,34)-x_filtered(:,35);
Temp(:,3+28)=x_filtered(:,35)-x_filtered(:,36);
Temp(:,4+28)=x_filtered(:,36)-x_filtered(:,37);
Temp(:,5+28)=x_filtered(:,37)-x_filtered(:,38);
Temp(:,6+28)=x_filtered(:,38)-x_filtered(:,39);
Temp(:,7+28)=x_filtered(:,39)-x_filtered(:,40);

Temp(:,1+35)=x_filtered(:,41)-x_filtered(:,42);
Temp(:,2+35)=x_filtered(:,42)-x_filtered(:,43);
Temp(:,3+35)=x_filtered(:,43)-x_filtered(:,44);
Temp(:,4+35)=x_filtered(:,44)-x_filtered(:,45);
Temp(:,5+35)=x_filtered(:,45)-x_filtered(:,46);
Temp(:,6+35)=x_filtered(:,46)-x_filtered(:,47);
Temp(:,7+35)=x_filtered(:,47)-x_filtered(:,48);

Temp(:,1+42)=x_filtered(:,49)-x_filtered(:,50);
Temp(:,2+42)=x_filtered(:,50)-x_filtered(:,51);
Temp(:,3+42)=x_filtered(:,51)-x_filtered(:,52);
Temp(:,4+42)=x_filtered(:,52)-x_filtered(:,53);
Temp(:,5+42)=x_filtered(:,53)-x_filtered(:,54);
Temp(:,6+42)=x_filtered(:,54)-x_filtered(:,55);
Temp(:,7+42)=x_filtered(:,55)-x_filtered(:,56);

Temp(:,1+49)=x_filtered(:,57)-x_filtered(:,58);
Temp(:,2+49)=x_filtered(:,58)-x_filtered(:,59);
Temp(:,3+49)=x_filtered(:,59)-x_filtered(:,60);
Temp(:,4+49)=x_filtered(:,60)-x_filtered(:,61);
Temp(:,5+49)=x_filtered(:,61)-x_filtered(:,62);
Temp(:,6+49)=x_filtered(:,62)-x_filtered(:,63);
Temp(:,7+49)=x_filtered(:,63)-x_filtered(:,64);
y=Temp;

end

