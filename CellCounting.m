%%%%% Cell counting for movies (calls SegCount)
%%%%% Jessica Rika Perez
%%%%% jessica.perez2@mail.mcgill.ca

%%%%% Perez et al.,
%%%%%% ?Tracking of Mesenchymal Stem Cells with Fluorescence Endomicroscopy
%%%%%% Imaging in Radiotherapy-Induced Lung Injury.? 
%%%%%% Scientific Reports 7 (January 19, 2017): 40748. doi:10.1038/srep40748.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%% reads every frame and returns the number of detected cells
function [NumberOfCellsPerFrame] = CellCounting(Movie)
 [image, properties] = mktread(Movie,1);
    nFrames = properties.nbframes;
    NumberOfCellsPerFrame = zeros(1,nFrames);
    [NumberOfCellsPerFrame(1)] = SegCount(image);
    h1=waitbar(0,'');
    
    for i=2:nFrames
        waitbar(i/nFrames,h1,['Frame ' num2str(i) ' out of ' num2str(nFrames)])
        [image, ~] = mktread(Movie,i);
        [NumberOfCellsPerFrame(i)] = SegCount(image);
    end 
    close(h1);
end
