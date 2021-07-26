module testbench ();
reg [511:0] noisy [511:0];
reg [8:0] neighbors [7:0][2:0];
reg [511:0] y_old [511:0];
reg [511:0] y [511:0];
initial begin 
	MRF_denoise();
end

task MRF_denoise; // just for 512*512
	real sum,a,b;

	integer i,j,temp;
	integer fp_r,fp_w;
	begin
		i=0;
		j=0;
		//#start = load noisy data from file
		$readmemb("../data/Txt/noisyDataMem.txt",noisy);
		$readmemb("../data/Txt/noisyDataMem.txt",y_old);
		for (i=0;i<512;i=i+1)
			for(j=0;j<512;j=j+1)
				y[i][j] = 0;

		SNR(sum);

		while (sum>0.01)
		begin 
			$display(sum);
			for (i = 0; i < 512; i=i+1) begin
				for (j = 0; j < 512; j=j+1) begin
					neighbor(i,j);
					#2
					cost(noisy[i][j],a,b);
					$display("%0t - i:%0d,j = %0d", $time,i,j);
					#1
					if (a>b) begin
						y[i][j]=1;
					end
					else begin 
						y[i][j]=0;
					end
				end
			end

			for (i = 0; i < 512; i=i+1) begin
				for (j = 0; j < 512; j=j+1) begin
					y_old[i][j] = y[i][j];
				end
			end

			SNR(sum);
			$display(sum);
		end
		$display(sum);

		//#start = save y_old;
		fp_w = $fopen("../data/Txt/denoisedDatawithV.txt", "w");
		for (i = 0; i < 512; i=i+1) begin
			for (j = 0; j < 512; j=j+1) begin
				if (j == 511) begin
					$fwrite(fp_w, "%0d\n", y[i][j]);
				end
				else begin 
					$fwrite(fp_w, "%0d,", y[i][j]);
				end
			end
		end
		$fclose(fp_w);
		//#end = save y_old;
		$finish;
	end
endtask

task SNR;
	output sum;
 	real sum;
 	integer num1,num2,tempans;
 	integer i,j;
 	begin
 		
 		i = 0;
 		j=0;
 		sum = 0;
 		for (i = 0; i < 512; i = i+1) begin
			for (j = 0 ; j < 512; j = j+1 ) begin
				num1 = y_old[i][j];
				num2 = y[i][j];

				tempans = num1 - num2;
				if (tempans < 0) begin
					tempans = tempans * -1;
				end
				sum = sum + tempans;
			end
		end
		sum = sum / 262144;
 	end
endtask

task neighbor;
	input [8:0] i,j;
	integer a,b;
	begin 
		for (a = 0; a < 8; a= a+1) begin
			for (b = 0; b < 2; b= b+1) begin
				neighbors[a][b] = 1'dx;
			end
		end
		if (i == 1'd0 && j == 1'd0) begin
			neighbors[0][0] = 1'd0;
			neighbors[0][1] = 1'd1;
			neighbors[1][0] = 1'd1;
			neighbors[1][1] = 1'd0;
		end
		else if (i == 1'd0 && j == 511) begin
			neighbors[0][0] = 1'd0;
			neighbors[0][1] = 510;
			neighbors[1][0] = 1'd1;
			neighbors[1][1] = 511;
		end
		else if (i == 511 && j == 0) begin
			neighbors[0][0] = 511;
			neighbors[0][1] = 1;
			neighbors[1][0] = 510;
			neighbors[1][1] = 0;
		end
		else if (i == 511 && j == 511) begin
			neighbors[0][0] = 511;
			neighbors[0][1] = 510;
			neighbors[1][0] = 510;
			neighbors[1][1] = 511;
		end
		else if (i == 0) begin
			neighbors[0][0] = 0;
			neighbors[0][1] = j-1;
			neighbors[1][0] = 0;
			neighbors[1][1] = j+1;
			neighbors[2][0] = 1;
			neighbors[2][1] = j;
		end
		else if (i == 511) begin
			neighbors[0][0] = 511;
			neighbors[0][1] = j-1;
			neighbors[1][0] = 511;
			neighbors[1][1] = j+1;
			neighbors[2][0] = 510;
			neighbors[2][1] = j;
		end
		else if (j == 0) begin
			neighbors[0][0] = i-1;
			neighbors[0][1] = 0;
			neighbors[1][0] = i+1;
			neighbors[1][1] = 0;
			neighbors[2][0] = i;
			neighbors[2][1] = 1;
		end
		else if (j == 511) begin
			neighbors[0][0] = i-1;
			neighbors[0][1] = 511;
			neighbors[1][0] = i+1;
			neighbors[1][1] = 511;
			neighbors[2][0] = i;
			neighbors[2][1] = 510;
		end
		else begin
			neighbors[0][0] = i-1;
			neighbors[0][1] = j;
			neighbors[1][0] = i+1;
			neighbors[1][1] = j;
			neighbors[2][0] = i;
			neighbors[2][1] = j-1;
			neighbors[3][0] = i;
			neighbors[3][1] = j+1;
			neighbors[4][0] = i-1;
			neighbors[4][1] = j-1;
			neighbors[5][0] = i-1;
			neighbors[5][1] = j+1;
			neighbors[6][0] = i+1;
			neighbors[6][1] = j-1;
			neighbors[7][0] = i+1;
			neighbors[7][1] = j+1;
		end

	end
endtask

task cost;
	input [9:0]x;
	output asum,bsum;
	real asum,bsum;
	reg y;
	integer i,alpha,beta;
	begin
		y = 1;
		alpha = 1;
		beta = 10;
		asum = 0;
		bsum =0;
			

		for (i = 0; i < 8; i = i+1) begin
			if (neighbors[i][0][0]!==1'dx ) begin
				asum = asum + delta(y,y_old[ neighbors[i][0] ][ neighbors[i][1] ] );
			end
		end
		asum = alpha*delta(y,x)+beta*asum;

		y=0;
		for (i = 0; i < 8; i = i+1) begin
			if (neighbors[i][0][0]!==1'dx ) begin
				bsum = bsum + delta(y,y_old[ neighbors[i][0] ][ neighbors[i][1] ] );
			end
		end
		bsum = alpha*delta(y,x)+beta*bsum;
	end
endtask

function delta;
	input [9:0] a,b;
	begin 
		if (a==b) begin
			delta = 1'b1;
		end
		else begin 
			delta = 1'b0;
		end
	end
endfunction


endmodule