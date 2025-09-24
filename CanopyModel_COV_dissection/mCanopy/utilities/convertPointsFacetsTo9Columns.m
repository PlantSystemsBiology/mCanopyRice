%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Convert the Points + Facets format to the 9 columns metrix format
% The 9 columns format is the standard format used for 3D canopy model and
% ray tracing input format. 
% The Points + Facets format is another format to present a 3D model.
% Points are listed, and Facets are the index of 3 points presenting one
% facet. 
% developed by Qingfeng
% 2020-03-21
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function M_9ColumnsMetrix = convertPointsFacetsTo9Columns(Points, Facets)

metrix = zeros(0,9);
[row, col]=size(Facets);
for n=1:row
    metrix(n,1)= Points(Facets(n,1),1);
    metrix(n,2)= Points(Facets(n,1),2);
    metrix(n,3)= Points(Facets(n,1),3);
    metrix(n,4)= Points(Facets(n,2),1);
    metrix(n,5)= Points(Facets(n,2),2);
    metrix(n,6)= Points(Facets(n,2),3);
    metrix(n,7)= Points(Facets(n,3),1);
    metrix(n,8)= Points(Facets(n,3),2);
    metrix(n,9)= Points(Facets(n,3),3);
end

M_9ColumnsMetrix = metrix;

end

