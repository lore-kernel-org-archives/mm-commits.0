From: akpm@linux-foundation.org
Subject: + add-webpages-url-and-summarize-3-lines.patch added to -mm tree
Date: Fri, 13 Apr 2007 11:45:09 -0700
Message-ID: <200704131845.l3DIj9d7006707@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45713 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754135AbXDMSpN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Apr 2007 14:45:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: maxextreme@gmail.com


The patch titled
     Add webpages' URL and summarize 3 lines.
has been added to the -mm tree.  Its filename is
     add-webpages-url-and-summarize-3-lines.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Add webpages' URL and summarize 3 lines.
From: "Miguel Ojeda" <maxextreme@gmail.com>

CREDITS:
 - Summarize 3 lines into one.
 - Add webpage.

MAINTAINERS:
 - Add auxdisplay drivers/tree webpages.

Signed-off-by: Miguel Ojeda Sandonis <maxextreme@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 CREDITS     |    7 +++----
 MAINTAINERS |    4 ++++
 2 files changed, 7 insertions(+), 4 deletions(-)

diff -puN CREDITS~add-webpages-url-and-summarize-3-lines CREDITS
--- a/CREDITS~add-webpages-url-and-summarize-3-lines
+++ a/CREDITS
@@ -2596,10 +2596,9 @@ S: Australia
 
 N: Miguel Ojeda Sandonis
 E: maxextreme@gmail.com
-D: Author: Auxiliary LCD Controller driver (ks0108)
-D: Author: Auxiliary LCD driver (cfag12864b)
-D: Author: Auxiliary LCD framebuffer driver (cfag12864bfb)
-D: Maintainer: Auxiliary display drivers tree (drivers/auxdisplay/*)
+W: http://maxextreme.googlepages.com/
+D: Author of the ks0108, cfag12864b and cfag12864bfb auxiliary display drivers.
+D: Maintainer of the auxiliary display drivers tree (drivers/auxdisplay/*)
 S: C/ Mieses 20, 9-B
 S: Valladolid 47009
 S: Spain
diff -puN MAINTAINERS~add-webpages-url-and-summarize-3-lines MAINTAINERS
--- a/MAINTAINERS~add-webpages-url-and-summarize-3-lines
+++ a/MAINTAINERS
@@ -667,6 +667,7 @@ AUXILIARY DISPLAY DRIVERS
 P:	Miguel Ojeda Sandonis
 M:	maxextreme@gmail.com
 L:	linux-kernel@vger.kernel.org
+W:	http://auxdisplay.googlepages.com/
 S:	Maintained
 
 AVR32 ARCHITECTURE
@@ -940,12 +941,14 @@ CFAG12864B LCD DRIVER
 P:	Miguel Ojeda Sandonis
 M:	maxextreme@gmail.com
 L:	linux-kernel@vger.kernel.org
+W:	http://auxdisplay.googlepages.com/
 S:	Maintained
 
 CFAG12864BFB LCD FRAMEBUFFER DRIVER
 P:	Miguel Ojeda Sandonis
 M:	maxextreme@gmail.com
 L:	linux-kernel@vger.kernel.org
+W:	http://auxdisplay.googlepages.com/
 S:	Maintained
 
 CFG80211 and NL80211
@@ -2094,6 +2097,7 @@ KS0108 LCD CONTROLLER DRIVER
 P:	Miguel Ojeda Sandonis
 M:	maxextreme@gmail.com
 L:	linux-kernel@vger.kernel.org
+W:	http://auxdisplay.googlepages.com/
 S:	Maintained
 
 LAPB module
_

Patches currently in -mm which might be from maxextreme@gmail.com are

add-webpages-url-and-summarize-3-lines.patch
