function KLT(folder, sigma, kernel_size, n, t, smooth, ext)
    
    filePattern = fullfile(folder, ext);
    jpegFiles = dir(filePattern); 
    
    
    % 1. Calculate velocity vectors for all images and store it in result_Vx
    % and result_Vy
    for k = 1:length(jpegFiles)
      fileName = jpegFiles(k).name;
      fullName = fullfile(folder, fileName);
      fprintf(1, 'Now reading %s\n', fullName);
      image = imread(fullName);
      
      if k == 1
          % Locate feature points on first frame using Harris Corner Detector
          [H, corners] = harris_corner(image, sigma, kernel_size, n, t, smooth, 0);
          n = size(image,1); 
          m = size(image,2);
          Vx= zeros(1, size(corners,1));
          Vy= zeros(1, size(corners,1));
          imshow(image);
          hold on
          plot(corners(:, 2), corners(:,1), 'r*');
          drawnow; % Force display to update immediately.
          framesCell{k} = getframe;

      else
          % Call Lucas Kanade for each frame
          [V_x, V_y] = lucas_kanade(previous, image, corners);
          
          % Update corners
          scale = 0.8;
          for i=1:size(corners, 1)
            
            if (corners(i, 1) + ceil(V_y(i) * scale)) > size(image,1)
                corners(i, 1) = size(image,1);
            elseif (corners(i, 1) + ceil(V_y(i) * scale)) < 1
                corners(i, 1) = 1;
            else
                corners(i, 1) = corners(i, 1) + ceil(V_y(i) * scale);
            end
            
            if (corners(i, 2) + ceil(V_x(i) * scale)) > size(image,2)
                corners(i, 2) = size(image,2);
            elseif (corners(i, 2) + ceil(V_x(i) * scale)) < 1
                corners(i, 2) = 1;
            else
                corners(i, 2) = corners(i, 2) + ceil(V_x(i) * scale);
            end

          end
          
          figure(1);
          imshow(image); 
          hold on
          quiver(transpose(corners(:,2)),transpose(corners(:,1)),V_x, V_y);
          plot(corners(:, 2), corners(:,1), 'r*');
          framesCell{k} = getframe;
      end
      previous = image;
      
    end
        
    % Make video 
    framesMat = cell2mat(framesCell);
    v = VideoWriter('newfile.avi');
    open(v);
    writeVideo(v,framesMat);
     
end