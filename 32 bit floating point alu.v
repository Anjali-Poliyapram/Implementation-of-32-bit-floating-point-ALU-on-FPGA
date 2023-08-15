module alu32mux(a,b,s0,s1,s2,s3,s4,s5,cin,result);
input[31:0] a,b;
input s2,s3,s1,s0,s4,s5,cin;
output reg[31:0] result;
wire [31:0]w1,w2,w3;
wire [7:0] d;
wire [22:0] f;
wire g;
shift1 a1(s0,a,w1);
logicunit32bit1 a2 (a,b,s1,s0,w2);
arithmeticunit1 a3(a,b,cin,w3,s0,s1,s2,s3);
always @(a,b,cin,w1,w2,w3,s0,s1,s2,s3,s4,s5)
begin
case({s4,s5})
2'b00:result<= w1;
2'b01:result<=w2;
2'b10:result<=w3;
2'b11:result<=1'bx;
default:result<=1'b0;
endcase
end
assign d=result[30:23];
assign f=result[22:0]; 
assign g=result[31];
always@(d,f)
if (d==8'b11111111)
if (f==1'b0)
if (g==1'b1)
result=32'b1zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz;
else
result =32'b0zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz;
else
result=32'bx;
endmodule
module shift1(s,a,res);
input[31:0] a;
input s;
output reg [31:0]res ;
wire [31:0]w1,w2;
rshift1 r1(a,w1);
lshift1 r2(a,w2);
always @(a,s,w1,w2)
case({s})
1'b0:res<=w1;
1'b1:res<=w2;
endcase
endmodule
module rshift1(a,b);
input[31:0] a;
output[31:0] b;
wire [22:0] Ma,Mb;
assign Ma=a [22:0];
assign Mb=Ma>>1;
assign b = {a [31:23],Mb};
endmodule
module lshift1(a,b);
input[31:0] a;
output [31:0] b;
wire [22:0] Ma,Mb;
assign Ma=a [22:0]; 
assign Mb=Ma<<1;
assign b = {a [31:23],Mb};
endmodule
module logicunit32bit1(a,b,s1,s0,res );
input[31:0] a,b;
input s1,s0;
output reg[31:0] res;
wire[31:0] w1,w2,w3,w4;
and2 a1 (a,b,w1);
or2 a2 (a,b,w2);
not12 a3(a,w3);
exor2 a4(a,b,w4);
always @(a,b,s1,s0,w1,w2,w3,w4)
begin
case({s1,s0})
2'b00:res<= w1;
2'b01:res<=w2;
2'b10:res<=w3;
2'b11:res<=w4;
default:res<=1'b0;
endcase
end
endmodule
module and2(a,b,y);
input[31:0] a,b;
output reg[31:0] y;
reg [22:0]Ma,Mb,Ms;
reg [22:0]My;
reg [7:0]Ea,Eb,E,diff;
reg Sa,Sb,sign;
always@(a,b)
begin
assign Sa= a[31];
assign Sb= b[31];
assign Ea= a[30:23];
assign Eb= b[30:23];
assign Ma= a[22:0]; 
assign Mb= b[22:0];
if(Ea==Eb)
begin
assign E=Ea;
assign My=Ma&Mb;
if(Ma>Mb)
assign sign=Sa;
else if(Ma<Mb)
assign sign=Sb;
else
assign sign=Sa;
end
else if(Ea>Eb)
begin
assign sign=Sa;
assign diff=Ea-Eb;
assign E=Ea;
assign Ms=Mb>>diff;
assign My=Ma&Ms;
end
else
begin
assign sign=Sb;
assign E=Eb;
assign diff=Eb-Ea;
assign Ms=Ma>>diff;
assign My=Ms&Mb;
end
assign y={sign,E,My};
end
endmodule
module or2(a,b,y);
input [31:0]a,b;
output reg [31:0] y;
reg [22:0]Ma,Mb,Ms;
reg [22:0]My;
reg [7:0]Ea,Eb,E,diff; 
reg Sa,Sb,sign;
always@(a,b)
begin
assign Sa= a[31];
assign Sb= b[31];
assign Ea= a[30:23];
assign Eb= b[30:23];
assign Ma= a[22:0];
assign Mb= b[22:0];
if(Ea==Eb)
begin
assign E=Ea;
assign My=Ma|Mb;
if(Ma>Mb)
assign sign=Sa;
else if(Ma<Mb)
assign sign=Sb;
else
assign sign=Sa;
end
else if(Ea>Eb)
begin
assign sign=Sa;
assign diff=Ea-Eb;
assign E=Ea;
assign Ms=Mb>>diff;
assign My=Ma|Ms;
end
else
begin
assign sign=Sb;
assign E=Eb;
assign diff=Eb-Ea;
assign Ms=Ma>>diff;
assign My=Ms|Mb;
end
assign y={sign,E,My}; 
end
endmodule
module not12(c,d);
input [31:0]c;
output [31:0]d;
wire [22:0] Mc,Mb;
assign Mc=c [22:0];
assign Mb=~Mc;
assign d = {c [31:23],Mb};
endmodule
module exor2(a,b,y);
input [31:0]a,b;
output reg[31:0] y;
reg [22:0]Ma,Mb,Ms;
reg [22:0]My;
reg [7:0]Ea,Eb,E,diff;
reg Sa,Sb,sign;
always@(a,b)
begin
assign Sa= a[31];
assign Sb= b[31];
assign Ea= a[30:23];
assign Eb= b[30:23];
assign Ma= a[22:0];
assign Mb= b[22:0];
if(Ea==Eb)
begin
assign E=Ea;
assign My=Ma^Mb;
if(Ma>Mb)
assign sign=Sa;
else if(Ma<Mb)
assign sign=Sb;
else
assign sign=Sa;
end
else if(Ea>Eb) 
begin
assign sign=Sa;
assign diff=Ea-Eb;
assign E=Ea;
assign Ms=Mb>>diff;
assign My=Ma^Ms;
end
else
begin
assign sign=Sb;
assign E=Eb;
assign diff=Eb-Ea;
assign Ms=Ma>>diff;
assign My=Ms^Mb;
end
assign y={sign,E,My};
end
endmodule
module arithmeticunit1(a,b,cin,res,s0,s1,s2,s3);
input [31:0] a,b;
input cin,s0,s1,s2,s3;
output reg[31:0] res;
wire [31:0]w1,w2,w3,w4,w5,w6,w7,w8,w9;
add a1(a,b,w1);
addcarry a2(a,b,cin,w2);
sub a3(a,b,w3);
subcarry a4(a,b,cin,w4);
incremen22 a5(a,w5);
decremen22 a6(a,w6);
trd a7(w7,a);
multi1 a8(a,b,w8);
div1 a9(a,b,w9);
always@(a,b,cin,w1,w2,w3,w4,w5,w6,w7,w8,w9)
begin
case({s0,s1,s2,s3})
4'b0000:res<=w1;
4'b0001:res<=w2; 
4'b0010:res<=w3;
4'b0011:res<=w4;
4'b0100:res<=w5;
4'b0101:res<=w6;
4'b0110:res<=w7;
4'b0111:res<=w8;
4'b1000:res<=w9;
4'b1001:res<=1'bx;
4'b1010:res<=1'bx;
4'b1011:res<=1'bx;
4'b1100:res<=1'bx;
4'b1101:res<=1'bx;
4'b1110:res<=1'bx;
4'b1111:res<=1'bx;
default:res<=1'b0;
endcase
end
endmodule
module add(a,b,y);
input [31:0]a,b;
output reg[31:0] y;
reg [22:0]Ma,Mb,Ms;
reg [22:0]My;
reg [7:0]Ea,Eb,E,diff;
reg Sa,Sb,sign;
always@(a,b)
begin
assign Sa= a[31];
assign Sb= b[31];
assign Ea= a[30:23];
assign Eb= b[30:23];
assign Ma= a[22:0];
assign Mb= b[22:0];
if(Ea==Eb)
begin
assign E=Ea;
assign My=Ma+Mb;
if(Ma>Mb)
assign sign=Sa;
else if(Ma<Mb)
assign sign=Sb;
else
assign sign=Sa;
end
else if(Ea>Eb)
begin
assign sign=Sa;
assign diff=Ea-Eb;
assign E=Ea;
assign Ms=Mb>>diff;
assign My=Ma+Ms;
end
else
begin
assign sign=Sb;
assign E=Eb;
assign diff=Eb-Ea;
assign Ms=Ma>>diff;
assign My=Ms+Mb;
end
assign y={sign,E,My};
end
endmodule
module addcarry(a,b,cin,y);
input [31:0]a,b;
input cin;
output reg[31:0]y;
reg [22:0]Ma,Mb,Ms,c;
reg [23:0]My;
reg [7:0]Ea,Eb,E,diff;
reg Sa,Sb,sign;
always@(a,b)
begin
assign Sa= a[31]; 
assign Sb= b[31];
assign Ea= a[30:23];
assign Eb= b[30:23];
assign Ma= a[22:0];
assign Mb= b[22:0];
assign c= {22'b0,cin};
if(Ea==Eb)
begin
assign E=Ea;
assign My=Ma+Mb+cin;
if(Ma>Mb)
assign sign=Sa;
else if(Ma<Mb)
assign sign=Sb;
else
assign sign=Sa;
end
else if(Ea>Eb)
begin
assign sign=Sa;
assign diff=Ea-Eb;
assign E=Ea;
assign Ms=Mb>>diff;
assign My=Ma+Ms+cin;
end
else
begin
assign sign=Sb;
assign E=Eb;
assign diff=Eb-Ea;
assign Ms=Ma>>diff;
assign My=Ms+Mb+cin;
end
assign y={sign,E,My};
end
endmodule
module sub(a,b,y);
input [31:0]a,b;
output reg[31:0]y;
reg [22:0]Ma,Mb,Ms;
reg [23:0]My;
reg [7:0]Ea,Eb,E,diff;
reg Sa,Sb,sign;
always@(a,b)
begin
assign Sa= a[31];
assign Sb= b[31];
assign Ea= a[30:23];
assign Eb= b[30:23];
assign Ma= a[22:0];
assign Mb= b[22:0];
if(Ea==Eb)
begin
assign E=Ea;
assign My=Ma-Mb;
if(Ma>Mb)
assign sign=Sa;
else if(Ma<Mb)
assign sign=Sb;
else
assign sign=Sa;
end
else if(Ea>Eb)
begin
assign sign=Sa;
assign diff=Ea-Eb;
assign E=Ea;
assign Ms=Mb>>diff;
assign My=Ma-Ms;
end
else
begin
assign sign=Sb;
assign E=Eb; 
assign diff=Eb-Ea;
assign Ms=Ma>>diff;
assign My=Ms-Mb;
end
assign y={sign,E,My};
end
endmodule
module subcarry(a,b,cin,y);
input [31:0]a,b;
input cin;
output reg[31:0]y;
reg [22:0]Ma,Mb,Ms;
reg [23:0]My;
reg [7:0]Ea,Eb,E,diff;
reg Sa,Sb,sign;
always@(a,b)
begin
assign Sa= a[31];
assign Sb= b[31];
assign Ea= a[30:23];
assign Eb= b[30:23];
assign Ma= a[22:0];
assign Mb= b[22:0];
if(Ea==Eb)
begin
assign E=Ea;
assign My=Ma-Mb+cin;
if(Ma>Mb)
assign sign=Sa;
else if(Ma<Mb)
assign sign=Sb;
else
assign sign=Sa;
end
else if(Ea>Eb)
begin
assign sign=Sa; 
assign diff=Ea-Eb;
assign E=Ea;
assign Ms=Mb>>diff;
assign My=Ma-Ms+cin;
end
else
begin
assign sign=Sb;
assign E=Eb;
assign diff=Eb-Ea;
assign Ms=Ma>>diff;
assign My=Ms-Mb+cin;
end
assign y={sign,E,My};
end
endmodule
module incremen22(a,y);
input[31:0] a;
output[31:0] y;
wire [22:0] Ma,My;
assign Ma=a [22:0];
assign My=Ma+1;
assign y = {a [31:23],My};
endmodule
module decremen22(a,y);
input [31:0]a;
output [31:0]y;
wire [22:0] Ma,My;
assign Ma=a [22:0];
assign My=Ma-1;
assign y = {a [31:23],My};
endmodule
module trd(y,a);
input [31:0]a;
output [31:0]y;
assign y=a;
endmodule 
module multi1(a,b,y);
input[31:0] a,b;
output reg[31:0]y;
reg Sa,Sb,S;
reg [7:0]E,Ea,Eb;
reg [44:0]My;
reg [22:0]Ma,Mb;
always@(a,b)
begin
assign Sa=a[31];
assign Sb=b[31];
assign Ea=a [30:23];
assign Eb=b [30:23];
assign Ma=a [22:0];
assign Mb=b [22:0];
assign S=Sa^Sb;
assign E=Ea+Eb;
assign My=Ma*Mb;
assign y={S,E,My[44:22]};
end
endmodule
module div1(a,b,y);
input[31:0] a,b;
output reg[31:0]y;
reg Sa,Sb,S;
reg [7:0]E,Ea,Eb;
reg [44:0]My;
reg [22:0]Ma,Mb;
always@(a,b)
begin
assign Sa=a[31];
assign Sb=b[31];
assign Ea=a [30:23];
assign Eb=b [30:23];
assign Ma=a [22:0];
assign Mb=b [22:0];
assign S=Sa^Sb; 
assign E=Ea-Eb;
assign My=Ma/Mb;
assign y={S,E,My[44:22]};
end
endmodule
