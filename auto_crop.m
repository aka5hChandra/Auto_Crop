function [x0, y0, x1, y1, x2, y2, x3, y3] = auto_crop ( f )
close all;

%%%IMPORTANT%%%
% x0,y0 are the x, y coordinates of the top left corner of image
% x1,y1 are the x, y coordinates of the top right corner of image
% x2,y2 are the x, y coordinates of the bottom right corner of image
% x3,y3 are the x, y coordinates of the bottom left corner of image

%getting size of the input image
Ro = size(f,1);
Co = size(f,2);

% always pick middle half


%close all;
%figure ; imshow(f); title('in');
%t = graythresh(f);
%f = im2bw(f , t);
%figure ; imshow(f); title('bw');
f = rgb2gray(f);
f = edge(f , 'canny');
%figure ; imshow(f); title('canny');

st = strel('disk', 5);
%f = imclose(f , st);
%figure ; imshow(f); title('closed ');

f = ~f;
f = imerode(f , st);

%figure; imshow(f , []); title('imerode');
f = bwlabel(f);
%figure; imshow(f , []); title('Connected components');
stats = regionprops(f , 'area');
x = [stats.Area];
[np , npID] = max(x);

f(f ~= npID) = 0;
f(f== npID) = 1;

%f = bwmorph(f,'branchpoints' );
%st = strel('disk', 3);
%f = imerode(f , st);
%f = medfilt2(f);
%f = imclose(f , st);

%figure ; imshow(f); title(' inversed ');

st = strel('disk', 20); %30
f = imclose(f , st);
%f = bwmorph(f,'fill' );
%figure ; imshow(f); title(' fill ');
%f = imgaussfilt(uint8(f * 255) , 5);
st = strel('disk', 3);
f = imerode(f , st);
%figure ; imshow(f); title(' errode ');
%{%
f = edge(f , 'canny');

st = strel('disk', 5);%3
f = imdilate(f , st);

%f = imgaussfilt(uint8(f * 255) , 5);
%figure, imshow(f), title('di;ate and guss');

%}

%f = bwmorph(f,'thin' );
%figure, imshow(f), title('thn' );
%figure ;
%{%
[H,theta,rho] = hough(f,'RhoResolution',0.9,'ThetaResolution',0.9);
P = houghpeaks(H, 4 ,'threshold',ceil(.1*max(H(:))));%.3

lines = houghlines(f,theta,rho,P,'FillGap',100,'MinLength',50);%5 %7
%figure, imshow(f), hold on
max_len = 0;

mnX = 1;
mxX = 1;
mnY = 1;
mxX = 1;

xs = [];
ys = [];
allP = [];
for k = 1:length(lines)
    xs =[ xs , lines(k).point1(1 , 1) ,  lines(k).point2(1 , 1)];
    ys =[ ys , lines(k).point1(1 , 2) ,  lines(k).point2(1 , 2)];
    allP= [allP ; lines(k).point1 ;  lines(k).point2];
end;


[tXs , xID] = sort(xs);

sqD = [];
sqD2 = [];
for k = 1:length(allP)
    sqD =  [sqD ,  norm(allP(k , : ))];
     sqD2 =  [sqD2 ,  pdist2( allP(k, : ) , [Ro , 1] )];
end;


[sqD , ID] = sort(sqD);
err = 0;
x0 = allP(ID(1),1) - err;
y0 = allP(ID(1),2) - err;

x2 = allP(ID(length(allP)),1) + err;
y2 = allP(ID(length(allP)),2) + err;


%{

sqD = [];
for k = 1:length(allP)
    sqD =  [sqD ,  pdist2( allP(k, : ) , [Ro , 1] )];
end;
%}

[sqD2 , ID] = sort(sqD2);

x1 = allP(ID(1),1) - err;
y1 = allP(ID(1),2) - err ;

x3 = allP(ID(length(allP)),1) + err;
y3 = allP(ID(length(allP)),2) + err;



%{
if(x0 < 1)
    x0 =1;
end
if(y0 < 1)
    y0 =1;
end

if(x2 > Co)
    x2 = Co;
end

if(y2 > Ro)
    y2 = Ro;
end

if(x1 < 1)
    x1 =1;
end
if(y1 < 1)
    y1 =1;
end

if(x3 > Co)
    x3 = Co;
end

if(y3 > Ro)
    y3 = Ro;
end

%}

%{

xmId = 1;
for l = 2 : ln
    if(ys(xId(l) < ys(xmId)))
        y0 = ys(xID(l));
        xmId = l;
    end;
end;
x0 = tXs(l);



xmId = 1;
for l = 2 : ln
    if(ys(xId(l) > ys(xmId)))
        y0 = ys(xID(l));
        xmId = l;
    end;
end;
x1 = tXs(l);

%}%{
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

   % Plot beginnings and ends of lines
   plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
   plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

   % Determine the endpoints of the longest line segment
   len = norm(lines(k).point1 - lines(k).point2);
   if ( len > max_len)
      max_len = len;
      xy_long = xy;
   end
end
% highlight the longest line segment
plot(xy_long(:,1),xy_long(:,2),'LineWidth',2,'Color','red');
%}
end
%%Some random numbers come out of here
%x0 = randi([1 Co],1,1);
%y0 = randi([1 Ro],1,1);
%x1 = randi([1 Co],1,1);
%y1 = randi([1 Ro],1,1);
%x2 = randi([1 Co],1,1);
%y2 = randi([1 Ro],1,1);
%x3 = randi([1 Co],1,1);
%y3 = randi([1 Ro],1,1);




