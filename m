From: akpm@linux-foundation.org
Subject: - add-webpages-url-and-summarize-3-lines.patch removed from -mm tree
Date: Tue, 08 May 2007 19:50:00 -0700
Message-ID: <200705090250.l492o0Ol009291@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:36128 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S969816AbXEICuE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:50:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: maxextreme@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Add webpages' URL and summarize 3 lines.
has been removed from the -mm tree.  Its filename was
     add-webpages-url-and-summarize-3-lines.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -2580,10 +2580,9 @@ S: Australia
 
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
@@ -679,6 +679,7 @@ AUXILIARY DISPLAY DRIVERS
 P:	Miguel Ojeda Sandonis
 M:	maxextreme@gmail.com
 L:	linux-kernel@vger.kernel.org
+W:	http://auxdisplay.googlepages.com/
 S:	Maintained
 
 AVR32 ARCHITECTURE
@@ -943,12 +944,14 @@ CFAG12864B LCD DRIVER
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
@@ -2096,6 +2099,7 @@ KS0108 LCD CONTROLLER DRIVER
 P:	Miguel Ojeda Sandonis
 M:	maxextreme@gmail.com
 L:	linux-kernel@vger.kernel.org
+W:	http://auxdisplay.googlepages.com/
 S:	Maintained
 
 LAPB module
_

Patches currently in -mm which might be from maxextreme@gmail.com are

origin.patch
