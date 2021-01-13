# Что делать если WSUS давно не обновляли
Навеяно статьей: https://habr.com/ru/post/329440/ - по ней сделать не получилось, убил 3 дня, в итоге обошелся шагами приведенными ниже

1. Проверяем чтобы у учтеки был админский доступ в базу (локальная группа WSUS administrators)
2. Проверяем фрагментиацию базы:
```
SELECT S.name as 'Schema',
T.name as 'Table',
I.name as 'Index',
DDIPS.avg_fragmentation_in_percent,
DDIPS.page_count
FROM sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL, NULL, NULL) AS DDIPS
INNER JOIN sys.tables T on T.object_id = DDIPS.object_id
INNER JOIN sys.schemas S on T.schema_id = S.schema_id
INNER JOIN sys.indexes I ON I.object_id = DDIPS.object_id
AND DDIPS.index_id = I.index_id
WHERE DDIPS.database_id = DB_ID()
and I.name is not null
AND DDIPS.avg_fragmentation_in_percent > 0
ORDER BY DDIPS.avg_fragmentation_in_percent desc
```

Если все базы фрагментированы на 90%, то WSUS явно будет тяжело что-то сделать.

3. Останавливаем сервис WSUS
4. Запускаем дефрагментацию:
```
DECLARE fragmented CURSOR
For SELECT T.Name as 'table'

FROM sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL, NULL, NULL) AS DDIPS
INNER JOIN sys.tables T on T.object_id = DDIPS.object_id
INNER JOIN sys.schemas S on T.schema_id = S.schema_id
INNER JOIN sys.indexes I ON I.object_id = DDIPS.object_id
AND DDIPS.index_id = I.index_id
WHERE DDIPS.database_id = DB_ID()
and I.name is not null
AND DDIPS.avg_fragmentation_in_percent > 10 and DDIPS.page_count > 100
group by T.Name 

OPEN fragmented;

declare @tableName nvarchar(1000)
FETCH NEXT FROM fragmented INTO @tableName;
declare @SQL nvarchar(max) 
WHILE @@FETCH_STATUS = 0  
    BEGIN
	    
		set @SQL='ALTER INDEX ALL ON [' + @tableName + '] REBUILD;'
		print @SQL;
		--print @SQL
		EXEC SP_EXECUTESQL @SQL
        FETCH NEXT FROM fragmented INTO @tableName;  
    END;
```
5. Запускаем WSUS, производим очистку компонентов системы
