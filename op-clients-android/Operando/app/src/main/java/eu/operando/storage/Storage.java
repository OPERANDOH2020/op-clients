package eu.operando.storage;

import android.support.annotation.Nullable;

import java.util.List;

import eu.operando.models.InstalledApp;
import io.paperdb.Paper;

/**
 * Created by Edy on 11/25/2016.
 */

public class Storage {
    private static void write(String key, @Nullable Object value) {
        if (value != null) {
            Paper.book().write(key, value);
        } else {
            Paper.book().delete(key);
        }
    }

    public static void saveUserID(String userID) {
        write(K.USER_ID, userID);
    }

    public static String readUserID() {
        return Paper.book().read(K.USER_ID);
    }

    public static void saveAppList(List<InstalledApp> appList) {
        write(K.APP_LIST, appList);
    }

    public static List<InstalledApp> readAppList() {
        return Paper.book().read(K.APP_LIST);
    }
}


