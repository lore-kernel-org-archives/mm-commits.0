From: akpm@linux-foundation.org
Subject: +
 mm-oom-docs-describe-the-cgroup-aware-oom-killer-fix-2-fix.patch added to
 -mm tree
Date: Tue, 30 Jan 2018 11:40:01 -0800
Message-ID: <5a70ca11.tvzPCyNJZrtsuUHm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53812 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751883AbeA3TkE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 30 Jan 2018 14:40:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, guro@fb.com, hannes@cmpxchg.org, mhocko@suse.com, penguin-kernel@i-love.sakura.ne.jp, rientjes@google.com, tj@kernel.org, vdavydov.dev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-oom-docs-describe-the-cgroup-aware-oom-killer-fix-2-fix
has been added to the -mm tree.  Its filename is
     mm-oom-docs-describe-the-cgroup-aware-oom-killer-fix-2-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-oom-docs-describe-the-cgroup-aware-oom-killer-fix-2-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-oom-docs-describe-the-cgroup-aware-oom-killer-fix-2-fix.patch

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
Subject: mm-oom-docs-describe-the-cgroup-aware-oom-killer-fix-2-fix

tweak text, fix typo

Cc: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroup-v2.txt |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN Documentation/cgroup-v2.txt~mm-oom-docs-describe-the-cgroup-aware-oom-killer-fix-2-fix Documentation/cgroup-v2.txt
--- a/Documentation/cgroup-v2.txt~mm-oom-docs-describe-the-cgroup-aware-oom-killer-fix-2-fix
+++ a/Documentation/cgroup-v2.txt
@@ -1292,13 +1292,13 @@ of the OOM'ing cgroup.
 
 Leaf cgroups and cgroups with oom_group option set are compared based
 on their cumulative memory usage. The root cgroup is treated as a
-leaf memory cgroup as well, so it's compared with other leaf memory
+leaf memory cgroup as well, so it is compared with other leaf memory
 cgroups. Due to internal implementation restrictions the size of
-the root cgroup is a cumulative sum of oom_badness of all its tasks
+the root cgroup is the cumulative sum of oom_badness of all its tasks
 (in other words oom_score_adj of each task is obeyed). Relying on
-oom_score_adj (appart from OOM_SCORE_ADJ_MIN) can lead to over or
-underestimating of the root cgroup consumption and it is therefore
-discouraged. This might change in the future, though.
+oom_score_adj (apart from OOM_SCORE_ADJ_MIN) can lead to over- or
+underestimation of the root cgroup consumption and it is therefore
+discouraged. This might change in the future, however.
 
 If there are no cgroups with the enabled memory controller,
 the OOM killer is using the "traditional" process-based approach.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-terminate-shrink_slab-loop-if-signal-is-pending-fix.patch
include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
mm-split-deferred_init_range-into-initializing-and-freeing-parts-fix.patch
mm-do-not-stall-register_shrinker-fix.patch
list_lru-prefetch-neighboring-list-entries-before-acquiring-lock-fix.patch
mm-oom-cgroup-aware-oom-killer-fix.patch
mm-oom-docs-describe-the-cgroup-aware-oom-killer-fix-2-fix.patch
sparc64-update-pmdp_invalidate-to-return-old-pmd-value-fix.patch
x86-mm-provide-pmdp_establish-helper-fix.patch
fs-elf-drop-map_fixed-usage-from-elf_map-checkpatch-fixes.patch
mm-thp-use-down_read_trylock-in-khugepaged-to-avoid-long-block-fix.patch
mm-thp-use-down_read_trylock-in-khugepaged-to-avoid-long-block-fix-checkpatch-fixes.patch
mm-mmu_notifier-annotate-mmu-notifiers-with-blockable-invalidate-callbacks-fix.patch
mm-zsmalloc-simplify-shrinker-init-destroy-fix.patch
mm-fadvise-discard-partial-page-if-endbyte-is-also-eof-fix.patch
mm-page_owner-clean-up-init_pages_in_zone-v3-fix.patch
mm-migrate-remove-reason-argument-from-new_page_t-fix-fix.patch
kasan-clean-up-kasan_shadow_scale_shift-usage-checkpatch-fixes.patch
lib-ubsanc-s-missaligned-misaligned.patch
linux-next-rejects.patch
fs-crypto-hooksc-fix-build-with-gcc-444.patch
maintainers-update-arm-oxnas-platform-support-patterns-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

