-- C:\ManagementGateway\5.6.2\root\config\database\StrsDesign-sqlserver-5.62.0.sql
-- C:\ManagementGateway\5.6.2\root\config\database\5.62.0\strswebcontent\sqlserver\structure\setup.sql
/* 
* --5.6.2_GA_374
*/

create table Folders (ObjectID varchar(36) not null, ModificationDateTime datetime not null, OwnerID varchar(255) null, CreationDate datetime null, FolderName nvarchar(300) null, Description nvarchar(600) null, ParentID varchar(36) null, primary key (ObjectID));
create table Property (PropertyID varchar(36) not null, ModificationDateTime datetime not null, ResourceVersionID varchar(36) null, AltOwningObjectID varchar(50) null, PropertyName varchar(255) null, PropertyType char(1) not null, PropertyValue nvarchar(400) null, TextPropertyValue ntext null, IntegerPropertyValue int null, ResourceDiscriminatorType varchar(255) null, OwningObjectID varchar(50) null, primary key (PropertyID));
create table RelResourceResources (relResourceResourceID varchar(50) not null, ResourceSelfID varchar(36) not null, ResourceRelatedID varchar(36) not null, ResourceSelfVersionID varchar(36) not null, ResourceRelatedVersionID varchar(36) null, IsHistoricalRelation bit null, primary key (relResourceResourceID));
create table ResourceBinaries (ResourceBinaryID varchar(36) not null, CreationDate datetime null, BinaryData image null, primary key (ResourceBinaryID));
create table ResourceVersions (ResourceVersionID varchar(36) not null, ObjectID varchar(36) null, CreationDate datetime null, ResourceBinaryID varchar(36) null, ResourceDescription nvarchar(600) null, ResourceStoreID varchar(36) null, VersionComment nvarchar(600) null, ContentType varchar(255) null, ByUser varchar(255) null, BinarySize bigint null, VersionCounter bigint null, primary key (ResourceVersionID));
create table Resources (ObjectID varchar(36) not null, ModificationDateTime datetime not null, OwnerID varchar(255) null, CreationDate datetime null, Name nvarchar(300) null, ParentID varchar(36) null, MarkedForDeletion int null, AttentionFlag bit null, DiscriminatorType varchar(10) null, ContentScope varchar(10) null, primary key (ObjectID));
create table Categories(CategoryID varchar(36) not null, Name nvarchar(300) not null UNIQUE, primary key (CategoryID));
create table RelResourceCategories(ResourceID varchar(36) not null, CategoryID varchar(36) not null, primary key(ResourceID, CategoryID), FOREIGN KEY (ResourceID) REFERENCES Resources(ObjectID), FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID));

alter table Folders add constraint FK3A7F09A557CE2BB7 foreign key (ParentID) references Folders;
alter table Property add constraint FKC8A841F5C9688E58 foreign key (OwningObjectID) references RelResourceResources;
alter table Property add constraint FKC8A841F53ABB6C41 foreign key (AltOwningObjectID) references RelResourceResources ON DELETE CASCADE;
alter table Property add constraint FKC8A841F5CA6FED0B foreign key (ResourceVersionID) references ResourceVersions;
alter table RelResourceResources add constraint FKCAF2AA3E2080854A foreign key (ResourceRelatedID) references Resources;
alter table RelResourceResources add constraint FKCAF2AA3E4D7F6A3F foreign key (ResourceSelfVersionID) references ResourceVersions;
alter table RelResourceResources add constraint FKCAF2AA3EB9018A07 foreign key (ResourceSelfID) references Resources;
alter table RelResourceResources add constraint FKCAF2AA3E132ECD9C foreign key (ResourceRelatedVersionID) references ResourceVersions;
alter table ResourceVersions add constraint FKECB2FCE98B072BAC foreign key (ObjectID) references Resources;
alter table ResourceVersions add constraint FKECB2FCE9487F249D foreign key (ResourceBinaryID) references ResourceBinaries;
alter table Resources add constraint FK13EDE0557CE2BB7 foreign key (ParentID) references Folders;
alter table ResourceVersions add constraint IX_RESVER_OBJID_VER UNIQUE(ObjectID,VersionCounter);
GO
-- C:\ManagementGateway\5.6.2\root\config\database\5.62.0\strswebcontent\sqlserver\structure\indexes.sql
/* 
* --5.6.2_GA_374
*/

