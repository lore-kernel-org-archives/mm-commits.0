From: akpm@linux-foundation.org
Subject: + memcg-fix-prepare-migration-fix.patch added to -mm tree
Date: Thu, 15 Apr 2010 17:24:01 -0400
Message-ID: <201004160025.o3G0PdfH007748@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35225 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758184Ab0DPAZ4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Apr 2010 20:25:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nishimura@mxp.nes.nec.co.jp, aarcange@redhat.com, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, stable@kernel.org


The patch titled
     memcg-fix-prepare-migration-fix
has been added to the -mm tree.  Its filename is
     memcg-fix-prepare-migration-fix.patch

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
Subject: memcg-fix-prepare-migration-fix
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

It seems that the original patch was mangled a bit when it was adjusted to
mainline.

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN mm/memcontrol.c~memcg-fix-prepare-migration-fix mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-prepare-migration-fix
+++ a/mm/memcontrol.c
@@ -2434,7 +2434,6 @@ int mem_cgroup_prepare_migration(struct 
 		ret = __mem_cgroup_try_charge(NULL, GFP_KERNEL, ptr, false);
 		css_put(&mem->css);
 	}
-	*ptr = mem;
 	return ret;
 }
 
_

Patches currently in -mm which might be from nishimura@mxp.nes.nec.co.jp are

memcg-fix-prepare-migration.patch
memcg-fix-prepare-migration-fix.patch
linux-next.patch
memcg-oom-wakeup-filter.patch
memcg-oom-wakeup-filter-update.patch
memcg-oom-notifier.patch
memcg-oom-notifier-update.patch
memcg-oom-kill-disable-and-oom-status.patch
memcg-oom-kill-disable-and-oom-status-update.patch
memcg-clean-up-move-charge.patch
memcg-move-charge-of-file-pages.patch
memcg-move-charge-of-file-pages-fix.patch

