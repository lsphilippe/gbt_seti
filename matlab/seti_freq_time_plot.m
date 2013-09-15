function seti_freq_time_plot(fil, plname)

fil

leftmargin = 0.07;
start = 0.0;
stop = 1.0;


if (~exist('plname', 'var'))
    plname = 'TestPLOT';
end



plotcol='light';
data = fil.data;

%header = fitsinfo(inputfits);

%deltat should be in microseconds
deltat = fil.tsamp / 1000000;

deltaf = abs(fil.bw);

fcntr = fil.freq - fil.bw/2  + (size(data,2)/2 * (fil.bw));

mjd = fil.mjd;
%ra = convertdms(cell2mat(header.PrimaryData.Keywords(11,2)), 'd', 'SH');
%dec = convertdms(cell2mat(header.PrimaryData.Keywords(10,2)), 'd', 'SD');
ra=fil.ra;
dec=fil.dec;
%doppler = cell2mat(header.PrimaryData.Keywords(12,2));
snr = 5;
%source = num2str(cell2mat(header.PrimaryData.Keywords(14,2)));

addpath([docroot '/techdoc/creating_plots/examples'])


if(strcmp(plotcol, 'dark'))

wfcolormap = [0 0 0;0.0678431391716003 0.0921568647027016 0.100000001490116;0.135686278343201 0.184313729405403 0.200000002980232;0.203529417514801 0.276470601558685 0.300000011920929;0.271372556686401 0.368627458810806 0.400000005960464;0.339215695858002 0.460784316062927 0.5;0.407058835029602 0.552941203117371 0.600000023841858;0.474901974201202 0.645098030567169 0.699999988079071;0.542745113372803 0.737254917621613 0.800000011920929;0.610588252544403 0.829411745071411 0.899999976158142;0.678431391716003 0.921568632125854 1;0.684498727321625 0.923048496246338 1;0.690566062927246 0.924528300762177 1;0.696633398532867 0.92600816488266 1;0.702700734138489 0.927487969398499 1;0.70876806974411 0.928967833518982 1;0.714835405349731 0.930447638034821 1;0.720902740955353 0.931927502155304 1;0.726970076560974 0.933407306671143 1;0.733037352561951 0.934887170791626 1;0.739104688167572 0.936366975307465 1;0.745172023773193 0.937846839427948 1;0.751239359378815 0.939326703548431 1;0.757306694984436 0.94080650806427 1;0.763374030590057 0.942286372184753 1;0.769441366195679 0.943766176700592 1;0.7755087018013 0.945246040821075 1;0.781576037406921 0.946725845336914 1;0.787643373012543 0.948205709457397 1;0.793710708618164 0.949685513973236 1;0.799778044223785 0.951165378093719 1;0.805845379829407 0.952645182609558 1;0.811912715435028 0.954125046730042 1;0.817980051040649 0.955604910850525 1;0.824047386646271 0.957084715366364 1;0.830114722251892 0.958564579486847 1;0.836182057857513 0.960044384002686 1;0.84224933385849 0.961524248123169 1;0.848316669464111 0.963004052639008 1;0.854384005069733 0.964483916759491 1;0.860451340675354 0.96596372127533 1;0.866518676280975 0.967443585395813 1;0.872586011886597 0.968923449516296 1;0.878653347492218 0.970403254032135 1;0.884720683097839 0.971883118152618 1;0.890788018703461 0.973362922668457 1;0.896855354309082 0.97484278678894 1;0.902922689914703 0.976322591304779 1;0.908990025520325 0.977802455425262 1;0.915057361125946 0.979282259941101 1;0.921124696731567 0.980762124061584 1;0.927192032337189 0.982241928577423 1;0.93325936794281 0.983721792697906 1;0.939326703548431 0.98520165681839 1;0.945394039154053 0.986681461334229 1;0.951461315155029 0.988161325454712 1;0.957528650760651 0.989641129970551 1;0.963595986366272 0.991120994091034 1;0.969663321971893 0.992600798606873 1;0.975730657577515 0.994080662727356 1;0.981797993183136 0.995560467243195 1;0.987865328788757 0.997040331363678 1;0.993932664394379 0.998520135879517 1;1 1 1];
stairscolor = [0 1 1];
backgroundcolor = [0 0 0]; 
textcolor = [1 1 1];
dopplercolor = [0 1 1];
else
%wfcolormap = [1 1 1;0.98412698507309 0.98412698507309 0.996825397014618;0.968253970146179 0.968253970146179 0.993650794029236;0.952380955219269 0.952380955219269 0.990476191043854;0.936507940292358 0.936507940292358 0.987301588058472;0.920634925365448 0.920634925365448 0.98412698507309;0.904761910438538 0.904761910438538 0.980952382087708;0.888888895511627 0.888888895511627 0.977777779102325;0.873015880584717 0.873015880584717 0.974603176116943;0.857142865657806 0.857142865657806 0.971428573131561;0.841269850730896 0.841269850730896 0.968253970146179;0.825396835803986 0.825396835803986 0.965079367160797;0.809523820877075 0.809523820877075 0.961904764175415;0.793650805950165 0.793650805950165 0.958730161190033;0.777777791023254 0.777777791023254 0.955555558204651;0.761904776096344 0.761904776096344 0.952380955219269;0.746031761169434 0.746031761169434 0.949206352233887;0.730158746242523 0.730158746242523 0.946031749248505;0.714285731315613 0.714285731315613 0.942857146263123;0.698412716388702 0.698412716388702 0.93968254327774;0.682539701461792 0.682539701461792 0.936507940292358;0.666666686534882 0.666666686534882 0.933333337306976;0.650793671607971 0.650793671607971 0.930158734321594;0.634920656681061 0.634920656681061 0.926984131336212;0.61904764175415 0.61904764175415 0.92380952835083;0.60317462682724 0.60317462682724 0.920634925365448;0.58730161190033 0.58730161190033 0.917460322380066;0.571428596973419 0.571428596973419 0.914285719394684;0.555555582046509 0.555555582046509 0.911111116409302;0.539682567119598 0.539682567119598 0.90793651342392;0.523809552192688 0.523809552192688 0.904761910438538;0.507936537265778 0.507936537265778 0.901587307453156;0.492063492536545 0.492063492536545 0.898412704467773;0.476190477609634 0.476190477609634 0.895238101482391;0.460317462682724 0.460317462682724 0.892063498497009;0.444444447755814 0.444444447755814 0.888888895511627;0.428571432828903 0.428571432828903 0.885714292526245;0.412698417901993 0.412698417901993 0.882539689540863;0.396825402975082 0.396825402975082 0.879365086555481;0.380952388048172 0.380952388048172 0.876190483570099;0.365079373121262 0.365079373121262 0.873015880584717;0.349206358194351 0.349206358194351 0.869841277599335;0.333333343267441 0.333333343267441 0.866666674613953;0.31746032834053 0.31746032834053 0.863492071628571;0.30158731341362 0.30158731341362 0.860317468643188;0.28571429848671 0.28571429848671 0.857142865657806;0.269841283559799 0.269841283559799 0.853968262672424;0.253968268632889 0.253968268632889 0.850793659687042;0.238095238804817 0.238095238804817 0.84761905670166;0.222222223877907 0.222222223877907 0.844444453716278;0.206349208950996 0.206349208950996 0.841269850730896;0.190476194024086 0.190476194024086 0.838095247745514;0.174603179097176 0.174603179097176 0.834920644760132;0.158730164170265 0.158730164170265 0.83174604177475;0.142857149243355 0.142857149243355 0.828571438789368;0.126984134316444 0.126984134316444 0.825396835803986;0.111111111938953 0.111111111938953 0.822222232818604;0.095238097012043 0.095238097012043 0.819047629833221;0.0793650820851326 0.0793650820851326 0.815873026847839;0.0634920671582222 0.0634920671582222 0.812698423862457;0.0476190485060215 0.0476190485060215 0.809523820877075;0.0317460335791111 0.0317460335791111 0.806349217891693;0.0158730167895555 0.0158730167895555 0.803174614906311;0 0 0.800000011920929];
wfcolormap = [1 1 1;0.922875821590424 0.932897627353668 0.953376889228821;0.845751643180847 0.865795195102692 0.906753838062286;0.768627464771271 0.79869282245636 0.860130727291107;0.691503286361694 0.731590390205383 0.813507616519928;0.614379107952118 0.664488017559052 0.766884565353394;0.537254929542542 0.59738564491272 0.720261454582214;0.460130721330643 0.530283212661743 0.673638343811035;0.383006542921066 0.463180840015411 0.627015292644501;0.30588236451149 0.396078437566757 0.580392181873322;0.303050130605698 0.392955720424652 0.576543211936951;0.300217866897583 0.389832973480225 0.572694301605225;0.297385632991791 0.38671025633812 0.568845331668854;0.294553399085999 0.383587509393692 0.564996421337128;0.291721135377884 0.380464792251587 0.561147451400757;0.288888901472092 0.377342045307159 0.557298481464386;0.286056667566299 0.374219328165054 0.55344957113266;0.283224403858185 0.371096581220627 0.549600601196289;0.280392169952393 0.367973864078522 0.545751631259918;0.2775599360466 0.364851117134094 0.541902720928192;0.274727672338486 0.361728399991989 0.538053750991821;0.271895438432693 0.358605682849884 0.534204840660095;0.269063204526901 0.355482935905457 0.530355870723724;0.266230940818787 0.352360218763351 0.526506900787354;0.263398706912994 0.349237471818924 0.522657990455627;0.260566473007202 0.346114754676819 0.518809020519257;0.257734209299088 0.342992007732391 0.514960050582886;0.254901975393295 0.339869290590286 0.51111114025116;0.252069711685181 0.336746543645859 0.507262170314789;0.249237477779388 0.333623826503754 0.503413259983063;0.246405243873596 0.330501079559326 0.499564290046692;0.243572995066643 0.327378362417221 0.495715349912643;0.240740746259689 0.324255645275116 0.491866379976273;0.237908512353897 0.321132898330688 0.488017439842224;0.235076263546944 0.318010181188583 0.484168499708176;0.23224401473999 0.314887434244156 0.480319559574127;0.229411780834198 0.311764717102051 0.476470589637756;0.226579532027245 0.308641970157623 0.472621649503708;0.223747283220291 0.305519253015518 0.468772709369659;0.220915034413338 0.302396506071091 0.464923769235611;0.218082800507545 0.299273788928986 0.461074829101562;0.215250551700592 0.296151041984558 0.457225859165192;0.212418302893639 0.293028324842453 0.453376919031143;0.209586068987846 0.289905607700348 0.449527978897095;0.206753820180893 0.28678286075592 0.445679038763046;0.20392157137394 0.283660143613815 0.441830068826675;0.201089337468147 0.280537396669388 0.437981128692627;0.198257088661194 0.277414679527283 0.434132188558578;0.19542483985424 0.274291932582855 0.43028324842453;0.192592605948448 0.27116921544075 0.426434278488159;0.189760357141495 0.268046468496323 0.422585338354111;0.186928108334541 0.264923751354218 0.418736398220062;0.184095874428749 0.26180100440979 0.414887458086014;0.181263625621796 0.258678287267685 0.411038488149643;0.178431376814842 0.25555557012558 0.407189548015594;0.175599128007889 0.252432823181152 0.403340607881546;0.172766894102097 0.249310091137886 0.399491667747498;0.169934645295143 0.24618735909462 0.395642697811127;0.16710239648819 0.243064641952515 0.391793757677078;0.164270162582397 0.239941909909248 0.38794481754303;0.161437913775444 0.236819177865982 0.384095877408981;0.158605664968491 0.233696445822716 0.38024690747261;0.155773431062698 0.230573713779449 0.376397967338562;0.152941182255745 0.227450981736183 0.372549027204514];
stairscolor = [0.0392156876623631 0.141176477074623 0.415686279535294];
backgroundcolor = [1 1 1]; 
textcolor = [0 0 0];
dopplercolor = [0.847058832645416 0.160784319043159 0];
end

