From: akpm@linux-foundation.org
Subject: + drivers-connector-cn_procc-remove-unused-local.patch added to -mm tree
Date: Mon, 25 Jul 2011 14:27:01 -0700
Message-ID: <201107252205.p6PM5EDn032176@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56674 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753520Ab1GYWFS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jul 2011 18:05:18 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id p6PM5GfM003133
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Mon, 25 Jul 2011 15:05:16 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     drivers/connector/cn_proc.c: remove unused local
has been added to the -mm tree.  Its filename is
     drivers-connector-cn_procc-remove-unused-local.patch

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
Subject: drivers/connector/cn_proc.c: remove unused local
From: Andrew Morton <akpm@linux-foundation.org>

drivers/connector/cn_proc.c: In function 'proc_ptrace_connector':
drivers/connector/cn_proc.c:176: warning: unused variable 'tracer'


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/connector/cn_proc.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/connector/cn_proc.c~drivers-connector-cn_procc-remove-unused-local drivers/connector/cn_proc.c
--- a/drivers/connector/cn_proc.c~drivers-connector-cn_procc-remove-unused-local
+++ a/drivers/connector/cn_proc.c
@@ -173,7 +173,6 @@ void proc_ptrace_connector(struct task_s
 	struct proc_event *ev;
 	struct timespec ts;
 	__u8 buffer[CN_PROC_MSG_SIZE];
-	struct task_struct *tracer;
 
 	if (atomic_read(&proc_event_num_listeners) < 1)
 		return;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
hugetlb-add-phys-addr-to-struct-huge_bootmem_page-fix.patch
mm-use-const-struct-page-for-r-o-page-flag-accessor-methods-checkpatch-fixes.patch
xtensa-prevent-arbitrary-read-in-ptrace-fix.patch
mm-extend-memory-hotplug-api-to-allow-memory-hotplug-in-virtual-machines-fix.patch
pagewalk-add-locking-rule-comments-fix.patch
mm-memoryc-remove-zap_block_size.patch
mm-memblockc-avoid-abuse-of-red_inactive.patch
mm-preallocate-page-before-lock_page-at-filemap-cow.patch
mm-futex-fix-futex-writes-on-archs-with-sw-tracking-of-dirty-young-checkpatch-fixes.patch
mm-futex-fix-futex-writes-on-archs-with-sw-tracking-of-dirty-young-fix.patch
drivers-misc-add-support-the-fsa9480-usb-switch-fix.patch
lib-make-_tolower-public-checkpatch-fixes.patch
checkpatch-suggest-using-min_t-or-max_t-v2.patch
checkpatch-add-a-prefer-__aligned-check.patch
init-skip-calibration-delay-if-previously-done-fix.patch
init-skip-calibration-delay-if-previously-done-fix-fix.patch
init-skip-calibration-delay-if-previously-done-4.patch
drivers-rtc-add-support-for-qualcomm-pmic8xxx-rtc-fix.patch
drivers-connector-cn_procc-remove-unused-local.patch

