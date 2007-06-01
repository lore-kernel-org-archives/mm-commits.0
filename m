From: akpm@linux-foundation.org
Subject: - potential-parse-error-in-ifdef-fix.patch removed from -mm tree
Date: Fri, 01 Jun 2007 00:15:07 -0700
Message-ID: <200706010715.l517F639004890@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:44983 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758117AbXFAHPM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2007 03:15:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jeff@garzik.org, padator@wanadoo.fr, mm-commits@vger.kernel.org


The patch titled
     amd8111e: fix more bustage
has been removed from the -mm tree.  Its filename was
     potential-parse-error-in-ifdef-fix.patch

This patch was dropped because it was folded into potential-parse-error-in-ifdef.patch

------------------------------------------------------
Subject: amd8111e: fix more bustage
From: Andrew Morton <akpm@linux-foundation.org>

drivers/net/amd8111e.c: In function 'amd8111e_write_phy':
drivers/net/amd8111e.c:159: warning: ISO C90 forbids mixed declarations and code

Cc: Jeff Garzik <jeff@garzik.org>
Cc: Yoann Padioleau <padator@wanadoo.fr>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/amd8111e.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/amd8111e.c~potential-parse-error-in-ifdef-fix drivers/net/amd8111e.c
diff -puN drivers/net/amd8111e.h~potential-parse-error-in-ifdef-fix drivers/net/amd8111e.h
--- a/drivers/net/amd8111e.h~potential-parse-error-in-ifdef-fix
+++ a/drivers/net/amd8111e.h
@@ -615,7 +615,7 @@ typedef enum {
 #define SSTATE  2
 
 /* Assume contoller gets data 10 times the maximum processing time */
-#define  REPEAT_CNT			10;
+#define  REPEAT_CNT			10
 
 /* amd8111e decriptor flag definitions */
 typedef enum {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
potential-parse-error-in-ifdef.patch
potential-parse-error-in-ifdef-fix.patch
potential-parse-error-in-ifdef-update.patch
aacraid-fix-shutdown-handler-to-also-disable-interrupts.patch
alpha-support-graphics-on-non-zero-pci-domains-fix.patch
alpha-support-graphics-on-non-zero-pci-domains-fix-2.patch
