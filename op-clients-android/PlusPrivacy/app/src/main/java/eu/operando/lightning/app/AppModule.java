package eu.operando.lightning.app;

import android.app.Application;
import android.content.Context;
import android.support.annotation.NonNull;


import javax.inject.Singleton;

import eu.operando.BrowserApp;
import eu.operando.lightning.database.bookmark.BookmarkDatabase;
import eu.operando.lightning.database.bookmark.BookmarkModel;
import dagger.Module;
import dagger.Provides;

@Module
public class AppModule {
    private final BrowserApp mApp;

    public AppModule(BrowserApp app) {
        this.mApp = app;
    }

    @Provides
    public Application provideApplication() {
        return mApp;
    }

    @Provides
    public Context provideContext() {
        return mApp.getApplicationContext();
    }

    @NonNull
    @Provides
    @Singleton
    public BookmarkModel provideBookmarkMode() {
        return new BookmarkDatabase(mApp);
    }


}
