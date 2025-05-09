-- 确保API表已创建，如果没有，创建它
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='API' AND xtype='U')
CREATE TABLE API (
    RecordID nvarchar(128) PRIMARY KEY,
    路由 nvarchar(128),
    方法 nvarchar(128),
    模板 nvarchar(4000),
    描述 nvarchar(128),
    鉴权 int DEFAULT 0,  -- 修改为int类型: 0=匿名访问，1=需要鉴权
    CreateUser int DEFAULT 2,
    ReportStatus int DEFAULT 1
);

-- 添加常规API查询模板（需要token鉴权）
INSERT INTO API (RecordID, 路由, 方法, 模板, 描述, 鉴权, CreateUser, ReportStatus)
VALUES ('1', 'users', 'GET', 'SELECT UserID, UserName, LoginName, Tel, Email FROM JU_User WHERE ISActive = 1', '获取所有用户', 1, 2, 1);

-- 添加用户登录查询模板
INSERT INTO API (RecordID, 路由, 方法, 模板, 描述, 鉴权, CreateUser, ReportStatus)
VALUES ('2', 'login', 'POST', 'SELECT UserID, UserName, Password, Salt FROM JU_User WHERE LoginName = ''{{.loginName}}''', '登录查询', 0, 2, 1);

-- 添加微信用户查询模板
INSERT INTO API (RecordID, 路由, 方法, 模板, 描述, 鉴权, CreateUser, ReportStatus)
VALUES ('3', 'wxlogin', 'POST', 'SELECT UserID, UserName FROM JU_User WHERE WeChatOpenID = ''{{.openid}}''', '微信登录查询', 0, 2, 1);

-- 添加版本信息查询API（测试NULL鉴权导致的错误）
INSERT INTO API (RecordID, 路由, 方法, 模板, 描述, 鉴权, CreateUser, ReportStatus)
VALUES ('4', 'ver', 'GET', 'SELECT v FROM JU_VER', '获取版本信息', NULL, 2, 1);
