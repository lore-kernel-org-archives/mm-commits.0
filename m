From: akpm@linux-foundation.org
Subject: + mm-sysctl-make-numa-stats-configurable-fix-fix.patch added to
 -mm tree
Date: Fri, 29 Sep 2017 15:04:53 -0700
Message-ID: <59cec385.gRrMDs3nfKlF0PXJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59954 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752042AbdI2WEy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Sep 2017 18:04:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, kemi.wang@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-sysctl-make-numa-stats-configurable-fix-fix
has been added to the -mm tree.  Its filename is
     mm-sysctl-make-numa-stats-configurable-fix-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-sysctl-make-numa-stats-configurable-fix-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-sysctl-make-numa-stats-configurable-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-sysctl-make-numa-stats-configurable-fix-fix

fix typo

Cc: Kemi Wang <kemi.wang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/vm.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/sysctl/vm.txt~mm-sysctl-make-numa-stats-configurable-fix-fix Documentation/sysctl/vm.txt
--- a/Documentation/sysctl/vm.txt~mm-sysctl-make-numa-stats-configurable-fix-fix
+++ a/Documentation/sysctl/vm.txt
@@ -853,7 +853,7 @@ ten times more freeable objects than the
 
 numa_stats_mode
 
-This interface allows runtime configuration or numa statistics.
+This interface allows runtime configuration of numa statistics.
 
 When page allocation performance becomes a bottleneck and you can tolerate
 some possible tool breakage and decreased numa counter precision, you can
diff -puN init/main.c~mm-sysctl-make-numa-stats-configurable-fix-fix init/main.c
diff -puN mm/vmstat.c~mm-sysctl-make-numa-stats-configurable-fix-fix mm/vmstat.c
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
scripts-spellingtxt-add-more-spelling-mistakes-to-spellingtxt-fix.patch
mm-oom_reaper-skip-mm-structs-with-mmu-notifiers-checkpatch-fixes.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
mm.patch
include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
mm-sysctl-make-numa-stats-configurable-fix.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch
mm-sysctl-make-numa-stats-configurable-fix-fix.patch

