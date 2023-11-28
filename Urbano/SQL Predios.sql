-- Total predios
SELECT "count"("id") FROM predio WHERE estado = 1;

-- Predios por definir 
select * from predio where id_cliente = 170200 and estado = 1;

-- Uso area = 0
select * from uso where "areaConConstruccion" + "areaSinConstruccion" = 0;
select * from claveclientevw  where idpredio in (select id_predio from uso where "areaConConstruccion" + "areaSinConstruccion" = 0);

