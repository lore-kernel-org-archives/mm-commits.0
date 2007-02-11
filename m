From: akpm@linux-foundation.org
Subject: - fix-gregkh-usb-usb-linux-usb_ch9h-becomes-linux-usb-ch9h.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:55:50 -0800
Message-ID: <200702112255.l1BMtoHw016362@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60660 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932890AbXBKW4E (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:56:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwm@meer.net, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     fix DocBook build
has been removed from the -mm tree.  Its filename was
     fix-gregkh-usb-usb-linux-usb_ch9h-becomes-linux-usb-ch9h.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fix DocBook build
From: Don Mullis <dwm@meer.net>

Fix DocBook build.  Regression was introduced by
gregkh-usb-usb-linux-usb_ch9h-becomes-linux-usb-ch9h.patch

Tested by `make htmldocs`.

Signed-off-by: Don Mullis <dwm@meer.net>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DocBook/gadget.tmpl |    4 ++--
 Documentation/DocBook/usb.tmpl    |    6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff -puN Documentation/DocBook/gadget.tmpl~fix-gregkh-usb-usb-linux-usb_ch9h-becomes-linux-usb-ch9h Documentation/DocBook/gadget.tmpl
--- a/Documentation/DocBook/gadget.tmpl~fix-gregkh-usb-usb-linux-usb_ch9h-becomes-linux-usb-ch9h
+++ a/Documentation/DocBook/gadget.tmpl
@@ -482,13 +482,13 @@ slightly.
 <para>Gadget drivers
 rely on common USB structures and constants
 defined in the
-<filename>&lt;linux/usb_ch9.h&gt;</filename>
+<filename>&lt;linux/usb/ch9.h&gt;</filename>
 header file, which is standard in Linux 2.6 kernels.
 These are the same types and constants used by host
 side drivers (and usbcore).
 </para>
 
-!Iinclude/linux/usb_ch9.h
+!Iinclude/linux/usb/ch9.h
 </sect1>
 
 <sect1 id="core"><title>Core Objects and Methods</title>
diff -puN Documentation/DocBook/usb.tmpl~fix-gregkh-usb-usb-linux-usb_ch9h-becomes-linux-usb-ch9h Documentation/DocBook/usb.tmpl
--- a/Documentation/DocBook/usb.tmpl~fix-gregkh-usb-usb-linux-usb_ch9h-becomes-linux-usb-ch9h
+++ a/Documentation/DocBook/usb.tmpl
@@ -187,13 +187,13 @@
 
 <chapter><title>USB-Standard Types</title>
 
-    <para>In <filename>&lt;linux/usb_ch9.h&gt;</filename> you will find
+    <para>In <filename>&lt;linux/usb/ch9.h&gt;</filename> you will find
     the USB data types defined in chapter 9 of the USB specification.
     These data types are used throughout USB, and in APIs including
     this host side API, gadget APIs, and usbfs.
     </para>
 
-!Iinclude/linux/usb_ch9.h
+!Iinclude/linux/usb/ch9.h
 
     </chapter>
 
@@ -574,7 +574,7 @@ for (;;) {
 #include &lt;asm/byteorder.h&gt;</programlisting>
 	    The standard USB device model requests, from "Chapter 9" of
 	    the USB 2.0 specification, are automatically included from
-	    the <filename>&lt;linux/usb_ch9.h&gt;</filename> header.
+	    the <filename>&lt;linux/usb/ch9.h&gt;</filename> header.
 	    </para>
 
 	    <para>Unless noted otherwise, the ioctl requests
_

Patches currently in -mm which might be from dwm@meer.net are

origin.patch
