From: akpm@linux-foundation.org
Subject: - ueagle-atmc-needs-schedh.patch removed from -mm tree
Date: Sat, 17 Feb 2007 18:15:21 -0800
Message-ID: <200702180215.l1I2FLFN008382@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:55758 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993142AbXBRCQp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 17 Feb 2007 21:16:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, greg@kroah.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     ueagle-atm.c needs sched.h
has been removed from the -mm tree.  Its filename was
     ueagle-atmc-needs-schedh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ueagle-atm.c needs sched.h
From: Randy Dunlap <randy.dunlap@oracle.com>

Driver needs sched.h for try_to_freeze().

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Greg KH <greg@kroah.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/atm/ueagle-atm.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN drivers/usb/atm/ueagle-atm.c~ueagle-atmc-needs-schedh drivers/usb/atm/ueagle-atm.c
--- a/drivers/usb/atm/ueagle-atm.c~ueagle-atmc-needs-schedh
+++ a/drivers/usb/atm/ueagle-atm.c
@@ -61,6 +61,7 @@
 #include <linux/usb.h>
 #include <linux/firmware.h>
 #include <linux/ctype.h>
+#include <linux/sched.h>
 #include <linux/kthread.h>
 #include <linux/version.h>
 #include <linux/mutex.h>
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
git-acpi.patch
git-drm.patch
sata-use-null-for-ptrs.patch
git-mtd.patch
git-netdev-all.patch
phy-layer-add-kernel-doc-docbook.patch
git-parisc.patch
x86-dont-probe-for-ddc-on-vbe12.patch
kernel-doc-include-struct-short-description-in-title.patch
tty-use-null-for-ptrs.patch
cdrom-use-unsigned-bitfields.patch
update-doc-oops-tracingtxt-for-taint_user.patch
update-doc-oops-tracingtxt-for-taint_user-fix.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes.patch
reiser4-use-null-for-pointers.patch
profile_likely-export-do_check_likely.patch
