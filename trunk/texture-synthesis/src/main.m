function main( )
%main ²����檺�禡
%   image_name: �Ϥ��ɮצW��, ��bres��Ƨ���
%   tile_size: �϶��j�p, ����W�L��l��Ƥj�p, �٭n�`�Noverlap���j�p
%   tile_number: x, y���ƴX��
%   overlap: ���|�������n�X��pixel, ����j��tile_size�]����Ӥp
%   error: �p��O�_�۲Ū��~�t��
%   simple: �O�_²�氵 1->�ȬO��C��tile�ƻs�@��, 0->�ƻs��A��minimum error boundary cut
%   useconv: �O�_�Ҽ{��Lpixel�������� 1->�ȦҼ{�W��Υ��誺���a�ϰ�, 0->�Ҽ{�Ҧ�pixel��distances
    dir = '../res/';
    file_type = '.jpg';
    image_name = 'Nc13';
    file_name = [dir image_name file_type];
    result_name = [dir image_name '_result' file_type];
    picture = imread(file_name);
    tile_size = 100;
    tile_number = 4;
    overlap = 10;
    error = 0.01;
    simple = 0;
    useconv = 1;
    
    result = image_quilt(picture, tile_size, tile_number, overlap, error, simple, useconv);
    imwrite(uint8(result), result_name);
end

