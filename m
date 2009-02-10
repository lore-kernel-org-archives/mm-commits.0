From: akpm@linux-foundation.org
Subject: + cgroups-add-li-zefan-as-a-maintainer.patch added to -mm tree
Date: Tue, 10 Feb 2009 15:20:25 -0800
Message-ID: <200902102320.n1ANKPRG005726@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51631 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756101AbZBJXUg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Feb 2009 18:20:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com


The patch titled
     cgroups: add Li Zefan as a maintainer
has been added to the -mm tree.  Its filename is
     cgroups-add-li-zefan-as-a-maintainer.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroups: add Li Zefan as a maintainer
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Add Li Zefan as co-maintainer.

Acked-by: Paul Menage <menage@google.com>
Acked-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 ++
 1 file changed, 2 insertions(+)

diff -puN MAINTAINERS~cgroups-add-li-zefan-as-a-maintainer MAINTAINERS
--- a/MAINTAINERS~cgroups-add-li-zefan-as-a-maintainer
+++ a/MAINTAINERS
@@ -1202,6 +1202,8 @@ S:	Supported
 CONTROL GROUPS (CGROUPS)
 P:	Paul Menage
 M:	menage@google.com
+P:	Li Zefan
+M:	lizf@cn.fujitsu.com
 L:	containers@lists.linux-foundation.org
 S:	Maintained
 
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

mm-fix-mlocked-page-counter-mismatch.patch
cgroups-add-li-zefan-as-a-maintainer.patch
linux-next.patch
mm-fix-memmap-init-to-initialize-valid-memmap-for-memory-hole-fix.patch
get_mm_hiwater_xxx-trivial-s-define-inline.patch
swsusp-clean-up-shrink_all_zones.patch
swsusp-dont-fiddle-with-swappiness.patch
vmscan-rename-scmay_swap-to-may_unmap.patch
mm-introduce-for_each_populated_zone-macro.patch
mm-introduce-for_each_populated_zone-macro-cleanup.patch
getrusage-fill-ru_maxrss-value.patch
softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-export-statistics-for-softirq-to-proc-fix.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch
memcg-remove-mem_cgroup_calc_mapped_ratio-take2.patch
memcg-remove-mem_cgroup_reclaim_imbalance-remnants.patch
ia64-implement-interrupt-enabling-rwlocks.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

