/* Given two points on the screen this module draws a line between
 * those two points by coloring necessary pixels
 *
 * Inputs:
 *   clk    - should be connected to a 50 MHz clock
 *   reset  - resets the module and starts over the drawing process
 *	 x0 	- x coordinate of the first end point
 *   y0 	- y coordinate of the first end point
 *   x1 	- x coordinate of the second end point
 *   y1 	- y coordinate of the second end point
 *
 * Outputs:
 *   x 		- x coordinate of the pixel to color
 *   y 		- y coordinate of the pixel to color
 *   done	- flag that line has finished drawing
 *
 */
module line_drawer(clk, reset, x0, y0, x1, y1, x, y, done);
	input logic clk, reset;
	input logic [10:0]	x0, y0, x1, y1;
	output logic done;
	output logic [10:0]	x, y;
	
	/* You'll need to create some registers to keep track of things
	 * such as error and direction.
	 */
	logic signed [11:0] error, error_2;  // example - feel free to change/delete
	logic signed [1:0] y_step, x_step;
	logic [10:0] delta_x, delta_y;
	logic is_steep;
	
	assign x_step = (x0 <= x1) ? 1 : -1;
	assign delta_x = (x0 <= x1) ? (x1 - x0) : (x0 - x1);
	assign y_step = (y0 <= y1) ? 1 : -1;
	assign delta_y = (y0 <= y1) ? (y1 - y0) : (y0 - y1);
	assign is_steep = (delta_y > delta_x) ? 1 : 0;

	always_ff @(posedge clk) begin
		if (reset) begin
			x <= x0;
			y <= y0;
			error <= delta_x + delta_y;
			done <= 1'b0;
		end else begin
			if (~is_steep) begin
				if (x >= x1) done <= 1'b1; 
				else begin
					error_2 <= 2 * error;
					if (error_2 >= delta_y) begin
						error <= error + delta_y;
						x <= x + x_step;
					end
					if (error_2 <= delta_x) begin
						error <= error + delta_x;
						y <= y + y_step;
					end
				end
			end
		end
	end  // always_ff
	
endmodule  // line_drawer