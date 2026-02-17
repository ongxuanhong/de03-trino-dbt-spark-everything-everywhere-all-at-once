-- Tạo bảng sales (dữ liệu bán hàng mẫu)
CREATE OR REPLACE TABLE sales (
    order_id     INTEGER,
    customer_id  INTEGER,
    product_name VARCHAR,
    category     VARCHAR,
    price        DECIMAL(10,2),
    quantity     INTEGER,
    order_date   DATE,
    region       VARCHAR,
    status       VARCHAR
);

-- Chèn dữ liệu mẫu (10 đơn hàng)
INSERT INTO sales VALUES
(1001, 501, 'Laptop Pro',        'Electronics', 1200.00, 1, '2025-01-15', 'North',   'Completed'),
(1002, 502, 'Wireless Mouse',    'Accessories',   35.50, 3, '2025-01-16', 'South',   'Completed'),
(1003, 503, 'Smartphone X',      'Electronics',  899.99, 1, '2025-02-01', 'North',   'Shipped'),
(1004, 501, 'USB-C Cable',       'Accessories',   12.99, 5, '2025-02-05', 'North',   'Completed'),
(1005, 504, 'Desk Lamp',         'Home',          45.00, 2, '2025-02-10', 'Central', 'Pending'),
(1006, 505, 'Gaming Keyboard',   'Electronics',   89.99, 1, '2025-03-01', 'South',   'Completed'),
(1007, 502, 'Monitor 27"',       'Electronics',  299.00, 1, '2025-03-05', 'South',   'Completed'),
(1008, 506, 'Coffee Mug',        'Home',           8.50,10, '2025-03-10', 'North',   'Completed'),
(1009, 503, 'Bluetooth Speaker', 'Electronics',   79.99, 1, '2025-04-01', 'North',   'Cancelled'),
(1010, 507, 'Notebook Pack',     'Office',        15.00, 4, '2025-04-15', 'Central', 'Completed');

-- Xem dữ liệu vừa chèn
SELECT * FROM sales;


-- Tạo bảng employees (nhân viên mẫu - dùng đơn vị tiền VND cho gần gũi)
CREATE OR REPLACE TABLE employees (
    emp_id      INTEGER PRIMARY KEY,
    first_name  VARCHAR,
    last_name   VARCHAR,
    department  VARCHAR,
    salary      DECIMAL(12,2),   -- lương tháng (VND)
    hire_date   DATE,
    region      VARCHAR
);

-- Chèn dữ liệu nhân viên
INSERT INTO employees VALUES
(1, 'Nguyễn', 'Văn An',   'Sales',      85000000, '2023-05-10', 'North'),
(2, 'Trần',   'Thị Bình', 'Marketing',  72000000, '2024-01-15', 'South'),
(3, 'Lê',     'Văn Cường','Engineering',95000000, '2022-11-20', 'Central'),
(4, 'Phạm',   'Thị Duyên', 'Sales',      68000000, '2025-02-01', 'North'),
(5, 'Hoàng',  'Văn Em',   'HR',         65000000, '2024-06-30', 'South'),
(6, 'Vũ',     'Thị Phương','Engineering',110000000,'2023-03-05', 'Central'),
(7, 'Đặng',   'Văn Giang', 'Finance',    78000000, '2025-01-10', 'North');

-- Xem bảng nhân viên
SELECT * FROM employees;

-- Tổng doanh thu theo category
SELECT 
    category,
    SUM(price * quantity) AS total_revenue,
    COUNT(*) AS num_orders
FROM sales
GROUP BY category
ORDER BY total_revenue DESC;

-- Doanh thu theo tháng + region (dùng window function)
SELECT 
    strftime(order_date, '%Y-%m') AS month,
    region,
    SUM(price * quantity) AS revenue,
    RANK() OVER (PARTITION BY strftime(order_date, '%Y-%m') ORDER BY SUM(price * quantity) DESC) AS rank_in_month
FROM sales
GROUP BY month, region
ORDER BY month, rank_in_month;

-- Join 2 bảng: Ai bán được nhiều nhất (giả sử customer_id = emp_id cho vui)
SELECT 
    e.first_name || ' ' || e.last_name AS employee,
    e.department,
    COUNT(s.order_id) AS orders_count,
    SUM(s.price * s.quantity) AS total_sales
FROM sales s
JOIN employees e ON s.customer_id = e.emp_id   -- join giả lập
GROUP BY e.emp_id, e.first_name, e.last_name, e.department
ORDER BY total_sales DESC;

-- Ghi ra file Parquet để thử export (như bạn hỏi trước)
COPY sales TO 'sales_data.parquet' (FORMAT parquet, COMPRESSION zstd);

-- Đọc lại để kiểm tra
SELECT * FROM 'sales_data.parquet' LIMIT 5;


-- curl -O https://extensions.duckdb.org/v1.4.4/osx_arm64/unity_catalog.duckdb_extension.gz
INSTALL './unity_catalog.duckdb_extension.gz';
install uc_catalog from core_nightly;
load uc_catalog;
install delta;
load delta;

CREATE SECRET (
      TYPE UC,
      TOKEN 'not-used',
      ENDPOINT 'http://127.0.0.1:8080',
      AWS_REGION 'us-east-2'
 );

ATTACH 'unity' AS unity (TYPE UC_CATALOG);
SHOW ALL TABLES;
SELECT * from unity.default.numbers;