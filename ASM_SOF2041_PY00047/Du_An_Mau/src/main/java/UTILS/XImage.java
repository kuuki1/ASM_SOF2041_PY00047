/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package UTILS;

import java.awt.Image;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import javax.swing.ImageIcon;

/**
 *
 * @author PHAM TIN
 */
public class XImage {
    
    public static void save(File src) {
        File dir = new File("src\\main\\java\\IMG", src.getName());
        if(isImageFile(dir)) {
            if (!dir.getParentFile().exists()) {
                dir.getParentFile().mkdirs();
            }
            try {
                Path source = Paths.get(src.getAbsolutePath());
                Path destination = Paths.get(dir.getAbsolutePath());
                Files.copy(source, destination, StandardCopyOption.REPLACE_EXISTING);
            } catch (IOException e) {
                throw new RuntimeException(e);
            }
        } else {
            System.out.print("file khong phai la anh.");
        }
        

    }

//    public static ImageIcon read(String filename) {
//        File path = new File("src\\main\\java\\IMG", filename);
//        return new ImageIcon(new ImageIcon(path.getAbsolutePath()).getImage().getScaledInstance(180, 180, Image.SCALE_DEFAULT));
//    }
    
    public static ImageIcon read(String filename) throws IOException {
        File path = new File("src\\main\\java\\IMG", filename);
        // Kiểm tra đuôi file để đảm bảo đó là file ảnh
        if (isImageFile(path)) {
            return new ImageIcon(new ImageIcon(path.getAbsolutePath()).getImage().getScaledInstance(180, 180, Image.SCALE_DEFAULT));
        } else {
            // Nếu file không phải là ảnh, ném ra ngoại lệ
            throw new IOException("File không phải là ảnh: " + filename);
        }
    }

    // Phương thức kiểm tra xem file có phải là ảnh không
    private static boolean isImageFile(File file) {
        String[] imageExtensions = new String[]{"png", "jpg"};
        String fileName = file.getName().toLowerCase();
        for (String extension : imageExtensions) {
            if (fileName.endsWith("." + extension)) {
                return true;
            }
        }
        return false;
    }
}