CREATE INDEX IX_RESVER_OBJID ON ResourceVersions (ObjectID) WITH FILLFACTOR = 80;
CREATE INDEX IX_RESVER_RESOURCEBINARYID ON ResourceVersions (ResourceBinaryID) WITH FILLFACTOR = 80;
CREATE INDEX IX_RESVER_RESOURCESTOREID ON ResourceVersions (ResourceStoreID) WITH FILLFACTOR = 80;
CREATE INDEX IX_RESVER_VERSIONCOUNTER ON ResourceVersions (VersionCounter) WITH FILLFACTOR = 80;
CREATE INDEX IX_RESVER_CREATIONDATE ON ResourceVersions (CreationDate) WITH FILLFACTOR = 80;
CREATE NONCLUSTERED INDEX IX_RESVER_OBJID_RESVERID_VERCOUNT ON ResourceVersions (ObjectID ASC,ResourceVersionID ASC,VersionCounter ASC) WITH FILLFACTOR = 80;

CREATE INDEX IX_PROPERTY_OWNINGOBJECTID ON Property (OwningObjectID) WITH FILLFACTOR = 80;
CREATE INDEX IX_PROPERTY_VERSIONID ON Property (ResourceVersionID) WITH FILLFACTOR = 80;
CREATE INDEX IX_PROPERTY_NAME ON Property (PropertyName) WITH FILLFACTOR = 80;
CREATE INDEX IX_PROPERTY_VERSIONID_NAME ON Property (ResourceVersionID, PropertyName) WITH FILLFACTOR = 80;
CREATE INDEX IX_PROPERTY_NAME_VERSIONID ON Property (PropertyName,ResourceVersionID) WITH FILLFACTOR = 80;
CREATE INDEX IX_PROPERTY_VALUE ON Property (PropertyValue) WITH FILLFACTOR = 80;
CREATE INDEX IX_PROPERTY_NAME_VALUE ON Property (PropertyName, PropertyValue) WITH FILLFACTOR = 80;

CREATE INDEX IX_RESOURCES_DISCRIMINATOR ON Resources (DiscriminatorType) WITH FILLFACTOR = 80;
CREATE INDEX IX_RESOURCES_MFD ON Resources (MarkedForDeletion) WITH FILLFACTOR = 80;
CREATE INDEX IX_RESOURCES_NAME ON Resources (Name) WITH FILLFACTOR = 80;

CREATE INDEX IX_RELRES_RELATEDVERSIONID ON RelResourceResources (ResourceRelatedVersionID) WITH FILLFACTOR = 80;
CREATE INDEX IX_RELRES_SELFVERSIONID ON RelResourceResources (ResourceSelfVersionID) WITH FILLFACTOR = 80;
CREATE INDEX IX_RELRES_SELFID ON RelResourceResources (ResourceSelfID) WITH FILLFACTOR = 80;
CREATE INDEX IX_RELRES_RELATEDID ON RelResourceResources (ResourceRelatedID) WITH FILLFACTOR = 80;
CREATE INDEX IX_RELRES_SELF_SVERSION ON RelResourceResources (ResourceSelfID,ResourceSelfVersionID) WITH FILLFACTOR = 80;
CREATE INDEX IX_RELRES_RELATED_RVERSION ON RelResourceResources (ResourceRelatedID,ResourceRelatedVersionID) WITH FILLFACTOR= 80;
GO
-- C:\ManagementGateway\5.6.2\root\config\database\5.62.0\strswebcontent\sqlserver\structure\acegi-acl-mssql.sql
/* 
* --5.6.2_GA_374
*/



CREATE TABLE ACL_SID
(
	ID BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	PRINCIPAL BIT NOT NULL,
	SID VARCHAR(100) NOT NULL,
	CONSTRAINT UNIQUE_UK_1 UNIQUE(SID,PRINCIPAL)
);
CREATE TABLE ACL_CLASS
(
	ID BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	CLASS VARCHAR(100) NOT NULL,
	CONSTRAINT UNIQUE_UK_2 UNIQUE(CLASS)
);
CREATE TABLE ACL_OBJECT_IDENTITY
(
	ID BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	OBJECT_ID_CLASS BIGINT NOT NULL,
	OBJECT_ID_IDENTITY VARCHAR(100) NOT NULL,
	PARENT_OBJECT BIGINT,
	OWNER_SID BIGINT,
	ENTRIES_INHERITING BIT NOT NULL,
	CONSTRAINT UNIQUE_UK_3 UNIQUE(OBJECT_ID_CLASS,OBJECT_ID_IDENTITY),
	CONSTRAINT FOREIGN_FK_1 FOREIGN KEY(PARENT_OBJECT)REFERENCES ACL_OBJECT_IDENTITY(ID),
	CONSTRAINT FOREIGN_FK_2 FOREIGN KEY(OBJECT_ID_CLASS)REFERENCES ACL_CLASS(ID),
	CONSTRAINT FOREIGN_FK_3 FOREIGN KEY(OWNER_SID)REFERENCES ACL_SID(ID)
);
CREATE TABLE ACL_ENTRY
(
	ID BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	ACL_OBJECT_IDENTITY BIGINT NOT NULL,
	ACE_ORDER INT NOT NULL,SID BIGINT NOT NULL,
	MASK INT NOT NULL,
	GRANTING BIT NOT NULL,
	AUDIT_SUCCESS BIT NOT NULL,
	AUDIT_FAILURE BIT NOT NULL,
	CONSTRAINT UNIQUE_UK_4 UNIQUE(ACL_OBJECT_IDENTITY,ACE_ORDER),
	CONSTRAINT FOREIGN_FK_4 FOREIGN KEY(ACL_OBJECT_IDENTITY) REFERENCES ACL_OBJECT_IDENTITY(ID),
	CONSTRAINT FOREIGN_FK_5 FOREIGN KEY(SID) REFERENCES ACL_SID(ID)
);

