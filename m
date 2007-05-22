From: akpm@linux-foundation.org
Subject: + xen-build-fix.patch added to -mm tree
Date: Mon, 21 May 2007 22:15:23 -0700
Message-ID: <200705220518.l4M5IbNs027992@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45448 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755343AbXEVFUa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 May 2007 01:20:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ak@suse.de, jeremy@goop.org


The patch titled
     xen-build-fix
has been added to the -mm tree.  Its filename is
     xen-build-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: xen-build-fix

From

arch/i386/xen/setup.c: In function 'xen_idle':
arch/i386/xen/setup.c:47: warning: implicit declaration of function 'need_resched'

Cc: Andi Kleen <ak@suse.de>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/xen/setup.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/i386/xen/setup.c~xen-build-fix arch/i386/xen/setup.c
--- a/arch/i386/xen/setup.c~xen-build-fix
+++ a/arch/i386/xen/setup.c
@@ -6,6 +6,7 @@
 
 #include <linux/module.h>
 #include <linux/mm.h>
+#include <linux/sched.h>
 #include <linux/pm.h>
 
 #include <asm/elf.h>
_

Patches currently in -mm which might be from ak@suse.de are

origin.patch
serial-set-dtr-in-uart-for-kernel-serial-console.patch
remove-pci_dac_dma_-apis.patch
git-pciseg.patch
xen-build-fix.patch
fix-x86_64-mm-sched-clock-share.patch
make-arch-i386-kernel-setupcremapped_pgdat_init-static.patch
quicklist-support-for-x86_64.patch
x86_64-extract-helper-function-from-e820_register_active_regions.patch
x86_64-fix-e820_hole_size-based-on-address-ranges.patch
x86_64-acpi-disable-srat-when-numa-emulation-succeeds.patch
x86_64-slit-fake-pxm-to-node-mapping-for-fake-numa-2.patch
x86_64-numa-fake-apicid_to_node-mapping-for-fake-numa-2.patch
i386-hpet-check-if-the-counter-works.patch
mmconfig-x86_64-i386-insert-unclaimed-mmconfig-resources.patch
mmconfig-x86_64-i386-insert-unclaimed-mmconfig-resources-fix.patch
mmconfig-x86_64-i386-insert-unclaimed-mmconfig-resources-update.patch
i386-pci-fixup-for-siemens-nixdorf-ag-fsc-multiprocessor-interrupt-controllers.patch
x86_64-fix-smp_call_function_single-return-value.patch
x86_64-build-and-use-gdt-on-copied-compressed-kernel.patch
i386-efi-fix-proc-iomem-type-for-kexec-tools.patch
x86_64-o_excl-on-dev-mcelog.patch
x86_64-support-poll-on-dev-mcelog.patch
x86_64-mcelog-tolerant-level-cleanup.patch
x86_64-mce-poll-at-idle_start-and-printk-fix.patch
i386-fix-machine-rebooting.patch
x86_64-ratelimit-segfault-reporting-rate.patch
avoid-zero-size-allocation-in-cache_k8_northbridges.patch
x86_64-allocate-sparsemem-memmap-above-4g.patch
x86_64-allocate-sparsemem-memmap-above-4g-fix.patch
change-zonelist-order-zonelist-order-selection-logic.patch
change-zonelist-order-v6-zonelist-fix.patch
change-zonelist-order-auto-configuration.patch
change-zonelist-order-documentaion.patch
revoke-add-documentation.patch
revoke-wire-up-i386-system-calls.patch
lguest-the-guest-code.patch
lguest-the-host-code.patch
lguest-the-asm-offsets.patch
lguest-the-makefile-and-kconfig.patch
lguest-the-console-driver.patch
lguest-the-net-driver.patch
lguest-the-block-driver.patch
lguest-the-block-driver-tidyups-update.patch
lguest-the-documentation-example-launcher.patch
fallocate-implementation-on-i86-x86_64-and-powerpc.patch
