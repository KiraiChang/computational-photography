%function result_texture = mini_cut( input_text, dir )
%�O�갵minimum error boundary cut���B�J
%   output:
%       result_texture�O�p��cut��t�᪺texture���G
%
%   input:
%       input_text:�n�p��p�����texture
%       dir:�O�n������V 0 = ����, 1 = ����
function result_texture = mini_cut( input_text, dir )
%nargin�̾ڿ�J���ѼƨӰ���,
%�b�o�̦p�Gdir�j��ε���1�N�N��O�����]���n���x�}�ഫ
if( nargin > 1 && dir == 1 )
    input_text = input_text';
end;

%���ͤ@�ӭp��cost paths���}�C,�ç�Ĥ@��row�ƻs��cost paths��
cost_path = zeros(size(input_text));
cost_path(1:end,:) = input_text(1:end,:);

%�ѲĤG�Ӱ}�C�}�l�p�� cost paths���쵲��
for i=2:size(cost_path,1),
    
    cost_path(i,1) = input_text(i,1) + min( cost_path(i-1,1), cost_path(i-1,2) );
    for j=2:size(cost_path,2)-1,
        cost_path(i,j) = input_text(i,j) + min( [cost_path(i-1,j-1), cost_path(i-1,j), cost_path(i-1,j+1)] );
    end;
    cost_path(i,end) = input_text(i,end) + min( cost_path(i-1,end-1), cost_path(i-1,end) );
    
end;

%�������y��
result_texture = zeros(size(input_text));

[cost, idx] = min(cost_path(end, 1:end));
result_texture(i, 1:idx-1) = -1;
result_texture(i, idx) = 0;
result_texture(i, idx+1:end) = +1;  

%       idx-1: left (or top) side of cut
%       idx: along the cut
%       idx+1: right (or bottom) side of cut
for i=size(cost_path,1)-1:-1:1,
    for j=1:size(cost_path,2),

        if( idx > 1 && cost_path(i,idx-1) == min(cost_path(i,idx-1:min(idx+1,size(cost_path,2))) ) )
            idx = idx-1;
        elseif( idx < size(cost_path,2) && cost_path(i,idx+1) == min(cost_path(i,max(idx-1,1):idx+1)) )
            idx = idx+1;
        end;
               
        
        result_texture(i, 1:idx-1) = -1;
        result_texture(i, idx) = 0;
        result_texture(i, idx+1:end) = +1;        
            
    end;
end;
    
if( nargin > 1 && dir == 1 )
    result_texture = result_texture';
end;

