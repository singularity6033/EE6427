% QCIF
width  = 176;
height = 144;
nFrame = 150;
% read bitrates under different QPs
bitrate = importdata('bitrate.txt');
% Read the video sequence
[Y_orig,U_orig,V_orig] = yuvRead('football_cif.yuv', width, height ,nFrame);
q_decode_list = ["./decode_yuv/q02d.yuv","./decode_yuv/q03d.yuv",...
    "./decode_yuv/q04d.yuv","./decode_yuv/q05d.yuv",...
    "./decode_yuv/q06d.yuv","./decode_yuv/q07d.yuv",...
    "./decode_yuv/q08d.yuv","./decode_yuv/q09d.yuv",...
    "./decode_yuv/q10d.yuv","./decode_yuv/q11d.yuv",...
    "./decode_yuv/q12d.yuv","./decode_yuv/q13d.yuv",...
    "./decode_yuv/q14d.yuv","./decode_yuv/q15d.yuv",...
    "./decode_yuv/q16d.yuv","./decode_yuv/q17d.yuv",...
    "./decode_yuv/q18d.yuv","./decode_yuv/q19d.yuv",...
    "./decode_yuv/q20d.yuv","./decode_yuv/q21d.yuv"];
b_decode_list =  ["./decode_yuv/b4000d.yuv","./decode_yuv/b3500d.yuv",...
    "./decode_yuv/b3000d.yuv","./decode_yuv/b2500d.yuv",...
    "./decode_yuv/b2000d.yuv"];
[Y,U,V] = yuvRead(b_decode_list(1), width, height ,nFrame);
mean_psnr = zeros(20, 1);
mean_mse = zeros(20, 1);
% calculate psnr and mse with bitrate
for i=1:20
    temp_psnr = 0;
    temp_mse = 0;
    [Y,U,V] = yuvRead(q_decode_list(i), width, height ,nFrame);
    for iFrame = 1:150
        temp_psnr = temp_psnr + psnr(Y_orig(:,:,iFrame), Y(:,:,iFrame));
        temp_mse = temp_mse + immse(Y_orig(:,:,iFrame), Y(:,:,iFrame));
    end
    mean_psnr(i) = temp_psnr / 150;
    mean_mse(i) = temp_mse / 150;
end

figure(1)
plot(bitrate,mean_psnr,'LineWidth',3,'Marker','none');
ylabel('PSNR','Fontname','Times New Roman')
xlabel('Bitrate (kbits/sec)','Fontname','Times New Roman')
title('PSNR-Y against various bitrate with QPs range from 2 to 21',...
    'Fontname','Times New Roman')

figure(2)
plot(bitrate,mean_mse,'LineWidth',3,'Marker','none');
ylabel('MSE','Fontname','Times New Roman')
xlabel('Bitrate (kbits/sec)','Fontname','Times New Roman')
title('MSE-Y against various bitrate with QPs range from 2 to 21',...
    'Fontname','Times New Roman')

mse_no_frame = zeros(5, 150);
for j=1:5
    [Y,U,V] = yuvRead(q_decode_list((j-1)*3 + 1), width, height ,nFrame);
    for iFrame = 1:150
        mse_no_frame(j,iFrame) = immse(Y_orig(:,:,iFrame), Y(:,:,iFrame));
    end
end

no_frames = 1:4:150;
figure(3)
plot(no_frames,mse_no_frame(1,1:4:150),'LineWidth',1.5);
hold on;
plot(no_frames,mse_no_frame(2,1:4:150),'LineWidth',1.5);
hold on;
plot(no_frames,mse_no_frame(3,1:4:150),'LineWidth',1.5);
hold on;
plot(no_frames,mse_no_frame(4,1:4:150),'LineWidth',1.5);
hold on;
plot(no_frames,mse_no_frame(5,1:4:150),'LineWidth',1.5);
hold on;
legend('4328.52kbits/sec','2282.07kbits/sec','1556.27kbits/sec','1198.94kbits/sec',...
    '963.64kbits/sec','Location','northeast');
ylabel('MSE','Fontname','Times New Roman')
xlabel('Frame no.','Fontname','Times New Roman')
title('MSE-Y against frame number','Fontname','Times New Roman')