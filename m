From: akpm@linux-foundation.org
Subject: + ueagle-atmc-needs-schedh.patch added to -mm tree
Date: Wed, 07 Feb 2007 12:37:05 -0800
Message-ID: <200702072037.l17Kb59E026427@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35505 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422729AbXBGUi0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Feb 2007 15:38:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, greg@kroah.com, stable@kernel.org


The patch titled
     ueagle-atm.c needs sched.h
has been added to the -mm tree.  Its filename is
     ueagle-atmc-needs-schedh.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
git-alsa.patch
update-readmedrm-bugzilla-7933.patch
qconf-immediately-update-integer-and-string-values-in-xconfig-display-take-2.patch
mtd-add-missing-kernel-doc-item.patch
git-ocfs2.patch
parisc-fix-module_param-iommu-permission.patch
git-scsi-misc.patch
ueagle-atmc-needs-schedh.patch
math-emu-setcc-avoid-gcc-extension.patch
typeof-__page_to_pfn-with-sparsemem=y.patch
docbook-html-correction-of-recursive-a-tags-in-html-output.patch
kernel-doc-allow-a-little-whitespace.patch
sysrq-alphabetize-command-keys-doc.patch
kernel-doc-allow-more-whitespace.patch
discuss-a-couple-common-errors-in-kernel-doc-usage.patch
docbook-add-edd-firmware-interfaces.patch
kernel-doc-fix-some-odd-spacing-issues.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes.patch
reiser4-use-null-for-pointers.patch
profile_likely-export-do_check_likely.patch
