From: akpm@linux-foundation.org
Subject: - cris-build-fixes-add-baud-rate-defines.patch removed from -mm tree
Date: Thu, 15 Nov 2007 13:11:41 -0800
Message-ID: <200711152111.lAFLBfLu015787@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56364 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759600AbXKOVRB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 16:17:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesper.nilsson@axis.com, starvik@axis.com, mm-commits@vger.kernel.org


The patch titled
     cris build fixes: add baud rate defines
has been removed from the -mm tree.  Its filename was
     cris-build-fixes-add-baud-rate-defines.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cris build fixes: add baud rate defines
From: Jesper Nilsson <jesper.nilsson@axis.com>

Add missing defines for (unsupported) baud rates.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
Acked-by: Mikael Starvik <starvik@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-cris/termbits.h |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff -puN include/asm-cris/termbits.h~cris-build-fixes-add-baud-rate-defines include/asm-cris/termbits.h
--- a/include/asm-cris/termbits.h~cris-build-fixes-add-baud-rate-defines
+++ a/include/asm-cris/termbits.h
@@ -171,6 +171,19 @@ struct ktermios {
 #define  B115200 0010002
 #define  B230400 0010003
 #define  B460800 0010004
+
+/* Unsupported rates, but needed to avoid compile error. */
+#define   B500000 0010005
+#define   B576000 0010006
+#define  B1000000 0010010
+#define  B1152000 0010011
+#define  B1500000 0010012
+#define  B2000000 0010013
+#define  B2500000 0010014
+#define  B3000000 0010015
+#define  B3500000 0010016
+#define  B4000000 0010017
+
 /* etrax supports these additional three baud rates */
 #define  B921600   0010005
 #define  B1843200  0010006
_

Patches currently in -mm which might be from jesper.nilsson@axis.com are

origin.patch
cris-build-fixes-atomich-needs-compilerh.patch
git-mtd.patch
