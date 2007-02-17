From: akpm@linux-foundation.org
Subject: - irq-kernel-doc-fixes.patch removed from -mm tree
Date: Fri, 16 Feb 2007 23:15:54 -0800
Message-ID: <200702170715.l1H7Fs7C021669@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51120 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946490AbXBQHQ0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 17 Feb 2007 02:16:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     IRQ kernel-doc fixes
has been removed from the -mm tree.  Its filename was
     irq-kernel-doc-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: IRQ kernel-doc fixes
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kernel-doc warnings in IRQ management.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/irq.h |    1 +
 kernel/irq/chip.c   |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff -puN include/linux/irq.h~irq-kernel-doc-fixes include/linux/irq.h
--- a/include/linux/irq.h~irq-kernel-doc-fixes
+++ a/include/linux/irq.h
@@ -129,6 +129,7 @@ struct irq_chip {
  *
  * @handle_irq:		highlevel irq-events handler [if NULL, __do_IRQ()]
  * @chip:		low level interrupt hardware access
+ * @msi_desc:		MSI descriptor
  * @handler_data:	per-IRQ data for the irq_chip methods
  * @chip_data:		platform-specific per-chip private data for the chip
  *			methods, to allow shared chip implementations
diff -puN kernel/irq/chip.c~irq-kernel-doc-fixes kernel/irq/chip.c
--- a/kernel/irq/chip.c~irq-kernel-doc-fixes
+++ a/kernel/irq/chip.c
@@ -168,7 +168,7 @@ EXPORT_SYMBOL(set_irq_data);
 /**
  *	set_irq_data - set irq type data for an irq
  *	@irq:	Interrupt number
- *	@data:	Pointer to interrupt specific data
+ *	@entry:	Pointer to MSI descriptor data
  *
  *	Set the hardware irq controller data for an irq
  */
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
git-acpi.patch
build-errors-uevent-with-config_sysfs=n.patch
git-drm.patch
sata-use-null-for-ptrs.patch
git-mtd.patch
git-netdev-all.patch
phy-layer-add-kernel-doc-docbook.patch
ueagle-atmc-needs-schedh.patch
kernel-doc-include-struct-short-description-in-title.patch
tty-use-null-for-ptrs.patch
cdrom-use-unsigned-bitfields.patch
update-doc-oops-tracingtxt-for-taint_user.patch
update-doc-oops-tracingtxt-for-taint_user-fix.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes.patch
reiser4-use-null-for-pointers.patch
profile_likely-export-do_check_likely.patch
