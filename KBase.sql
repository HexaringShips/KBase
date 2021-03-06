USE [master]
GO
/****** Object:  Database [KBase]    Script Date: 19-08-2017 09:02:58 PM ******/
CREATE DATABASE [KBase]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'KBase', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.SQLEXPRESS\MSSQL\DATA\KBase.mdf' , SIZE = 3136KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'KBase_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.SQLEXPRESS\MSSQL\DATA\KBase_log.ldf' , SIZE = 1344KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [KBase] SET COMPATIBILITY_LEVEL = 120
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [KBase].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [KBase] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [KBase] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [KBase] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [KBase] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [KBase] SET ARITHABORT OFF 
GO
ALTER DATABASE [KBase] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [KBase] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [KBase] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [KBase] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [KBase] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [KBase] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [KBase] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [KBase] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [KBase] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [KBase] SET  DISABLE_BROKER 
GO
ALTER DATABASE [KBase] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [KBase] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [KBase] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [KBase] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [KBase] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [KBase] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [KBase] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [KBase] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [KBase] SET  MULTI_USER 
GO
ALTER DATABASE [KBase] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [KBase] SET DB_CHAINING OFF 
GO
ALTER DATABASE [KBase] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [KBase] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [KBase] SET DELAYED_DURABILITY = DISABLED 
GO
USE [KBase]
GO
/****** Object:  Table [dbo].[KB_MASTER_ATTACHMENTS]    Script Date: 19-08-2017 09:02:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[KB_MASTER_ATTACHMENTS](
	[AttachmentId] [int] IDENTITY(1,1) NOT NULL,
	[AttachmentPath] [nvarchar](200) NOT NULL,
	[IncidentId] [int] NOT NULL,
	[CreatedDate] [datetime] NULL,
	[UpdatedDate] [datetime] NULL,
 CONSTRAINT [PK_KB_MASTER_ATTACHMENTS] PRIMARY KEY CLUSTERED 
(
	[AttachmentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[KB_MASTER_INCIDENT]    Script Date: 19-08-2017 09:02:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[KB_MASTER_INCIDENT](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](100) NOT NULL,
	[Description] [nvarchar](500) NOT NULL,
	[Comments] [nvarchar](200) NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[UpdatedDate] [datetime] NULL,
	[UpdatedBy] [int] NULL,
	[Status] [int] NOT NULL,
	[Keywords] [nvarchar](500) NULL,
	[AttachmentPath] [nvarchar](200) NULL,
 CONSTRAINT [PK_KB_MASTER_INCIDENT] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[KB_MASTER_KEYWORDS]    Script Date: 19-08-2017 09:02:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[KB_MASTER_KEYWORDS](
	[KeyId] [int] IDENTITY(1,1) NOT NULL,
	[Keyword] [nvarchar](100) NOT NULL,
	[IncidentId] [int] NOT NULL,
	[CreatedDate] [datetime] NULL,
	[UpdatedDate] [datetime] NULL,
 CONSTRAINT [PK_KB_MASTER_KEYWORDS] PRIMARY KEY CLUSTERED 
(
	[KeyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[KB_MASTER_ATTACHMENTS]  WITH CHECK ADD  CONSTRAINT [FK_KB_MASTER_INCIDENTS_KB_MASTER_ATTACHMENTS] FOREIGN KEY([IncidentId])
REFERENCES [dbo].[KB_MASTER_INCIDENT] ([Id])
GO
ALTER TABLE [dbo].[KB_MASTER_ATTACHMENTS] CHECK CONSTRAINT [FK_KB_MASTER_INCIDENTS_KB_MASTER_ATTACHMENTS]
GO
ALTER TABLE [dbo].[KB_MASTER_KEYWORDS]  WITH CHECK ADD  CONSTRAINT [FK_KB_MASTER_INCIDENT_KB_MASTER_KEYWORDS] FOREIGN KEY([IncidentId])
REFERENCES [dbo].[KB_MASTER_INCIDENT] ([Id])
GO
ALTER TABLE [dbo].[KB_MASTER_KEYWORDS] CHECK CONSTRAINT [FK_KB_MASTER_INCIDENT_KB_MASTER_KEYWORDS]
GO
/****** Object:  StoredProcedure [dbo].[Sp_GetIncidentsAndDetailsById]    Script Date: 19-08-2017 09:02:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		N Gopi Krishna
-- Create date: 07-Aug-2017
-- Description:	Get Incidents by Id
-- =============================================
CREATE PROCEDURE [dbo].[Sp_GetIncidentsAndDetailsById] 
	@Id INT = 0
AS
BEGIN
	IF(@Id = 0)
	BEGIN
		SELECT inc.Id,inc.Title,inc.[Description],inc.Comments,inc.[Status],att.AttachmentId,att.AttachmentPath
			,kw.KeyId,kw.Keyword
		FROM KB_MASTER_INCIDENT inc 
			INNER JOIN KB_MASTER_ATTACHMENTS att ON inc.Id = att.IncidentId
			INNER JOIN KB_MASTER_KEYWORDS kw ON inc.Id = kw.IncidentId
	END
	ELSE
	BEGIN
		SELECT inc.Id,inc.Title,inc.[Description],inc.Comments,inc.[Status],att.AttachmentId,att.AttachmentPath
			,kw.KeyId,kw.Keyword
		FROM KB_MASTER_INCIDENT inc 
			INNER JOIN KB_MASTER_ATTACHMENTS att ON inc.Id = att.IncidentId
			INNER JOIN KB_MASTER_KEYWORDS kw ON inc.Id = kw.IncidentId
		WHERE inc.Id = @Id
	END
END


GO
/****** Object:  StoredProcedure [dbo].[SP_GetIncidentsByKeyword]    Script Date: 19-08-2017 09:02:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		N Gopi Krishna
-- Create date: 07-Aug-2017
-- Description:	Get Incidents based on keyword search
-- =============================================
CREATE PROCEDURE [dbo].[SP_GetIncidentsByKeyword]
	@Keyword NVARCHAR(100)
AS
BEGIN
	SELECT inc.Id,inc.Title,inc.[Description],inc.Comments,inc.[Status],att.AttachmentId,att.AttachmentPath
		,kw.KeyId,kw.Keyword
	FROM KB_MASTER_INCIDENT inc 
		INNER JOIN KB_MASTER_ATTACHMENTS att ON inc.Id = att.IncidentId
		INNER JOIN KB_MASTER_KEYWORDS kw ON inc.Id = kw.IncidentId
	WHERE kw.Keyword like '%'+@Keyword+'%'
END


GO
/****** Object:  StoredProcedure [dbo].[SP_Save_Incident]    Script Date: 19-08-2017 09:02:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		N Gopi Krishna
-- Create date: 07-Aug-2017
-- Description:	Insert Incident, Keyword, Attachment
-- =============================================
CREATE PROCEDURE [dbo].[SP_Save_Incident] 
	-- Add the parameters for the stored procedure here
	@Id INT = 0,
	@Title NVARCHAR(100),
	@Description NVARCHAR(500),
	@Comments NVARCHAR(200),
	@UserId INT,
	@Status BIT,
	@AttachmentPath NVARCHAR(200),
	@Keyword NVARCHAR(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	IF(@Id = 0)
	BEGIN
		-- Insert statements for procedure here
		INSERT INTO KB_MASTER_INCIDENT
		([Title],[Description],[Comments],[CreatedDate],[CreatedBy],[Status])
			VALUES
		(@Title,@Description,@Comments,GETDATE(),@UserId,@Status)

		DECLARE @IncidentId INT
		SET @IncidentId = SCOPE_IDENTITY()

		IF(ISNULL(@AttachmentPath,'') <> '')
		BEGIN
			INSERT INTO KB_MASTER_ATTACHMENTS
			(AttachmentPath,IncidentId,CreatedDate)
				VALUES
			(@AttachmentPath,@IncidentId,GETDATE())
		END

		IF(ISNULL(@Keyword,'')<>'')
		BEGIN
			INSERT INTO KB_MASTER_KEYWORDS
			(Keyword,IncidentId,CreatedDate)
				VALUES
			(@Keyword,@IncidentId,GETDATE())
		END
	END
	ELSE
	BEGIN
		UPDATE KB_MASTER_INCIDENT
			SET Title = @Title,
				[Description] = @Description,
				[Comments] = @Comments,
				[UpdatedDate] = GETDATE(),
				[UpdatedBy]=@UserId,
				[Status]=@Status
		WHERE Id = @Id
		IF(ISNULL(@AttachmentPath,'') <> '')
		BEGIN
			UPDATE KB_MASTER_ATTACHMENTS
				SET AttachmentPath = @AttachmentPath,
					UpdatedDate=GETDATE()
			WHERE IncidentId = @Id
		END
		IF(ISNULL(@Keyword,'')<>'')
		BEGIN
			UPDATE KB_MASTER_KEYWORDS
				SET Keyword = @Keyword,
					UpdatedDate=GETDATE()
			WHERE IncidentId = @Id
		END
	END
END


GO
USE [master]
GO
ALTER DATABASE [KBase] SET  READ_WRITE 
GO
