/*
 * This file is part of Adblock Plus <https://adblockplus.org/>,
 * Copyright (C) 2006-2016 Eyeo GmbH
 *
 * Adblock Plus is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 3 as
 * published by the Free Software Foundation.
 *
 * Adblock Plus is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Adblock Plus.  If not, see <http://www.gnu.org/licenses/>.
 */

#include "JniCallbacks.h"
#include "Utils.h"

static jlong JNICALL JniCtor(JNIEnv* env, jclass clazz, jobject callbackObject)
{
  try
  {
    JniIsAllowedConnectionTypeCallback* callback =
      new JniIsAllowedConnectionTypeCallback(env, callbackObject);

    return JniPtrToLong(callback);
  }
  CATCH_THROW_AND_RETURN(env, 0)
}

static void JNICALL JniDtor(JNIEnv* env, jclass clazz, jlong ptr)
{
  delete JniLongToTypePtr<JniIsAllowedConnectionTypeCallback>(ptr);
}

JniIsAllowedConnectionTypeCallback::JniIsAllowedConnectionTypeCallback(JNIEnv* env,
    jobject callbackObject)
    : JniCallbackBase(env, callbackObject)
{
}

bool JniIsAllowedConnectionTypeCallback::Callback(const std::string* allowedConnectionType)
{
  JNIEnvAcquire env(GetJavaVM());

  jmethodID method = env->GetMethodID(
      *JniLocalReference<jclass>(*env, env->GetObjectClass(GetCallbackObject())),
      "isConnectionAllowed",
      "(Ljava/lang/String;)Z");

  jstring jAllowedConnectionType =
    (allowedConnectionType != NULL
    ? JniStdStringToJava(*env, *allowedConnectionType)
    : NULL);
  bool result = env->CallBooleanMethod(GetCallbackObject(), method, jAllowedConnectionType);

  CheckAndLogJavaException(*env);
  return result;
}

static JNINativeMethod methods[] =
{
  { (char*)"ctor", (char*)"(Ljava/lang/Object;)J", (void*)JniCtor },
  { (char*)"dtor", (char*)"(J)V", (void*)JniDtor }
};

extern "C" JNIEXPORT void JNICALL Java_org_adblockplus_libadblockplus_IsAllowedConnectionCallback_registerNatives(JNIEnv *env, jclass clazz)
{
  env->RegisterNatives(clazz, methods, sizeof(methods) / sizeof(methods[0]));
}