%data = flipud(data);
%data = fliplr(data);
fcntr;
deltat;
deltaf;


size(data,1)
size(data,2)
doppler = 2500000000;
doppler=0;
deltat
stepsize = abs(round(doppler * size(data,1) * deltat/(deltaf * 1000000))); 
b = size(data,2) * deltaf * 1000000

if doppler < 0
for j=(size(data,2) - stepsize - 3):-1:(stepsize + 3)
   line = getline(data, j, j-stepsize, 0);		
   dedop(j-stepsize-2) = sum(line);
end
dedop(1:stepsize+3) = 0;
dedop((size(data,2)-stepsize-3):size(data,2)) = 0;

else

stepsize
%size(data,2) - (stepsize - 3)
%(stepsize + 3)
%size(data,2) - stepsize - 3

%plot(getline(data, 100, 101, 0))	
%pause

for j=1:1:(size(data,2) - stepsize - 1)
   line = getline(data, j, j+stepsize, 0);		
   dedop(j+stepsize) = sum(line);	
end

%dedop(1:stepsize+1) = 0;
dedop((size(data,2)-stepsize-1):size(data,2)) = 0;

end

dedoptrim = dedop(floor(start * size(data,2)) + 1:ceil(stop*size(data,2)));



figure1 = figure('XVisual',...
    '0x22 (TrueColor, depth 16, RGB mask 0xf800 0x07e0 0x001f)',...
    'PaperType','<custom>',...
    'PaperSize',[11 9],...
    'Colormap',wfcolormap,...
    'Color',backgroundcolor);
