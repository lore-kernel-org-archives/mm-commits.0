From: akpm@linux-foundation.org
Subject: - driver-edac-remove-file-edac_mc-h.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:07:05 -0700
Message-ID: <200707192007.l6JK75W1020229@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55849 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756278AbXGSUPF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:15:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dougthompson@xmission.com, mm-commits@vger.kernel.org


The patch titled
     drivers/edac: remove file edac_mc.h
has been removed from the -mm tree.  Its filename was
     driver-edac-remove-file-edac_mc-h.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/edac: remove file edac_mc.h
From: Douglas Thompson <dougthompson@xmission.com>

Removed the no-longer-needed file edac_mc.h

Signed-off-by: Douglas Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/edac_mc.h |    7 -------
 1 file changed, 7 deletions(-)

diff -puN drivers/edac/edac_mc.h~driver-edac-remove-file-edac_mc-h /dev/null
--- a/drivers/edac/edac_mc.h
+++ /dev/null
@@ -1,7 +0,0 @@
-
-/*
- * Older .h file for edac, until all drivers are modified
- *
- */
-
-#include "edac_core.h"
_

Patches currently in -mm which might be from dougthompson@xmission.com are

origin.patch
