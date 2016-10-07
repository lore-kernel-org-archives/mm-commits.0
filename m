From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-memcontrol-consolidate-cgroup-socket-tracking-checkpatch-fixes.patch
 removed from -mm tree
Date: Fri, 07 Oct 2016 16:40:39 -0700
Message-ID: <57f83277.JmlDUu+6A3g0u+3z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38392 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932817AbcJGXkk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Oct 2016 19:40:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memcontrol-consolidate-cgroup-socket-tracking-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-consolidate-cgroup-socket-tracking-checkpatch-fixes.patch

This patch was dropped because it was folded into mm-memcontrol-consolidate-cgroup-socket-tracking.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memcontrol-consolidate-cgroup-socket-tracking-checkpatch-fixes

WARNING: line over 80 characters
#49: FILE: mm/memcontrol.c:2942:
+		 * function is the last one to run. See mem_cgroup_sk_alloc() for

total: 0 errors, 1 warnings, 0 checks, 105 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/mm-memcontrol-consolidate-cgroup-socket-tracking.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrol-consolidate-cgroup-socket-tracking-checkpatch-fixes mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-consolidate-cgroup-socket-tracking-checkpatch-fixes
+++ a/mm/memcontrol.c
@@ -2939,9 +2939,9 @@ static int memcg_update_tcp_limit(struct
 		/*
 		 * The active flag needs to be written after the static_key
 		 * update. This is what guarantees that the socket activation
-		 * function is the last one to run. See mem_cgroup_sk_alloc() for
-		 * details, and note that we don't mark any socket as belonging
-		 * to this memcg until that flag is up.
+		 * function is the last one to run. See mem_cgroup_sk_alloc()
+		 * for details, and note that we don't mark any socket as
+		 * belonging to this memcg until that flag is up.
 		 *
 		 * We need to do this, because static_keys will span multiple
 		 * sites, but we can't control their order. If we mark a socket
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_ioc-replace-some-bug_ons-with-vm_bug_on_page.patch
mm-memcontrol-consolidate-cgroup-socket-tracking.patch
mmksm-add-__gfp_high-to-the-allocation-in-alloc_stable_node-v2-fix.patch
seq-proc-modify-seq_put_decimal_ll-to-take-a-const-char-not-char-fix.patch
a.patch