/* ACL tables */
CREATE INDEX index_acl_obj_identity ON ACL_ENTRY (ACL_OBJECT_IDENTITY) WITH FILLFACTOR = 80;
CREATE UNIQUE INDEX index_acl_object_id_identity ON ACL_OBJECT_IDENTITY (OBJECT_ID_IDENTITY) WITH FILLFACTOR = 80;
CREATE INDEX index_acl_parent_object ON ACL_OBJECT_IDENTITY (PARENT_OBJECT) WITH FILLFACTOR = 80;
CREATE INDEX index_acl_owner_sid ON ACL_OBJECT_IDENTITY (OWNER_SID) WITH FILLFACTOR = 80;
CREATE INDEX index_acl_object_id_class ON ACL_OBJECT_IDENTITY (OBJECT_ID_CLASS) WITH FILLFACTOR = 80;
GO
-- C:\ManagementGateway\5.6.2\root\config\database\5.62.0\strswebcontent\sqlserver\data\schemaversionportal.sql
/* 
* --5.6.2_GA_374
*/

/* Schemaversion script for streamserve database */
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SchemaVersion]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SchemaVersion](
	[SchemaVersionID] [varchar](50) NOT NULL,
	[Version] [int] NOT NULL,
	[Major] [int] NOT NULL,
	[Revision] [int] NOT NULL,
	[Build] [varchar](50) NULL,
	[Description] [varchar](50) NOT NULL,
	[CreationDate] [datetime] NOT NULL,
 CONSTRAINT [PK_SchemaVersion] PRIMARY KEY NONCLUSTERED 
(
	[SchemaVersionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/*** SCHEMA VERSION ***/
DECLARE @version INT
DECLARE @major   INT
DECLARE @minor   INT
DECLARE @build  VARCHAR(50)
DECLARE @currentversion INT
DECLARE @currentmajor   INT
DECLARE @currentminor   INT
DECLARE @currentbuild  VARCHAR(50)
SET @version = 5
SET @major   = 62
SET @minor   = 0
SET @build = '5.6.2_GA_374'
SELECT TOP 1 @currentversion = Version,@currentmajor = Major, @currentminor = Revision, @currentbuild = Build
FROM SchemaVersion

IF 0 = (SELECT COUNT(*) FROM SchemaVersion)
BEGIN

	INSERT INTO SchemaVersion (SchemaVersionID,Version,Major,Revision,Build,Description,CreationDate)
	VALUES('StrsDesign',@version,@major,@minor,@build,'StreamStudio Design Model',getutcdate())

		
END
ELSE 
BEGIN
RAISERROR ('WARNING Database not empty! Installing version %d.%d.%d build: %s, actual version: %d.%d.%d build: %s',
	16,1,@version,@major,@minor,@build,@currentversion,@currentmajor,@currentminor,@currentbuild )
END
GO
-- C:\ManagementGateway\5.6.2\root\config\database\5.62.0\strswebcontent\sqlserver\security\sqlserver_createuser.sql
/* 
* --5.6.2_GA_374
*/

DECLARE @UserName NVARCHAR(255)

SET @UserName = 'EBILL_strsWebContent'

IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE type_desc = 'SQL_LOGIN' AND name=@UserName)
BEGIN
	exec sp_addlogin @UserName,'Mcgwire3'
END

IF NOT @UserName='sa'
BEGIN
  IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE type_desc = 'SQL_USER' AND name =@UserName)
  BEGIN
	exec sp_grantdbaccess @UserName,@UserName
	exec sp_addrolemember 'db_datareader',@UserName
	exec sp_addrolemember 'db_datawriter',@UserName
	exec sp_addrolemember 'db_ddladmin',@UserName
  END
END
GO
