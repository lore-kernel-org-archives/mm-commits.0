From: akpm@linux-foundation.org
Subject: +
 kernel-watchdog-fix-spelling-mistake-permanetely-permanently.patch added to -mm tree
Date: Tue, 26 Sep 2017 16:20:16 -0700
Message-ID: <59cae0b0./SarDPZblUGQsQ95%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38568 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965710AbdIZXUR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 26 Sep 2017 19:20:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: colin.king@canonical.com, dzickus@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/watchdog_hld.c: fix spelling mistake: "permanetely" -> "permanently"
has been added to the -mm tree.  Its filename is
     kernel-watchdog-fix-spelling-mistake-permanetely-permanently.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-watchdog-fix-spelling-mistake-permanetely-permanently.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-watchdog-fix-spelling-mistake-permanetely-permanently.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -275,7 +275,7 @@ int __init hardlockup_detector_perf_init
 	int ret = hardlockup_detector_event_create();
 
 	if (ret) {
-		pr_info("Perf NMI watchdog permanetely disabled\n");
+		pr_info("Perf NMI watchdog permanently disabled\n");
 	} else {
 		perf_event_release_kernel(this_cpu_read(watchdog_ev));
 		this_cpu_write(watchdog_ev, NULL);
_

Patches currently in -mm which might be from colin.king@canonical.com are

kernel-watchdog-fix-spelling-mistake-permanetely-permanently.patch