%, 'visible', 'off',...

%left bottom width height
    
axes1 = axes('Parent',figure1,'ZColor',textcolor,'YGrid','on',...
    'Position',[leftmargin 0.388 0.774 0.537],...
    'YDir','reverse',...
    'YColor',textcolor,...
    'XGrid','on',...
    'XColor',textcolor,...
    'Layer','top',...
    'FontSize',16,...
    'FontName','Times',...
    'Color',backgroundcolor,...
    'XTick',zeros(1,0));
    
    


box(axes1,'on');
hold(axes1,'all');

floor(start * size(data,2))
ceil(stop*size(data,2))

a =  0 - (((size(data,2)/2) - (start * size(data,2))) * deltaf) * 1000000;
b = 0 + (  (stop*size(data,2) - size(data,2)/2) * deltaf) * 1000000;

dedopx = (a:(deltaf*1000000):(a+size(dedoptrim,2)*(deltaf*1000000))-(deltaf*1000000));

x = [a b];
a = 0;
b = size(data, 1) * deltat;
y = [a b];
xl = x;
yl = y;
xlim(axes1, x);
ylim(axes1, y);
%floor(start * size(data,2))
%ceil(stop*size(data,2))
%+1 on the bottom to offset array if we want to plot everything

samples = data(:, floor(start * size(data,2))+1:ceil(stop*size(data,2)));
size(samples)
imagesc(x, y, samples, 'Parent', axes1);
%imagesc([floor(start * size(data,2)) ceil(stop*size(data,2))], y,samples);
%mean(samples(:, 700))


