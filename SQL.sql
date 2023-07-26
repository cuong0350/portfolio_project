# Tìm ra nam nhân viên có mức lương cao nhất
select HONV, TENLOT, TENNV, LUONG from TC_NHANVIEN
where LUONG = (select max(LUONG) from TC_NHANVIEN where PHAI = 'Nam')

# Tìm ra đề án có tổng thời gian làm việc lớn nhất
select n.TENDA, sum(m.THOIGIAN) as Tong_thoi_gian from TC_DEAN n
inner join TC_PHANCONG m on n.MADA = m.MADA
group by n.TENDA 
having Tong_thoi_gian = 
	(select sum(THOIGIAN) from TC_PHANCONG group by MADA
	order by sum(THOIGIAN) desc limit 1)

# Tìm ra nhân viên làm việc trong nhiều dự án nhất
select n.HONV, n.TENLOT, n.TENNV, count(m.MA_NVIEN) as Tong_du_an from TC_NHANVIEN n
inner join TC_PHANCONG m on n.MANV = m.MA_NVIEN
group by n.MANV
having Tong_du_an = 
	(select count(MA_NVIEN) from TC_PHANCONG group by MADA
	order by count(MA_NVIEN) desc limit 1)

# Cho biết tên các đề án đang có tổng thời gian làm việc nhiều hơn mức trung bình của tất cả các dự án
select n.TENDA, sum(m.THOIGIAN) from TC_DEAN n
inner join TC_PHANCONG m on n.MADA = m.MADA
group by n.TENDA having sum(m.THOIGIAN) > 
(select sum(THOIGIAN)/count(distinct(MADA)) as Thoi_gian_trung_binh from TC_PHANCONG)

# Cho biết họ tên nhân viên (HONV, TENLOT, TENNV) nữ có mức lương lớn hơn mức lương tối đa hiện có của nhân viên nam
select HONV, TENLOT, TENNV, LUONG from TC_NHANVIEN  
where PHAI = 'Nữ' and LUONG > 
	(select max(LUONG) from TC_NHANVIEN where PHAI = 'Nam')

# Cho biết họ tên nhân viên (HONV, TENLOT, TENNV) có mức lương trên mức lương trung bình của phòng "Nghiên cứu" 
select n.HONV, n.TENLOT, n.TENNV, n.LUONG from TC_NHANVIEN n
inner join TC_PHONGBAN m on n.PHG = m.MAPHG
where m.TENPHG = 'Nghiên cứu' and n.LUONG > 
	(select avg(LUONG) from TC_NHANVIEN n
	inner join TC_PHONGBAN m on n.PHG = m.MAPHG
	where m.TENPHG = 'Nghiên cứu')

# Cho biết tên phòng ban và họ tên trưởng phòng của phòng ban có đông nhân viên nhất. 
select b.HONV, b.TENLOT,b.TENNV, b.PHG, n.TENPHG from TC_NHANVIEN b
inner join TC_PHONGBAN n on b.MANV = n.TRPHG
where b.PHG = (
	select b.PHG from TC_NHANVIEN b group by b.PHG
	order by count(b.PHG) desc limit 1)
