module seven_seg_controller (
    input clk,
    input rst,
    input water_level,
    input start,
    input [2:0] state,
    output reg [7:0] an,   // Anode (aktif low, memilih digit)
    output reg [6:0] seg   // Cathode (aktif low, memilih segmen a-g)
);

    // Penghitung untuk multiplexing display (sekitar 1 kHz refresh rate)
    reg [19:0] refresh_counter;
    
    always @(posedge clk or posedge rst) begin
        if (rst)
            refresh_counter <= 20'd0;
        else
            refresh_counter <= refresh_counter + 20'd1;
    end
    
    // Menggunakan 3-bit tertinggi sebagai pemilih digit (0 sampai 7)
    wire [2:0] digit_select = refresh_counter[19:17];
    
    // Logika Pemilihan Aktivasi Anode (Aktif Low)
    always @(*) begin
        case(digit_select)
            3'b000: an = 8'b11111110; // Digit 0 (Paling Kanan)
            3'b001: an = 8'b11111101; // Digit 1
            3'b010: an = 8'b11111011; // Digit 2
            3'b011: an = 8'b11110111; // Digit 3
            3'b100: an = 8'b11101111; // Digit 4
            3'b101: an = 8'b11011111; // Digit 5
            3'b110: an = 8'b10111111; // Digit 6
            3'b111: an = 8'b01111111; // Digit 7 (Paling Kiri)
            default: an = 8'b11111111;
        endcase
    end

    // Logika Dekoder Segmen (Aktif Low, 0 = Menyala)
    // Pemetaan segmen: seg[0]=a, seg[1]=b, seg[2]=c, seg[3]=d, seg[4]=e, seg[5]=f, seg[6]=g
    always @(*) begin
        case(digit_select)
            // ---- Bagian Informasi Input ----
            3'b111: seg = 7'b1100011; // Digit 7: Menampilkan huruf 'w' (pendekatan bentuk 'u' kecil)
            3'b110: seg = water_level ? 7'b1111001 : 7'b1000000; // Digit 6: Menampilkan '1' atau '0'
            3'b101: seg = 7'b0010001; // Digit 5: Menampilkan huruf 'y'
            3'b100: seg = start ? 7'b1111001 : 7'b1000000; // Digit 4: Menampilkan '1' atau '0'
            
            // ---- Bagian Teks Tetap "St" ----
            3'b011: seg = 7'b0010010; // Digit 3: Menampilkan huruf 'S'
            3'b010: seg = 7'b0000111; // Digit 2: Menampilkan huruf 't'
            
            // ---- Bagian Karakter Karakter State (XX) ----
            3'b001: begin // Digit 1: Karakter Pertama State (I, G, b, d, d)
                case(state)
                    3'b000: seg = 7'b1111001; // IDLE  -> 'I'
                    3'b001: seg = 7'b1000010; // GRIND -> 'G'
                    3'b010: seg = 7'b0000011; // BREW  -> 'b'
                    3'b011: seg = 7'b0100001; // DRIP  -> 'd'
                    3'b100: seg = 7'b0100001; // DONE  -> 'd'
                    default: seg = 7'b1111111; // Mati
                endcase
            end
            
            3'b000: begin // Digit 0: Karakter Kedua State (d, r, r, r, n)
                case(state)
                    3'b000: seg = 7'b0100001; // IDLE  -> 'd' (Menjadi "Id")
                    3'b001: seg = 7'b0101111; // GRIND -> 'r' (Menjadi "Gr")
                    3'b010: seg = 7'b0101111; // BREW  -> 'r' (Menjadi "br")
                    3'b011: seg = 7'b0101111; // DRIP  -> 'r' (Menjadi "dr")
                    3'b100: seg = 7'b0101011; // DONE  -> 'n' (Menjadi "dn")
                    default: seg = 7'b1111111; // Mati
                endcase
            end
            default: seg = 7'b1111111;
        endcase
    end

endmodule