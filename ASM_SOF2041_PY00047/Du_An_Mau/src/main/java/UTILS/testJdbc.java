/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package UTILS;

import CLASSES.ChuyenDe;
import CLASSES.HocVien;
import CLASSES.KhoaHoc;
import CLASSES.NguoiHoc;
import CLASSES.NhanVien;
import DAOS.ChuyenDeDAO;
import DAOS.HocVienDAO;
import DAOS.KhoaHocDAO;
import DAOS.NguoiHocDAO;
import DAOS.NhanVienDAO;
import DAOS.ThongKeDAO;
import java.util.List;

/**
 *
 * @author PHAM TIN
 */
public class testJdbc {
    public static void main(String[] args){
        NhanVienDAO dao = new NhanVienDAO();
        List<NhanVien> ls = dao.selectAll();
        for (NhanVien nv : ls){
            System.out.println("-"+nv.toString());
        }
        System.out.println(" ");
        NguoiHocDAO nh = new NguoiHocDAO();
        List<NguoiHoc> NH = nh.selectAll();
        for (NguoiHoc nv : NH){
            System.out.println("-"+nv.toString());
        }
        System.out.println(" ");
        KhoaHocDAO kh = new KhoaHocDAO();
        List<KhoaHoc> KH = kh.selectAll();
        for (KhoaHoc nv : KH){
            System.out.println("-"+nv.toString());
        }
        System.out.println(" ");
        HocVienDAO hv = new HocVienDAO();
        List<HocVien> HV = hv.selectAll();
        for (HocVien nv : HV){
            System.out.println("-"+nv.toString());
        }
        System.out.println(" ");
        ChuyenDeDAO cd = new ChuyenDeDAO();
        List<ChuyenDe> CD = cd.selectAll();
        for (ChuyenDe nv : CD){
            System.out.println("-"+nv.toString());
        }
        System.out.println(" ");
        ThongKeDAO tk = new ThongKeDAO();
        System.out.println(tk.getDiemChuyenDe());
    }
}
