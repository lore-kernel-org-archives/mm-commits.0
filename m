From: akpm@linux-foundation.org
Subject: [folded] init-skip-calibration-delay-if-previously-done-fix-fix-fix.patch removed from -mm tree
Date: Mon, 25 Jul 2011 17:02:07 -0700
Message-ID: <201107260002.p6Q027Io006637@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57432 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752194Ab1GZACI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jul 2011 20:02:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: snanda@google.com, mm-commits@vger.kernel.org


The patch titled
     init-skip-calibration-delay-if-previously-done-fix-fix-fix
has been removed from the -mm tree.  Its filename was
     init-skip-calibration-delay-if-previously-done-fix-fix-fix.patch

This patch was dropped because it was folded into init-skip-calibration-delay-if-previously-done.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: init-skip-calibration-delay-if-previously-done-fix-fix-fix
From: Sameer Nanda <snanda@google.com>

prevent ARM build breakage :)


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/calibrate.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN init/calibrate.c~init-skip-calibration-delay-if-previously-done-fix-fix-fix init/calibrate.c
--- a/init/calibrate.c~init-skip-calibration-delay-if-previously-done-fix-fix-fix
+++ a/init/calibrate.c
@@ -9,6 +9,7 @@
 #include <linux/init.h>
 #include <linux/timex.h>
 #include <linux/smp.h>
+#include <linux/percpu.h>
 
 unsigned long lpj_fine;
 unsigned long preset_lpj;
_

Patches currently in -mm which might be from snanda@google.com are

init-skip-calibration-delay-if-previously-done.patch

