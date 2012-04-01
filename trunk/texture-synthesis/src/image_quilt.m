%function result = image_quilt(input, tile_size, n, overlap, err, simple, useconv)
%��input��@ Efros/Freeman Image quilting�t��k
%
%Inputs
%   input:  �n�Ψӥͦ����ӷ�����
%   tile_size:   �C�϶����j�p
%   n:  �n���Ʃ�m�h�ֶ�
%   overlap: ���|�����n�X��pixel (def: 1/6 tile_size)
%   err: �Ψӭp��C���̤j���~�t�� (def: 0.1)
%   simple: �O�_²�氵 1->�u�Ocopy�C��title, 0->���@cut���ʧ@
%   useconv: ���������B�� 1->�u�p�⥪���W�����|�����p��distance, 0->��Ҧ������A�p��@��distance

function result = image_quilt(input, tile_size, n, overlap, err, simple, useconv)

input = double(input);

if( length(size(input)) == 2 )
    input = repmat(input, [1 1 3]);
elseif( length(size(input)) ~= 3 )
    error('Input image must be 2 or 3 dimensional');
end;

if(nargin < 2)
    %�S���]tile_size�ɧ�tile_size�]�w��x,y�̤p�̪��@�b(�]���٭n��overlap�h����)
    if(size(input, 1) < size(input, 2))
        tile_size = size(input, 1) / 2;
    else
        tile_size = size(input, 2) / 2;
    end
else
    %�Ytitle_size �j��input��size�|�����D�ҥH��L�վ�̤j��input��size���@�b
    if(tile_size > size(input, 1))
        tile_size = size(input, 1) / 2;
    end

    if(tile_size > size(input, 2))
        tile_size = size(input, 2) / 2;
    end
end

if( nargin < 3)
   %�p�G�S���]�w���ƴX�����ܹw�]��2��
   n = 2;
end
if( nargin < 4 )
    overlap = round(tile_size / 6);
end;

if( nargin < 5 )
    err = 0.002;
end;

if(nargin < 6)
    simple = 0;
end

if(nargin < 7)
    useconv = 1;
end

if( overlap >= tile_size )
    error('Overlap must be less than tile_size');
end;

%�p��̲ת�size
destsize = n * tile_size - (n-1) * overlap 

result = zeros(destsize, destsize, 3);