% Create ylabel
ylabel('Time (Seconds)','FontSize',16,'FontName','Times','Color',textcolor);
title([plname],'FontSize',16,'FontName','Times', 'Color',textcolor,'FontWeight','bold');
% colorbar('peer',axes1);

xlabh = get(gca,'XLabel');
set(xlabh,'Position',get(xlabh,'Position') + [0 3 0])

[txtx,txty] = dsxy2figxy(gca, 0 - (((size(data,2)/2) - (start * size(data,2))) * deltaf) * 1000000, size(data, 1) * deltat);
txtx
txty
txty = txty - 0.38; %y size of txt box
snrtext = ['SNR: ', num2str(snr)]; 
drifttext = ['Drift: ',num2str(doppler),' Hz/sec'];
%    [txtx txty 0.35 0.2],...

% Create rectangle
annotation(figure1,'rectangle',...
    [leftmargin txty 0.20 0.38],...
    'FaceAlpha',0.7,...
    'FaceColor',backgroundcolor,...
    'Color',textcolor);

annotation(figure1,'textbox',...
    [txtx txty 0.35 0.38],...
    'String',{,['Telescope: ',fil.telescope],['MJD: ',num2str(mjd)],['RA: ',ra],['DEC: ',dec], [''],['F_{ctr}: ', num2str(fcntr, 11), ' MHz'], drifttext, snrtext},...
    'FontWeight','bold',...
    'FontSize',11,...
    'FontName','Times',...
    'FitBoxToText','off',...
    'EdgeColor','none',...
    'Color',textcolor,'FontName','Times');


