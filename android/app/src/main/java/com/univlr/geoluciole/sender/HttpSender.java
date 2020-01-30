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

import android.util.Log;

import androidx.annotation.NonNull;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import okhttp3.Call;
import okhttp3.Callback;
import okhttp3.ConnectionSpec;
import okhttp3.MediaType;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;

/**
 * Classe permettant d'envoyer des données via le protocol HTTP
 */
public class HttpSender {

    private static final String METHOD_POST = "POST";
    public static final String METHOD_GET = "GET";

    private static final String TYPE_JSON_APPLICATION = "application/json";

    // Attributes
    private String method;
    private Callback callback;
    private String data;
    private String url;
    private String type;

    /**
     * Constructor
     */
    public HttpSender() {
        this.method = HttpSender.METHOD_POST;
        this.url = "";
        this.type = HttpSender.TYPE_JSON_APPLICATION;
        this.callback = new Callback() {
            @Override
            public void onFailure(@NonNull Call call, @NonNull IOException e) {
                e.printStackTrace();
            }

            @Override
            public void onResponse(@NonNull Call call, @NonNull Response response) throws IOException {
                Log.d("debug http", response.body().string());
                Log.d("debug http", response.message());
                Log.d("debug http", response.toString());
            }
        };
    }

    /**
     * Fixe le content-type de la requête
     *
     * @param type content type de la requête
     * @return L'objet HttpSender
     */
    public HttpSender setType(String type) {
        this.type = type;
        return this;
    }

    /**
     * Fixe l'url de la requête
     *
     * @param url url de la requête
     * @return L'objet HttpSender
     */
    public HttpSender setUrl(String url) {
        this.url = url;
        return this;
    }

    /**
     * Fixe les données à envoyer
     *
     * @param data les données
     * @return L'objet HttpSender
     */
    public HttpSender setData(String data) {
        this.data = data;
        return this;
    }

    /**
     * Fixe la méthode de la requête : GET | POST
     *
     * @param method la méthode
     * @return L'objet HttpSender
     */
    public HttpSender setMethod(String method) {
        this.method = method;
        return this;
    }

    /**
     * Fixe le callback pour la requête
     *
     * @param callback le callback
     * @return L'objet HttpSender
     */
    public HttpSender setCallback(Callback callback) {
        this.callback = callback;
        return this;
    }

    /**
     * Permet d'envoyer la requête en fonction des données fourni
     */
    public void send() {
        OkHttpClient client = new OkHttpClient().newBuilder()
                .connectionSpecs(Arrays.asList(ConnectionSpec.MODERN_TLS, ConnectionSpec.COMPATIBLE_TLS, ConnectionSpec.CLEARTEXT))
                .build();
        RequestBody body = RequestBody.create(MediaType.parse("application/json"), this.data);
        Request.Builder reqBuilder = new Request.Builder();
        reqBuilder.url(this.url);
        if (this.type != null) {
            reqBuilder.addHeader("content-type", this.type);
        }
        reqBuilder.method(this.method, body);

        okhttp3.Request request = reqBuilder.build();
        try {
            client.newCall(request).enqueue(this.callback);
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    /**
     * Parse la donnée sous format bulk : json\n json\n
     */
    public static String parseDataInBulk(BulkObject bulkObject) {
        List<BulkObject> bulkObjects = new ArrayList<>();
        bulkObjects.add(bulkObject);
        return parseDataInBulk(bulkObjects);
    }

    /**
     * Parse la donnée sous format bulk : json\n json\n
     */
    public static String parseDataInBulk(List<BulkObject> bulkObjects) {
        StringBuilder result = new StringBuilder();
        String index = "{\"index\":{}}\n";
        for (BulkObject bulk : bulkObjects) {
            if (bulk.hasMultipleObject()) {
                List<String> parsed_data = bulk.jsonFormatObject();
                for (String data : parsed_data) {
                    result.append(index);
                    result.append(data);
                    result.append("\n");
                }
            } else {
                result.append(index);
                result.append(bulk.jsonFormat());
                result.append("\n");
            }
        }
        return result.toString();
    }

}
