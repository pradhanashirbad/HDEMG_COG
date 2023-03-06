function y = mono2bi32(obj,x_filtered)

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

y=Temp;

end

