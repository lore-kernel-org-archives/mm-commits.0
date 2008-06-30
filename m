From: akpm@linux-foundation.org
Subject: + delay-accounting-maintainer-update.patch added to -mm tree
Date: Mon, 30 Jun 2008 15:55:15 -0700
Message-ID: <200806302255.m5UMtFSc029907@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54061 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933507AbYF3Wz5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jun 2008 18:55:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: balbir@linux.vnet.ibm.com, nagar1234@in.ibm.com, nagar@watson.ibm.com


The patch titled
     delay accounting: maintainer update
has been added to the -mm tree.  Its filename is
     delay-accounting-maintainer-update.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: delay accounting: maintainer update
From: Balbir Singh <balbir@linux.vnet.ibm.com>

Update the delay accounting and taskstats maintainer to Balbir Singh.
I spoke to Shailabh and he is now busy with other things.

Cc: Shailabh Nagar <nagar1234@in.ibm.com>
Cc: Shailabh Nagar <nagar@watson.ibm.com>
Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN MAINTAINERS~delay-accounting-maintainer-update MAINTAINERS
--- a/MAINTAINERS~delay-accounting-maintainer-update
+++ a/MAINTAINERS
@@ -3231,8 +3231,8 @@ L:	netdev@vger.kernel.org
 S:	Maintained
 
 PER-TASK DELAY ACCOUNTING
-P:	Shailabh Nagar
-M:	nagar@watson.ibm.com
+P:	Balbir Singh
+M:	balbir@linux.vnet.ibm.com
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 
@@ -3926,8 +3926,8 @@ M:	hch@infradead.org
 S:	Maintained
 
 TASKSTATS STATISTICS INTERFACE
-P:	Shailabh Nagar
-M:	nagar@watson.ibm.com
+P:	Balbir Singh
+M:	balbir@linux.vnet.ibm.com
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 
_

Patches currently in -mm which might be from balbir@linux.vnet.ibm.com are

delay-accounting-maintainer-update.patch
cgroup-use-read-lock-to-guard-find_existing_css_set.patch
mark-res_counter_charge_locked-with-__must_check.patch
memcg-make-global-var-read_mostly.patch
memcg-avoid-unnecessary-initialization.patch
memcg-remove-refcnt-from-page_cgroup-fix-memcg-fix-mem_cgroup_end_migration-race.patch
memcg-clean-up-checking-of-the-disabled-flag.patch
memrlimit-add-memrlimit-controller-documentation.patch
memrlimit-setup-the-memrlimit-controller.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
memrlimit-add-memrlimit-controller-accounting-and-control-fix.patch
memrlimit-improve-error-handling.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch
distinct-tgid-tid-i-o-statistics.patch
per-task-delay-accounting-add-memory-reclaim-delay.patch
per-task-delay-accounting-update-document-and-getdelaysc-for-memory-reclaim.patch

