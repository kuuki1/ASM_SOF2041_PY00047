package DAOS;

import CLASSES.ChuyenDe;
import UTILS.jdbcHelper;
import java.util.ArrayList;
import java.util.List;
import java.sql.*;

public class ChuyenDeDAO extends Dao<ChuyenDe, String> {

    String INSERT_SQL = "INSERT INTO ChuyenDe (MaCD, TenCD, HocPhi, ThoiLuong, Hinh, MoTa) VALUES (?, ?, ?, ?, ?, ?)";
    String UPDATE_SQL = "UPDATE ChuyenDe SET TenCD=?, HocPhi=?, ThoiLuong=?, Hinh=?, MoTa=? WHERE MaCD=?";
    String DELETE_SQL = "DELETE FROM ChuyenDe WHERE MaCD=?";
    String SELECT_ALL_SQL = "SELECT * FROM ChuyenDe";
    String SELECT_BY_ID_SQL = "SELECT * FROM ChuyenDe WHERE MaCD=?";

    @Override
    public void insert(ChuyenDe entity) {
        jdbcHelper.update(INSERT_SQL,
                entity.getMaCD(),
                entity.getTenCD(),
                entity.getHocPhi(),
                entity.getThoiLuong(),
                entity.getHinh(),
                entity.getMoTa());
    }

    @Override
    public void update(ChuyenDe entity) {
        jdbcHelper.update(UPDATE_SQL,
                entity.getTenCD(),
                entity.getHocPhi(),
                entity.getThoiLuong(),
                entity.getHinh(),
                entity.getMoTa(),
                entity.getMaCD());
    }

    @Override
    public void delete(String id) {
        jdbcHelper.update(DELETE_SQL, id);
    }

    @Override
    public ChuyenDe selectByID(String id) {
        List<ChuyenDe> list = this.selectBySql(SELECT_BY_ID_SQL, id);
        if (list.isEmpty()) {
            return null;
        }
        return list.get(0);
    }

    @Override
    public List<ChuyenDe> selectAll() {
        return this.selectBySql(SELECT_ALL_SQL);
    }

    @Override
    public List<ChuyenDe> selectBySql(String sql, Object... args) {
        List<ChuyenDe> list = new ArrayList<>();
        try {
            ResultSet rs = jdbcHelper.query(sql, args);
            while (rs.next()) {
                ChuyenDe entity = new ChuyenDe();
                entity.setMaCD(rs.getString("MaCD"));
                entity.setTenCD(rs.getString("TenCD"));
                entity.setHocPhi(rs.getDouble("HocPhi"));
                entity.setThoiLuong(rs.getInt("ThoiLuong"));
                entity.setHinh(rs.getString("Hinh"));
                entity.setMoTa(rs.getString("MoTa"));
                list.add(entity);
            }
            rs.getStatement().getConnection().close();
            return list;
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
    
    public boolean hasCourses(String maCD) {
        String sql = "SELECT COUNT(*) FROM KhoaHoc WHERE MaCD = ?";
        try (Connection conn = jdbcHelper.getConnection(); 
            PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, maCD);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

}
