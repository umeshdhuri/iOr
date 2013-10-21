package com.mlsdev.charityapp;

import android.util.Log;

import org.apache.http.NameValuePair;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.client.utils.URLEncodedUtils;
import org.apache.http.message.BasicNameValuePair;

import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class ApiRequestBuilder {
    private static final String API_KEY = "3b286f4f8f927e3a2cf861a8c2517db5";
    private static final String BASE_URL = "http://resto.applistore.mobi/api/";//"http://mafr.mlsdev.com/api/";
    private static final String MENU_CATEGORY_URL = BASE_URL + "categorieslist";
    private static final String DISH_LIST_URL = BASE_URL + "disheslist";
    private static final String REGISTER_CUSTOMER_URL = BASE_URL + "registercustomer";
    private static final String ADD_ORDER_URL = BASE_URL + "addorder";
    private static final String DEAL_URL = BASE_URL + "dealslist";
    private static final String RESTAUT_URL = BASE_URL + "RestaurantInfo";
    private static final String SET_RATING_URL = BASE_URL + "setrating";
    private static final String ORDER_INFO_URL = BASE_URL + "getorder";
    private static final String RESERVE_TABLE_URL = BASE_URL + "addreservation";

    public static final String FEEDBACK_EMAIL = "samdjian@gmail.com";

    protected String buildGetQuery(String path, Map<String, String> params) {
        StringBuilder builder = new StringBuilder();
        builder.append(path);
        if (params.size() > 0) {
            builder.append("?");
        }
        for(String param : params.keySet()) {
            builder.append(param);
            builder.append("=");
            builder.append(params.get(param));
            builder.append("&");
        }
        return builder.toString();
    }

    public static HttpGet getMenuCategory() {
        List<NameValuePair> params = new ArrayList<NameValuePair>();
        params.add(new BasicNameValuePair("key", API_KEY));
        String paramString = URLEncodedUtils.format(params, "utf-8");
        return new HttpGet(MENU_CATEGORY_URL + "?" + paramString);
    }

    public static HttpGet getDishList(String categoryId, String udid) {
        List<NameValuePair> params = new ArrayList<NameValuePair>();
        params.add(new BasicNameValuePair("key", API_KEY));
        params.add(new BasicNameValuePair("categoryId", categoryId));
        if (udid != null) {
            params.add(new BasicNameValuePair("udid", udid));
        }
        String paramString = URLEncodedUtils.format(params, "utf-8");
        return new HttpGet(DISH_LIST_URL + "?" + paramString);
    }

    public static HttpGet getDeals(String udid) {
        List<NameValuePair> params = new ArrayList<NameValuePair>();
        params.add(new BasicNameValuePair("key", API_KEY));
        if (udid != null) {
            params.add(new BasicNameValuePair("udid", udid));
        }
        String paramString = URLEncodedUtils.format(params, "utf-8");
        return new HttpGet(DEAL_URL + "?" + paramString);
    }

    public static HttpGet getResturant() {
        String url = RESTAUT_URL + "?key=" + API_KEY;
        return new HttpGet(url);
    }



    public static HttpPost registerCustomer(String uuid, String pushId) {
        HttpPost post = new HttpPost(REGISTER_CUSTOMER_URL + "?key=" + API_KEY);

        ArrayList<NameValuePair> postParameters = new ArrayList<NameValuePair>();
        postParameters.add(new BasicNameValuePair("Customer[udid]", uuid));
        postParameters.add(new BasicNameValuePair("Customer[pushId]", pushId));
        postParameters.add(new BasicNameValuePair("Customer[deviceType]", "a"));

        try {
            post.setEntity(new UrlEncodedFormEntity(postParameters));
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        return post;
    }

    public static HttpPost setRating(String dishId, String udid, int value) {
        HttpPost post = new HttpPost(SET_RATING_URL + "?key=" + API_KEY);

        ArrayList<NameValuePair> postParameters = new ArrayList<NameValuePair>();
        postParameters.add(new BasicNameValuePair("dishId", dishId));
        postParameters.add(new BasicNameValuePair("udid", udid));
        postParameters.add(new BasicNameValuePair("value", value + ""));

        try {
            post.setEntity(new UrlEncodedFormEntity(postParameters));
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        return post;
    }

    public static HttpGet getOrder(String orderId, String udid) {
        Log.d("TEST", "orderId " + orderId);
        Log.d("TEST", "udid " + udid);
        List<NameValuePair> params = new ArrayList<NameValuePair>();
        params.add(new BasicNameValuePair("key", API_KEY));
        params.add(new BasicNameValuePair("orderId", orderId));
        if (udid != null) {
            params.add(new BasicNameValuePair("udid", udid));
        }
        String paramString = URLEncodedUtils.format(params, "utf-8");
        Log.d("TEST", ORDER_INFO_URL + "?" + paramString);
        return new HttpGet(ORDER_INFO_URL + "?" + paramString);
    }

    public static HttpPost reserveTable(String name, String phone, int personAmount, String dateTime, String description) {
        HttpPost post = new HttpPost(RESERVE_TABLE_URL + "?key=" + API_KEY);
        List<NameValuePair> params = new ArrayList<NameValuePair>();
        params.add(new BasicNameValuePair("Reservation[name]", name));
        params.add(new BasicNameValuePair("Reservation[phone]", phone));
        params.add(new BasicNameValuePair("Reservation[persons]", personAmount + ""));
        params.add(new BasicNameValuePair("Reservation[dateTime]", dateTime));
        if (description != null && description.length() > 0) {
            params.add(new BasicNameValuePair("Reservation[dateTime]", dateTime));
        }
        try {
            post.setEntity(new UrlEncodedFormEntity(params));
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        return post;
    }

    public static HttpGet getDish(String dishId, String udid) {
        List<NameValuePair> params = new ArrayList<NameValuePair>();
        if (udid != null) {
            params.add(new BasicNameValuePair("udid", udid));
        }
        params.add(new BasicNameValuePair("key", API_KEY));
        params.add(new BasicNameValuePair("dishId", dishId));
        String paramString = URLEncodedUtils.format(params, "utf-8");
        return new HttpGet(DEAL_URL + "?" + paramString);
    }
}

