From: akpm@linux-foundation.org
Subject: [merged]
 kernel-watchdog-fix-spelling-mistake-permanetely-permanently.patch removed
 from -mm tree
Date: Fri, 29 Sep 2017 12:08:42 -0700
Message-ID: <20170929190842.UtOEdrbZG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48834 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752303AbdI2TIo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Sep 2017 15:08:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: colin.king@canonical.com, dzickus@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/watchdog_hld.c: fix spelling mistake: "permanetely" -> "permanently"
has been removed from the -mm tree.  Its filename was
     kernel-watchdog-fix-spelling-mistake-permanetely-permanently.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Colin Ian King <colin.king@canonical.com>
Subject: kernel/watchdog_hld.c: fix spelling mistake: "permanetely" -> "permanently"

trivial fix to spelling mistake in pr_info message

Link: http://lkml.kernel.org/r/20170926093603.7756-1-colin.king@canonical.com
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Acked-by: Don Zickus <dzickus@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog_hld.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/watchdog_hld.c~kernel-watchdog-fix-spelling-mistake-permanetely-permanently kernel/watchdog_hld.c
--- a/kernel/watchdog_hld.c~kernel-watchdog-fix-spelling-mistake-permanetely-permanently
+++ a/kernel/watchdog_hld.c
@@ -280,7 +280,7 @@ int __init hardlockup_detector_perf_init
 	int ret = hardlockup_detector_event_create();
 
 	if (ret) {
-		pr_info("Perf NMI watchdog permanetely disabled\n");
+		pr_info("Perf NMI watchdog permanently disabled\n");
 	} else {
 		perf_event_release_kernel(this_cpu_read(watchdog_ev));
 		this_cpu_write(watchdog_ev, NULL);
_

Patches currently in -mm which might be from colin.king@canonical.com are

scripts-spellingtxt-add-more-spelling-mistakes-to-spellingtxt.patch
lib-lz4-make-arrays-static-const-reduces-object-code-size.patch

