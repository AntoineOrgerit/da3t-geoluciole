package com.univlr.geoluciole.sender;

import java.util.List;

public interface BulkObject {

    /**
     * Transforme les données en json
     * @return la chaine de caractère du json
     */
    public List<String> jsonFormatObject();
    public boolean hasMultipleObject();
    public String jsonFormat();
}
