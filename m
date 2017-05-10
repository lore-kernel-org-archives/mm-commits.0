From: akpm@linux-foundation.org
Subject: +
 hwpoison-memcg-forcibly-uncharge-lru-pages-checkpatch-fixes.patch added to
 -mm tree
Date: Wed, 10 May 2017 15:25:12 -0700
Message-ID: <59139348.J/QZSEPuMvG95TIU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40792 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753655AbdEJWZN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 10 May 2017 18:25:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hwpoison-memcg-forcibly-uncharge-lru-pages-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     hwpoison-memcg-forcibly-uncharge-lru-pages-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hwpoison-memcg-forcibly-uncharge-lru-pages-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hwpoison-memcg-forcibly-uncharge-lru-pages-checkpatch-fixes.patch

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
Subject: hwpoison-memcg-forcibly-uncharge-lru-pages-checkpatch-fixes

ERROR: Please use git commit description style 'commit <12+ chars of sha1> ("<title line>")' - ie: 'commit 0123456789ab ("commit description")'
#12: 
least not since 0a31bc97c80c ("mm: memcontrol: rewrite uncharge API")). 

ERROR: Please use git commit description style 'commit <12+ chars of sha1> ("<title line>")' - ie: 'commit 0123456789ab ("commit description")'
#13: 
Each charge pins memcg (since e8ea14cc6ead ("mm: memcontrol: take a css

WARNING: line over 80 characters
#54: FILE: mm/memory-failure.c:544:
+		 * Poisoned page might never drop its ref count to 0 so we have to

total: 2 errors, 1 warnings, 21 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/hwpoison-memcg-forcibly-uncharge-lru-pages.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/memory-failure.c~hwpoison-memcg-forcibly-uncharge-lru-pages-checkpatch-fixes mm/memory-failure.c
--- a/mm/memory-failure.c~hwpoison-memcg-forcibly-uncharge-lru-pages-checkpatch-fixes
+++ a/mm/memory-failure.c
@@ -541,8 +541,8 @@ static int delete_from_lru_cache(struct
 		ClearPageUnevictable(p);
 
 		/*
-		 * Poisoned page might never drop its ref count to 0 so we have to
-		 * uncharge it manually from its memcg.
+		 * Poisoned page might never drop its ref count to 0 so we have
+		 * to uncharge it manually from its memcg.
 		 */
 		mem_cgroup_uncharge(p);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
hwpoison-memcg-forcibly-uncharge-lru-pages-checkpatch-fixes.patch
gcov-support-gcc-71-v2-checkpatch-fixes.patch
mm-vmalloc-fix-vmalloc-users-tracking-properly-checkpatch-fixes.patch
tigran-has-moved.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
mm.patch
mm-slub-wrap-cpu_slab-partial-in-config_slub_cpu_partial-fix.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
fault-inject-support-systematic-fault-injection-fix.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

