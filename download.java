// DownloadFile.java
import java.io.IOException;
import java.net.URL;
import java.nio.channels.Channels;
import java.nio.channels.ReadableByteChannel;
import java.nio.channels.WritableByteChannel; // Import WritableByteChannel

public class DownloadFile {

    public static void main(String[] args) {
        // Check if the correct number of arguments are provided (only URL is needed now)
        if (args.length != 1) {
            System.err.println("Usage: java DownloadFile <URL>"); // Use System.err for usage
            return; // Exit if arguments are incorrect
        }

        String fileURL = args[0]; // Get the URL from the first argument

        System.err.println("Attempting to download " + fileURL + " to standard output..."); // Inform user on stderr

        try {
            // Create a URL object from the provided URL string
            URL url = new URL(fileURL);
            // Open a readable byte channel from the URL's input stream
            ReadableByteChannel readableByteChannel = Channels.newChannel(url.openStream());

            // Get a WritableByteChannel for standard output
            // System.out is an OutputStream, which when wrapped with Channels.newChannel, provides a WritableByteChannel
            WritableByteChannel writableByteChannel = Channels.newChannel(System.out);

            // Transfer all bytes from the readableByteChannel (input stream) to the writableByteChannel (standard output)
            readableByteChannel.transferTo(0, Long.MAX_VALUE, writableByteChannel);


            // Close the input stream channel
            readableByteChannel.close();
            // Note: System.out's channel does not typically need to be explicitly closed here,
            // as it's managed by the JVM's lifecycle for standard streams.

        } catch (IOException e) {
            // Catch any IOException that occurs during the download process
            System.err.println("An error occurred during download: " + e.getMessage());
            e.printStackTrace(); // Print the stack trace for detailed debugging
        } catch (Exception e) {
            // Catch any other unexpected exceptions
            System.err.println("An unexpected error occurred: " + e.getMessage());
            e.printStackTrace(); // Print the stack trace
        }
    }
}
