From: akpm@linux-foundation.org
Subject: - mm-slubc-make-code-static.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:01:20 -0700
Message-ID: <200707172301.l6HN1KQ5011381@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37946 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935394AbXGQXQJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:16:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     mm/slub.c: make code static
has been removed from the -mm tree.  Its filename was
     mm-slubc-make-code-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mm/slub.c: make code static
From: Adrian Bunk <bunk@stusta.de>

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/slub.c~mm-slubc-make-code-static mm/slub.c
--- a/mm/slub.c~mm-slubc-make-code-static
+++ a/mm/slub.c
@@ -233,7 +233,7 @@ static enum {
 
 /* A list of all slab caches on the system */
 static DECLARE_RWSEM(slub_lock);
-LIST_HEAD(slab_caches);
+static LIST_HEAD(slab_caches);
 
 /*
  * Tracking user of a slab.
@@ -3638,7 +3638,7 @@ static struct kset_uevent_ops slab_ueven
 	.filter = uevent_filter,
 };
 
-decl_subsys(slab, &slab_ktype, &slab_uevent_ops);
+static decl_subsys(slab, &slab_ktype, &slab_uevent_ops);
 
 #define ID_STR_LENGTH 64
 
@@ -3736,7 +3736,7 @@ struct saved_alias {
 	struct saved_alias *next;
 };
 
-struct saved_alias *alias_list;
+static struct saved_alias *alias_list;
 
 static int sysfs_slab_alias(struct kmem_cache *s, const char *name)
 {
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
git-acpi.patch
cpuidle-add-rating-to-the-governors-and-pick-the-one-with-highest-rating-by-default-fix.patch
drivers-acpi-sbsc-remove-dead-code.patch
git-alsa.patch
git-dvb.patch
git-hwmon.patch
git-kbuild.patch
git-kvm.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
git-mtd.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-wd33c93c-cleanups.patch
make-seagate_st0x_detect-static.patch
drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code.patch
git-unionfs.patch
git-ipwireless_cs.patch
fix-x86_64-mm-xen-add-xen-virtual-block-device-driver.patch
fix-x86_64-mm-xen-xen-event-channels.patch
arch-i386-xen-mmuc-must-include-linux-schedh.patch
make-arch-i386-kernel-setupcremapped_pgdat_init-static.patch
arch-i386-kernel-i8253c-should-include-asm-timerh.patch
make-arch-i386-kernel-io_apicctimer_irq_works-static-again.patch
i386-remove-support-for-the-rise-cpu.patch
i386-make-arch-i386-mm-pgtablecpgd_cdtor-static.patch
xen-fix-x86-config-dependencies.patch
xen-suppress-abs-symbol-warnings-for-unused-reloc-pointers.patch
xen-cant-support-numa-yet.patch
arch-i386-kernel-smpbootcsetup_trampoline-must-be.patch
maps2-add-proc-kpagemap-interface.patch
swsusp-remove-code-duplication-between-diskc-and-userc.patch
fs-reiserfs-cleanups.patch
introduce-i_sync-fix.patch
ext2-reservations.patch
intel-iommu-intel-iommu-driver.patch
mm-variable-length-argument-support.patch
revoke-core-code.patch
mm-implement-swap-prefetching.patch
kernel-relayc-make-functions-static.patch
drivers-edac-core-make-functions-static.patch
lockstat-human-readability-tweaks.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch
