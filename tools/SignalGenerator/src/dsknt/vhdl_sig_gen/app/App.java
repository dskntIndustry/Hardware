/**
 * 
 */
package dsknt.vhdl_sig_gen.app;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.PrintWriter;

/**
 * @author dsknt
 *
 */
public class App
{

	/**
	 * @param args
	 */
	public static void main(String[] args)
	{
		String type = args[0];
		int amplitude_bit_number = Integer.parseInt(args[1]);
		int steps = Integer.parseInt(args[2]);
		int frequency = Integer.parseInt(args[3]);
		int phase0 = Integer.parseInt(args[4]);
		int sampling_rate = Integer.parseInt(args[5]);
		System.out.println("Type : "+type);
		System.out.println("Amplitude bit number : "+amplitude_bit_number);
		System.out.println("Number of samples : "+steps);
		System.out.println("Frequency : "+frequency);
		System.out.println("Initial phase : "+phase0);
		System.out.println("Sampling rate : "+sampling_rate);
		
		switch(type.toLowerCase())
		{
		case "sine":
			try
			{
				PrintWriter pw = new PrintWriter(new File("sine"));
				for(int step = 0; step < steps; step++)
				{
					pw.println((int)(Math.pow(2, amplitude_bit_number)*Math.sin(Math.PI*frequency/sampling_rate*step + phase0)));
				}
				pw.close();
			}
			catch(FileNotFoundException e)
			{
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

			break;

		default:
			System.out.println("Invalid waveform type...");
			break;
		}
	}

}
