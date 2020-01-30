/*
 * Copyright (c) 2020, La Rochelle Université
 * All rights reserved.
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *  Redistributions of source code must retain the above copyright
 *   notice, this list of conditions and the following disclaimer.
 *  Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the distribution.
 *  Neither the name of the University of California, Berkeley nor the
 *   names of its contributors may be used to endorse or promote products
 *   derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ''AS IS'' AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE REGENTS AND CONTRIBUTORS BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

package com.univlr.geoluciole.sender;

import java.util.List;

/**
 * Cette interface permet de formatter un envoi réalisé dans le format 'bulk'.
 *
 * Le format bulk est un format utilisé par le serveur Elastic Search qui permet d'ajouter plusieurs objet en base de donnée
 * en réalisant une seule requête.
 *
 * Le format bulk s'obtient de la façon suivante :
 * {"index":{}}\n          // Obj 1
 * {"KEY_NAME":VALUE}\n
 * {"index":{}}\n          // Obj 2
 * {"KEY_NAME":VALUE}\n
 *
 * Attention :
 *  - La clé doit se trouver entre quote.
 *  - Il faut absolument avoir un saut de ligne (\n) en fin de l'objet à envoyer
 *  - Si la valeur doit être un String, il faut l'entourer de quote : \"VALUE\"
 *
 */
public interface BulkObject {

    /**
     * retourne l'ensemble des objet à envoyer sous le format d'une liste.
     * Cette function est utilisé lorsque hasMultipleObject() retourne true.
     *
     * @return la chaine de caractère en json
     */
    List<String> jsonFormatObject();

    /**
     * Défini si l'objet Java doit retourner plusieurs objet à storer
     * @return true, il y aura plusieurs génération d'objet à inserer dans la base de donnée (utilisé pour le formulaire)
     */
    boolean hasMultipleObject();

    /**
     * Permet de générer l'objet à envoyer. (utilisé pour l'envoi des données GPS)
     *
     * @return l'objet formatter en string pour envoyer au serveur.
     */
    String jsonFormat();
}
