From: akpm@linux-foundation.org
Subject: - drivers-edac-coreh-fix-scrubdefs.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:05:33 -0700
Message-ID: <200707192005.l6JK5Xeh020053@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36691 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757112AbXGSUPH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:15:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dougthompson@xmission.com, mm-commits@vger.kernel.org


The patch titled
     drivers/edac: core.h fix scrubdefs
has been removed from the -mm tree.  Its filename was
     drivers-edac-coreh-fix-scrubdefs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/edac: core.h fix scrubdefs
From: Douglas Thompson <dougthompson@xmission.com>

Patch to fix some scrubbing #defines in the edac_core.h file

Signed-off-by: Douglas Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/edac_core.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/edac/edac_core.h~drivers-edac-coreh-fix-scrubdefs drivers/edac/edac_core.h
--- a/drivers/edac/edac_core.h~drivers-edac-coreh-fix-scrubdefs
+++ a/drivers/edac/edac_core.h
@@ -194,12 +194,12 @@ enum scrub_type {
 };
 
 #define SCRUB_FLAG_SW_PROG	BIT(SCRUB_SW_PROG)
-#define SCRUB_FLAG_SW_SRC	BIT(SCRUB_SW_SRC_CORR)
-#define SCRUB_FLAG_SW_PROG_SRC	BIT(SCRUB_SW_PROG_SRC_CORR)
+#define SCRUB_FLAG_SW_SRC	BIT(SCRUB_SW_SRC)
+#define SCRUB_FLAG_SW_PROG_SRC	BIT(SCRUB_SW_PROG_SRC)
 #define SCRUB_FLAG_SW_TUN	BIT(SCRUB_SW_SCRUB_TUNABLE)
 #define SCRUB_FLAG_HW_PROG	BIT(SCRUB_HW_PROG)
-#define SCRUB_FLAG_HW_SRC	BIT(SCRUB_HW_SRC_CORR)
-#define SCRUB_FLAG_HW_PROG_SRC	BIT(SCRUB_HW_PROG_SRC_CORR)
+#define SCRUB_FLAG_HW_SRC	BIT(SCRUB_HW_SRC)
+#define SCRUB_FLAG_HW_PROG_SRC	BIT(SCRUB_HW_PROG_SRC)
 #define SCRUB_FLAG_HW_TUN	BIT(SCRUB_HW_TUNABLE)
 
 /* FIXME - should have notify capabilities: NMI, LOG, PROC, etc */
_

Patches currently in -mm which might be from dougthompson@xmission.com are

origin.patch
