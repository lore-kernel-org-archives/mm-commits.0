From: akpm@linux-foundation.org
Subject: - linux-audith-needs-linux-typesh.patch removed from -mm tree
Date: Tue, 06 Mar 2007 20:21:41 -0800
Message-ID: <200703070421.l274LfTe018920@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47050 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161319AbXCGEVp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Mar 2007 23:21:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     linux/audit.h needs linux/types.h
has been removed from the -mm tree.  Its filename was
     linux-audith-needs-linux-typesh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: linux/audit.h needs linux/types.h
From: Jeff Dike <jdike@addtoit.com>

Include linux/types.h here because we need a definition of __u32.  This file
appears not be exported verbatim by libc, so I think this doesn't have any
userspace consequences.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/audit.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/audit.h~linux-audith-needs-linux-typesh include/linux/audit.h
--- a/include/linux/audit.h~linux-audith-needs-linux-typesh
+++ a/include/linux/audit.h
@@ -24,6 +24,7 @@
 #ifndef _LINUX_AUDIT_H_
 #define _LINUX_AUDIT_H_
 
+#include <linux/types.h>
 #include <linux/elf-em.h>
 
 /* The netlink messages for the audit system is divided into blocks:
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
uml-hostfs-fix-double-free.patch
uml-hostfs-make-hostfs=-option-work-as-a-jail-as-intended.patch
uml-fix-a-memory-leak-in-the-multicast-driver.patch
uml-remove-dead-code-about-os_usr1_signal-and-os_usr1_process.patch
uml-mark-both-consoles-as-con_anytime.patch
uml-fix-confusion-irq-early-reenabling.patch
uml-activate_fd-return-enomem-only-when-appropriate.patch
uml-fix-errno-usage.patch
div64_64-common-code.patch
remove-hardcoding-of-hard_smp_processor_id-on-up.patch
uml-delete-unused-code.patch
uml-formatting-fixes.patch
uml-host_info-tidying.patch
uml-mark-tt-mode-code-for-future-removal.patch
uml-print-coredump-limits.patch
uml-handle-block-device-hotplug-errors.patch
uml-driver-formatting-fixes.patch
uml-driver-formatting-fixes-fix.patch
uml-network-interface-hotplug-error-handling.patch
uml-fix-prototypes.patch
