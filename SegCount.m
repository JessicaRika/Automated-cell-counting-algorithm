%%%%% Automated cell counting algorithm
%%%%% Jessica Rika Perez
%%%%% jessica.perez2@mail.mcgill.ca

%%%%% Perez et al.,
%%%%%% ?Tracking of Mesenchymal Stem Cells with Fluorescence Endomicroscopy
%%%%%% Imaging in Radiotherapy-Induced Lung Injury.? 
%%%%%% Scientific Reports 7 (January 19, 2017): 40748. doi:10.1038/srep40748.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [NumberOfCells] = SegCount(Image)

% Show original image
figure, imshow(Image,[])

%-------------------------------------------------------------------------
% Increase image contrast
[ContrastedImage] = AutoContrast(Image);

% Show contrasted image
%figure, imshow(ContrastedImage,[]);

%-------------------------------------------------------------------------

% Image opening with granulometry
Igran = GranulometryOpening(ContrastedImage);

% Show granulometry opened image
%figure, imshow(Igran,[]);

%-------------------------------------------------------------------------

% Threshold and quantize image
Ithresh = multithresh(Igran,3);
seg_I = imquantize(Igran,Ithresh);

%Show quantized image
%figure, imshow(seg_I,[]);

%-------------------------------------------------------------------------

% Separate two levels of segmented image
seg_II = seg_I;
seg_III = seg_I;

%-------------------------------------------------------------------------

% Keep highest segmented level
seg_II(seg_II<4)=1;
seg_II(seg_II>3)=2; 
seg_II = seg_II -1;

% Remove small objects from foreground 
seg_II = bwareaopen(seg_II,100);

% Black and white labeling of segmented image
ImageLabel_II = bwlabel(seg_II);

% Show labelled image
%figure, imshow(ImageLabel_II,[]);

% Remove objects based on mean of original image and a threshold
[MeanImageLabel_II] = ObjectMeanThresh(Image, ImageLabel_II,30);

% Remove objects based on their roundness
[RoundnessImageLabel_II] = Roundness(MeanImageLabel_II,0.7);
%-------------------------------------------------------------------------

% Keep the two highest segmented levels 
seg_III(seg_III<3)=1;
seg_III(seg_III>2)=2; 
seg_III = seg_III -1;

% Remove small objects from foreground 
seg_III = bwareaopen(seg_III,100);

% Black and white labeling of segmented image
ImageLabel_III = bwlabel(seg_III);

% Show labelled image
%figure, imshow(ImageLabel_III,[]);

% Remove objects based on mean of original image and a threshold
[MeanImageLabel_III] = ObjectMeanThresh(Image, ImageLabel_III,30);

% Remove objects based on their roundness
[RoundnessImageLabel_III] = Roundness(MeanImageLabel_III,0.7);

%-------------------------------------------------------------------------

% Combine both thresholded segmented images
FinalImageLabel = RoundnessImageLabel_II + RoundnessImageLabel_III;
% Make it binary
FinalImageLabel(FinalImageLabel > 0) = 1;
% Label final image
FinalImageLabel = bwlabel(FinalImageLabel);

% Determine connected components
CCI = bwconncomp(FinalImageLabel);

% Count the number of objects
NumberOfCells = CCI.NumObjects;

% Show final count on labeled image
figure, vislabels(FinalImageLabel);

end