%annotation(figure1,'textbox',...
%    [0.76 0.145 0.5 0.78],...
%    'String',{,['MJD: ',num2str(mjd)],['RA: ',ra],['DEC: ',dec], [''],['F_{ctr}: ', num2str(fcntr, 11), ' MHz'], drifttext, snrtext},...
%    'FontWeight','bold',...
%    'FontSize',12,...
%    'FontName','Times',...
%    'LineStyle', 'none',...
%    'FitBoxToText','off',...
%    'EdgeColor',[1 1 1],...
%    'Color',textcolor,'FontName','Times');

hold on
a = (deltaf * 1000000);
b = (deltaf+ (doppler * size(data, 1) * deltat/1000000))*1000000;
x = [a b];
a = 0;
b = size(data, 1) * deltat;
y = [a b];

%plot(x,y,'LineWidth',10,'LineStyle','-','Color',[0 0.800000011920929 0.800000011920929]);
    

plot(x,y,'Parent',axes1,...
    'MarkerFaceColor',dopplercolor,...
    'MarkerEdgeColor',dopplercolor,...
    'Marker','v',...
    'LineWidth',2.0,...
    'LineStyle','--',...
    'Color',dopplercolor);
        
axes2 = axes('Parent',figure1,'ZColor',[0 0 0],'YGrid','off',...
    'Position',[leftmargin 0.165 0.774 0.22],...
    'YColor',textcolor,...
    'XGrid','off',...
    'XColor',textcolor,...
    'Layer','top',...
    'FontSize',16,...
    'FontName','Times',...
    'Color',backgroundcolor,...
    'YTick',zeros(1,0));
    
    box(axes2,'on');
	hold(axes2,'all');
	
	xlim(axes2, xl);
	%ylim(axes2, );

	size(dedopx)
	size(dedoptrim)

	dedoptrim(dedoptrim==0) = min(dedoptrim(dedoptrim > 0));
stairs(dedopx(stepsize+1:end-stepsize),dedoptrim(stepsize+1:end-stepsize),'Parent',axes2,...
    'MarkerFaceColor',stairscolor,...
    'MarkerEdgeColor',stairscolor,...
    'LineWidth',1,...
    'Color',stairscolor);

% Create xlabel
xlabel('Frequency (F_{cntr} +/- Hz)','FontSize',16,'FontName','Times','Color',textcolor);
xlabh = get(axes2,'XLabel');
ybounds = get(axes2, 'YLim')
yext = ybounds(2) - ybounds(1)
set(xlabh,'Position',get(xlabh,'Position') - [0 yext/16 0])
set(figure1, 'PaperPositionMode', 'manual');
set(figure1, 'PaperUnits', 'inches')
set(figure1, 'PaperSize', [11,9])
set(figure1, 'PaperPosition', [0.5,0.5,11,5.0]);
%set(figure1, 'PaperPosition', [0.5,0.5,9,5.8]);
set(gcf, 'InvertHardCopy', 'off');

print('-depsc', strcat(plname,'.eps'));
%print('-dtiff', strcat(plname,'.tiff'));
%close(gcf)
