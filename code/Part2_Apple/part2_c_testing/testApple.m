function r = testApple()
    %Load the images
    testIapples = cell(4,1);
    testIapples{1} = 'testApples/Apples_by_MSR_MikeRyan_flickr.jpg';
    testIapples{2} = 'testApples/audioworm-QKUJj2wmxuI-original.jpg';
    testIapples{3} = 'testApples/Bbr98ad4z0A-ctgXo3gdwu8-original.jpg';
    
    %For each image, work out the posterior probability and display
    figure
    for iImage = 1:3
        curI = double(imread(  testIapples{iImage}   )) / 255;
        result = helper_classify_image(curI); 
        subplot(2,2,iImage), subimage(result);
        %Write result image to file
        filename = strcat(int2str(iImage),'result.png');
        imwrite(result,filename)
    end
end