%x��V�ͦ�n��, y��V�]�ͦ�n��
for i=1:n,
     for j=1:n,
         startI = (i-1)*tile_size - (i-1) * overlap + 1;
         startJ = (j-1)*tile_size - (j-1) * overlap + 1;
         endI = startI + tile_size -1 ;
         endJ = startJ + tile_size -1;
         
         %�p��C��tile���|�ϰ쪺distance
         %�o�̫�|�Qconvolutions���N
         distances = zeros( size(input,1)-tile_size, size(input,2)-tile_size );
        
        if( useconv == 0 )
            %�p��Ȧs�Ҧ�pixel��distances
            for a = 1:size(distances,1)
                v1 = result(startI:endI, startJ:endJ, 1:3);
                for b = 1:size(distances,2),                 
                    v2 = input(a:a+tile_size-1,b:b+tile_size-1, 1:3);
                    distances(a,b) = sum_square( double((v1(:) > 0)) .* (v1(:) - v2(:)) ); 
                end;
            end;
            
        else
            %�p��ѤU�ϰ�pixel��distances
            %�p��ӷ��H�Υ���n���|�ϰ쪺distances
            if( j > 1 )
                distances = ssd( input, result(startI:endI, startJ:startJ+overlap-1, 1:3) );    
                distances = distances(1:end, 1:end-tile_size+overlap);
            end;
            
            %�p��ӷ��H�ΤW���n���|�ϰ쪺distances
            if( i > 1 )
                Z = ssd( input, result(startI:startI+overlap-1, startJ:endJ, 1:3) );
                Z = Z(1:end-tile_size+overlap, 1:end);
                if( j > 1 ) distances = distances + Z;
                else distances = Z;
                end;
            end;
            
            %�p�G�W��H�Υ��䳣�ݭn�p��h�A�p�⭫�|������distance
            if( i > 1 && j > 1 )
                Z = ssd( input, result(startI:startI+overlap-1, startJ:startJ+overlap-1, 1:3) );
                Z = Z(1:end-tile_size+overlap, 1:end-tile_size+overlap);                   
                distances = distances - Z;
            end;
            
        end;

         %��@�ӳ̦X�A��
         best = min(distances(:));
         candidates = find(distances(:) <= (1+err)*best);
          
         idx = candidates(ceil(rand(1)*length(candidates)));
                         
         [sub(1), sub(2)] = ind2sub(size(distances), idx);
         fprintf( 'Picked tile (%d, %d) out of %d candidates.  Best error=%.4f\n', sub(1), sub(2), length(candidates), best );       
         
         alpha=0.5;
         %�p�Gsimple�O1���ܴN�u�O�ƻstile,���M�n��minimum error boundary cut
         if( simple )
              if( i == 1 && j == 1 )
                 result(startI:endI, startJ:endJ, 1:3) = input(sub(1):sub(1)+tile_size-1, sub(2):sub(2)+tile_size-1, 1:3);
             end
              if j>1
                 
                   result(startI:endI, startJ:startJ+overlap-1,1:3)=(1-alpha)*result(startI:endI, startJ:startJ+overlap-1,1:3)+alpha*input(sub(1):sub(1)+tile_size-1, sub(2):sub(2)+overlap-1,1:3);
                   result(startI:endI, startJ+overlap:endJ,1:3)=input(sub(1):sub(1)+tile_size-1, sub(2)+overlap:sub(2)+tile_size-1, 1:3);
              end
              if i>1
                   result(startI:startI+overlap-1, startJ:endJ,1:3)=(1-alpha)* result(startI:startI+overlap-1, startJ:endJ,1:3)+alpha*input(sub(1):sub(1)+overlap-1, sub(2):sub(2)+tile_size-1,1:3);
                   result(startI+overlap:endI, startJ:endJ,1:3)=input(sub(1)+overlap:sub(1)+tile_size-1, sub(2):sub(2)+tile_size-1, 1:3);
               end                  
         else
             
             %��l�Ƥ@��tile_size * tile_size��mask
             mask = ones(tile_size, tile_size);
             
             %�p�⥪�䪺overlap
             if( j > 1 )
                 
                 %�p����ɰϰ쪺SSD.
                 edge = ( input(sub(1):sub(1)+tile_size-1, sub(2):sub(2)+overlap-1) - result(startI:endI, startJ:startJ+overlap-1) ).^2;
                 
                 %�p��g�Lminimum error boundary cut���}�C
                 cost = mini_cut(edge, 0);
                 
                 %�p��B�n�üg��ت���Ƥ�
                 mask(1:end, 1:overlap) = double(cost >= 0);
             end;
             
             %�p��W����overlap
             if( i > 1 )
                 %�p����ɰϰ쪺SSD.
                 edge = ( input(sub(1):sub(1)+overlap-1, sub(2):sub(2)+tile_size-1) - result(startI:startI+overlap-1, startJ:endJ) ).^2;
                 
                 %�p��g�Lminimum error boundary cut���}�C
                 cost = mini_cut(edge, 1);
                 
                 %�p��B�n�üg��ت���Ƥ�
                 mask(1:overlap, 1:end) = mask(1:overlap, 1:end) .* double(cost >= 0);
             end;
             
             
             if( i == 1 && j == 1 )
                 result(startI:endI, startJ:endJ, 1:3) = input(sub(1):sub(1)+tile_size-1, sub(2):sub(2)+tile_size-1, 1:3);
             else
                 %�g��ت���Ƥ�
                 result(startI:endI, startJ:endJ, :) = filtered_write(result(startI:endI, startJ:endJ, :), ...
                     input(sub(1):sub(1)+tile_size-1, sub(2):sub(2)+tile_size-1, :), mask); 
             end;
             
         end;

         image(uint8(result));
         drawnow;
     end;
end;

figure;
image(uint8(result));

function result = sum_square( input )
result = sum( input.^2 );

function A = filtered_write(A, B, mask)
for i = 1:3,
    A(:, :, i) = A(:,:,i) .* (mask == 0) + B(:,:,i) .* (mask == 1);
end;
