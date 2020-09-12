{
    sea=$2;
    dea=$0; sub(/(.*?) > /,"",dea); sub(/( |,).*/,"",dea);
    len=$0; sub(/(.*?) length /,"",len); sub(/:.*/,"",len);
    print sea, dea, len, "@@@", $0
}
