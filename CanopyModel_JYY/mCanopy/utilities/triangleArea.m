


function area_v = triangleArea(metrix)

x1 = metrix(:,1); y1 = metrix(:,2); z1 = metrix(:,3);
x2 = metrix(:,4); y2 = metrix(:,5); z2 = metrix(:,6);
x3 = metrix(:,7); y3 = metrix(:,8); z3 = metrix(:,9);

a = sqrt((x2-x1).^2 + (y2-y1).^2 + (z2-z1).^2);
b = sqrt((x3-x1).^2 + (y3-y1).^2 + (z3-z1).^2);
c = sqrt((x3-x2).^2 + (y3-y2).^2 + (z3-z2).^2);
p = (a+b+c)/2;
area_v = sqrt(p.*(p-a).*(p-b).*(p-c));  % Heron's formula, calculate triangle area

end

