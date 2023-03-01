# Reproduction of timezone problem in spring-boot-maven-plugin repackage

A project wants to be reproducible and sets the `project.build.outputTimestamp` to a desired value with a clear timezone in it.

Then the `spring-boot-maven-plugin` is used to `repackage` the jar/war file.
https://docs.spring.io/spring-boot/docs/current/maven-plugin/reference/htmlsingle/#goals-repackage

The `outputTimestamp` then by default uses the correct timestamp.
https://docs.spring.io/spring-boot/docs/current/maven-plugin/reference/htmlsingle/#goals-repackage-parameters-details-outputTimestamp

The problem is that the timestamp in final jar/war file has this timestamp expressed in the timezone of the build system.

So someone in a different timezone can only reproduce the build if they are able to figure out the timestamp of the original build system.

This mini project demonstrates this problem by building the same demo project twice in a docker image with a different timezone.

NOTE: I expect the output to be in the specified timezone in the `outputTimestamp`.

# Summary of the real output (made with diffoscope):

The content (all jar files and such) are identical

    │┄ Archive contents identical but files differ, possibly due to different compression levels. Falling back to binary comparison.

In timezone Europe/Amsterdam

    │ +drwxr-xr-x  2.0 unx        0 bX defN 11-Nov-11 23:22 META-INF/
    │ +-rw-r--r--  2.0 unx      379 bl defN 11-Nov-11 23:22 META-INF/MANIFEST.MF
    │ +drwxr-xr-x  2.0 unx        0 bl defN 11-Nov-11 23:22 org/
    │ +drwxr-xr-x  2.0 unx        0 bl defN 11-Nov-11 23:22 org/springframework/
    │ +drwxr-xr-x  2.0 unx        0 bl defN 11-Nov-11 23:22 org/springframework/boot/
    │ +drwxr-xr-x  2.0 unx        0 bl defN 11-Nov-11 23:22 org/springframework/boot/loader/
    │ +-rw-r--r--  2.0 unx     5667 bl defN 11-Nov-11 23:22 org/springframework/boot/loader/ClassPathIndexFile.class
    │ +-rw-r--r--  2.0 unx     7806 bl defN 11-Nov-11 23:22 org/springframework/boot/loader/ExecutableArchiveLauncher.class
    │ +-rw-r--r--  2.0 unx     2540 bl defN 11-Nov-11 23:22 org/springframework/boot/loader/JarLauncher.class

In timezone Australia/Eucla

    │ -drwxr-xr-x  2.0 unx        0 bX defN 11-Nov-12 07:07 META-INF/
    │ --rw-r--r--  2.0 unx      379 bl defN 11-Nov-12 07:07 META-INF/MANIFEST.MF
    │ -drwxr-xr-x  2.0 unx        0 bl defN 11-Nov-12 07:07 org/
    │ -drwxr-xr-x  2.0 unx        0 bl defN 11-Nov-12 07:07 org/springframework/
    │ -drwxr-xr-x  2.0 unx        0 bl defN 11-Nov-12 07:07 org/springframework/boot/
    │ -drwxr-xr-x  2.0 unx        0 bl defN 11-Nov-12 07:07 org/springframework/boot/loader/
    │ --rw-r--r--  2.0 unx     5667 bl defN 11-Nov-12 07:07 org/springframework/boot/loader/ClassPathIndexFile.class
    │ --rw-r--r--  2.0 unx     7806 bl defN 11-Nov-12 07:07 org/springframework/boot/loader/ExecutableArchiveLauncher.class
    │ --rw-r--r--  2.0 unx     2540 bl defN 11-Nov-12 07:07 org/springframework/boot/loader/JarLauncher.class
    
In timezone AU/Hawaii

    │ +drwxr-xr-x  2.0 unx        0 bX defN 11-Nov-11 12:22 META-INF/
    │ +-rw-r--r--  2.0 unx      379 bl defN 11-Nov-11 12:22 META-INF/MANIFEST.MF
    │ +drwxr-xr-x  2.0 unx        0 bl defN 11-Nov-11 12:22 org/
    │ +drwxr-xr-x  2.0 unx        0 bl defN 11-Nov-11 12:22 org/springframework/
    │ +drwxr-xr-x  2.0 unx        0 bl defN 11-Nov-11 12:22 org/springframework/boot/
    │ +drwxr-xr-x  2.0 unx        0 bl defN 11-Nov-11 12:22 org/springframework/boot/loader/
    │ +-rw-r--r--  2.0 unx     5667 bl defN 11-Nov-11 12:22 org/springframework/boot/loader/ClassPathIndexFile.class
    │ +-rw-r--r--  2.0 unx     7806 bl defN 11-Nov-11 12:22 org/springframework/boot/loader/ExecutableArchiveLauncher.class
    │ +-rw-r--r--  2.0 unx     2540 bl defN 11-Nov-11 12:22 org/springframework/boot/loader/JarLauncher.class

