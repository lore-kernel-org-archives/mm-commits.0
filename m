From: akpm@linux-foundation.org
Subject: + add-table-ids-to-videobooktmpl.patch added to -mm tree
Date: Wed, 24 Oct 2007 15:50:51 -0700
Message-ID: <200710242250.l9OMoprb016590@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38720 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757224AbXJXWuy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Oct 2007 18:50:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rob@landley.net, rdunlap@xenotime.net


The patch titled
     Add table IDs to videobook.tmpl
has been added to the -mm tree.  Its filename is
     add-table-ids-to-videobooktmpl.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Add table IDs to videobook.tmpl
From: Rob Landley <rob@landley.net>

Add table IDs to videobook.tmpl

Signed-off-by: Rob Landley <rob@landley.net>
Cc: "Randy.Dunlap" <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DocBook/videobook.tmpl |   34 ++++++++++++-------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff -puN Documentation/DocBook/videobook.tmpl~add-table-ids-to-videobooktmpl Documentation/DocBook/videobook.tmpl
--- a/Documentation/DocBook/videobook.tmpl~add-table-ids-to-videobooktmpl
+++ a/Documentation/DocBook/videobook.tmpl
@@ -178,7 +178,7 @@ int __init myradio_init(struct video_ini
   <para>
         The types available are
   </para>
-   <table frame="all"><title>Device Types</title>
+   <table frame="all" id="Device_Types"><title>Device Types</title>
    <tgroup cols="3" align="left">
    <tbody>
    <row>
@@ -299,7 +299,7 @@ static int radio_ioctl(struct video_devi
         allows the applications to find out what sort of a card they have found and
         to figure out what they want to do about it. The fields in the structure are
   </para>
-   <table frame="all"><title>struct video_capability fields</title>
+   <table frame="all" id="video_capability_fields"><title>struct video_capability fields</title>
    <tgroup cols="2" align="left">
    <tbody>
    <row>
@@ -373,7 +373,7 @@ static int radio_ioctl(struct video_devi
   <para>
         The video_tuner structure has the following fields
   </para>
-   <table frame="all"><title>struct video_tuner fields</title>
+   <table frame="all" id="video_tuner_fields"><title>struct video_tuner fields</title>
    <tgroup cols="2" align="left">
    <tbody>
    <row>
@@ -406,7 +406,7 @@ static int radio_ioctl(struct video_devi
     </tgroup>
     </table>
 
-   <table frame="all"><title>struct video_tuner flags</title>
+   <table frame="all" id="video_tuner_flags"><title>struct video_tuner flags</title>
    <tgroup cols="2" align="left">
    <tbody>
    <row>
@@ -429,7 +429,7 @@ static int radio_ioctl(struct video_devi
     </tgroup>
     </table>
 
-   <table frame="all"><title>struct video_tuner modes</title>
+   <table frame="all" id="video_tuner_modes"><title>struct video_tuner modes</title>
    <tgroup cols="2" align="left">
    <tbody>
    <row>
@@ -580,7 +580,7 @@ static int current_volume=0;
   <para>
         Then we fill in the video_audio structure. This has the following format
   </para>
-   <table frame="all"><title>struct video_audio fields</title>
+   <table frame="all" id="video_audio_fields"><title>struct video_audio fields</title>
    <tgroup cols="2" align="left">
    <tbody>
    <row>
@@ -615,7 +615,7 @@ static int current_volume=0;
    </tgroup>
    </table>
 
-   <table frame="all"><title>struct video_audio flags</title>
+   <table frame="all" id="video_audio_flags"><title>struct video_audio flags</title>
    <tgroup cols="2" align="left">
    <tbody>
    <row>
@@ -633,7 +633,7 @@ static int current_volume=0;
    </tgroup>
    </table>
 
-   <table frame="all"><title>struct video_audio modes</title>
+   <table frame="all" id="video_audio_modes"><title>struct video_audio modes</title>
    <tgroup cols="2" align="left">
    <tbody>
    <row>
@@ -783,7 +783,7 @@ module_exit(cleanup);
   </para>
   </sect1>
   </chapter>
-  <chapter>
+  <chapter id="Video_Capture_Devices">
         <title>Video Capture Devices</title>
   <sect1 id="introvid">
   <title>Video Capture Device Types</title>
@@ -864,7 +864,7 @@ static struct video_device my_camera
         We use the extra video capability flags that did not apply to the
         radio interface. The video related flags are
   </para>
-   <table frame="all"><title>Capture Capabilities</title>
+   <table frame="all" id="Capture_Capabilities"><title>Capture Capabilities</title>
    <tgroup cols="2" align="left">
    <tbody>
    <row>
@@ -1204,7 +1204,7 @@ static int camera_ioctl(struct video_dev
         inputs to the video card). Our example card has a single camera input. The
         fields in the structure are
   </para>
-   <table frame="all"><title>struct video_channel fields</title>
+   <table frame="all" id="video_channel_fields"><title>struct video_channel fields</title>
    <tgroup cols="2" align="left">
    <tbody>
    <row>
@@ -1227,7 +1227,7 @@ static int camera_ioctl(struct video_dev
     </tbody>
     </tgroup>
     </table>
-    <table frame="all"><title>struct video_channel flags</title>
+    <table frame="all" id="video_channel_flags"><title>struct video_channel flags</title>
     <tgroup cols="2" align="left">
     <tbody>
     <row>
@@ -1238,7 +1238,7 @@ static int camera_ioctl(struct video_dev
     </tbody>
     </tgroup>
     </table>
-    <table frame="all"><title>struct video_channel types</title>
+    <table frame="all" id="video_channel_types"><title>struct video_channel types</title>
     <tgroup cols="2" align="left">
     <tbody>
     <row>
@@ -1251,7 +1251,7 @@ static int camera_ioctl(struct video_dev
     </tbody>
     </tgroup>
     </table>
-    <table frame="all"><title>struct video_channel norms</title>
+    <table frame="all" id="video_channel_norms"><title>struct video_channel norms</title>
     <tgroup cols="2" align="left">
     <tbody>
     <row>
@@ -1337,7 +1337,7 @@ static int camera_ioctl(struct video_dev
         for every other pixel in the image. The other common formats the interface 
         defines are
   </para>
-   <table frame="all"><title>Framebuffer Encodings</title>
+   <table frame="all" id="Framebuffer_Encodings"><title>Framebuffer Encodings</title>
    <tgroup cols="2" align="left">
    <tbody>
    <row>
@@ -1475,7 +1475,7 @@ static struct video_buffer capture_fb;
         display. The video_window structure is used to describe the way the image 
         should be displayed. 
    </para>
-   <table frame="all"><title>struct video_window fields</title>
+   <table frame="all" id="video_window_fields"><title>struct video_window fields</title>
    <tgroup cols="2" align="left">
    <tbody>
    <row>
@@ -1512,7 +1512,7 @@ static struct video_buffer capture_fb;
     <para>
         Each clip is a struct video_clip which has the following fields
    </para>
-   <table frame="all"><title>video_clip fields</title>
+   <table frame="all" id="video_clip_fields"><title>video_clip fields</title>
    <tgroup cols="2" align="left">
    <tbody>
    <row>
_

Patches currently in -mm which might be from rob@landley.net are

add-missing-section-ids-to-genericirqtmpl.patch
add-missing-section-ids-to-genericirqtmpl-updated.patch
add-missing-section-id-to-lsmtmpl.patch
add-section-ids-to-mtdnandtmpl.patch
add-missing-ids-to-procfs-guidetmpl.patch
add-section-ids-to-rapidiotmpl.patch
add-table-ids-to-videobooktmpl.patch
add-chapter-ids-to-z8530booktmpl.patch
