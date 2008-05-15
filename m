From: akpm@linux-foundation.org
Subject: - pcmcia-kill-in_card_services.patch removed from -mm tree
Date: Thu, 15 May 2008 10:59:00 -0700
Message-ID: <200805151759.m4FHx04o002863@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53699 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764596AbYEOR7e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 May 2008 13:59:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, mm-commits@vger.kernel.org


The patch titled
     pcmcia: kill IN_CARD_SERVICES
has been removed from the -mm tree.  Its filename was
     pcmcia-kill-in_card_services.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pcmcia: kill IN_CARD_SERVICES
From: Adrian Bunk <bunk@kernel.org>

IN_CARD_SERVICES was #define'd but not used, so let's remove it.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pcmcia/cardbus.c         |    1 -
 drivers/pcmcia/cs.c              |    1 -
 drivers/pcmcia/ds.c              |    1 -
 drivers/pcmcia/pcmcia_ioctl.c    |    1 -
 drivers/pcmcia/pcmcia_resource.c |    1 -
 drivers/pcmcia/socket_sysfs.c    |    1 -
 6 files changed, 6 deletions(-)

diff -puN drivers/pcmcia/cardbus.c~pcmcia-kill-in_card_services drivers/pcmcia/cardbus.c
--- a/drivers/pcmcia/cardbus.c~pcmcia-kill-in_card_services
+++ a/drivers/pcmcia/cardbus.c
@@ -30,7 +30,6 @@
 #include <asm/irq.h>
 #include <asm/io.h>
 
-#define IN_CARD_SERVICES
 #include <pcmcia/cs_types.h>
 #include <pcmcia/ss.h>
 #include <pcmcia/cs.h>
diff -puN drivers/pcmcia/cs.c~pcmcia-kill-in_card_services drivers/pcmcia/cs.c
--- a/drivers/pcmcia/cs.c~pcmcia-kill-in_card_services
+++ a/drivers/pcmcia/cs.c
@@ -32,7 +32,6 @@
 #include <asm/system.h>
 #include <asm/irq.h>
 
-#define IN_CARD_SERVICES
 #include <pcmcia/cs_types.h>
 #include <pcmcia/ss.h>
 #include <pcmcia/cs.h>
diff -puN drivers/pcmcia/ds.c~pcmcia-kill-in_card_services drivers/pcmcia/ds.c
--- a/drivers/pcmcia/ds.c~pcmcia-kill-in_card_services
+++ a/drivers/pcmcia/ds.c
@@ -25,7 +25,6 @@
 #include <linux/kref.h>
 #include <linux/dma-mapping.h>
 
-#define IN_CARD_SERVICES
 #include <pcmcia/cs_types.h>
 #include <pcmcia/cs.h>
 #include <pcmcia/cistpl.h>
diff -puN drivers/pcmcia/pcmcia_ioctl.c~pcmcia-kill-in_card_services drivers/pcmcia/pcmcia_ioctl.c
--- a/drivers/pcmcia/pcmcia_ioctl.c~pcmcia-kill-in_card_services
+++ a/drivers/pcmcia/pcmcia_ioctl.c
@@ -29,7 +29,6 @@
 #include <linux/pci.h>
 #include <linux/workqueue.h>
 
-#define IN_CARD_SERVICES
 #include <pcmcia/cs_types.h>
 #include <pcmcia/cs.h>
 #include <pcmcia/cistpl.h>
diff -puN drivers/pcmcia/pcmcia_resource.c~pcmcia-kill-in_card_services drivers/pcmcia/pcmcia_resource.c
--- a/drivers/pcmcia/pcmcia_resource.c~pcmcia-kill-in_card_services
+++ a/drivers/pcmcia/pcmcia_resource.c
@@ -21,7 +21,6 @@
 #include <linux/pci.h>
 #include <linux/device.h>
 
-#define IN_CARD_SERVICES
 #include <pcmcia/cs_types.h>
 #include <pcmcia/ss.h>
 #include <pcmcia/cs.h>
diff -puN drivers/pcmcia/socket_sysfs.c~pcmcia-kill-in_card_services drivers/pcmcia/socket_sysfs.c
--- a/drivers/pcmcia/socket_sysfs.c~pcmcia-kill-in_card_services
+++ a/drivers/pcmcia/socket_sysfs.c
@@ -27,7 +27,6 @@
 #include <asm/system.h>
 #include <asm/irq.h>
 
-#define IN_CARD_SERVICES
 #include <pcmcia/cs_types.h>
 #include <pcmcia/ss.h>
 #include <pcmcia/cs.h>
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
linux-next.patch
proper-prototype-for-acpi_processor_tstate_has_changed.patch
drm-make-drm_minors_cleanup-static.patch
git-input.patch
nfs-make-nfs4_drop_state_owner-static.patch
show_schedstat-fix-memleak.patch
if-0-ses_match_host.patch
git-watchdog.patch
git-xtensa.patch
mm-migratec-should-include-linux-syscallsh.patch
mm-vmstatc-proper-externs.patch
mm-hugetlbc-fix-duplicate-variable.patch
remove-include-asm-h8300-keyboardh.patch
pcmcia-kill-in_card_services.patch
remove-the-v850-port.patch
init-do_mountsc-should-include-linux-initrdh.patch
proper-spawn_ksoftirqd-prototype.patch
serial-8250_gscc-add-module_license.patch
mfd-sm501c-if-0-unused-functions.patch
xen-drivers-xen-balloonc-make-a-function-static.patch
video-sis-remove-compat-code.patch
minix-remove-no_truncate-code.patch
remove-is_tty.patch
proper-extern-for-mwave_s_mdd.patch
if-0-hpet_unregister.patch
unexport-proc_clear_tty.patch
move-proc_kmsg_operations-to-fs-proc-internalh.patch
proper-pidhashmap_init-prototypes.patch
unexport-uts_sem.patch
parport-sharec-proper-externs.patch
tpm_biosc-make-2-structs-static.patch
make-cgroup_seqfile_release-static.patch
make-kprobe_blacklist-static.patch
make-pnp_add_card_id-static.patch
make-struct-mpt_proc_root_dir-static.patch
make-parport_cs_release-static.patch
make-mm-sparsec-make-a-function-static.patch
mm-allocpercpuc-make-4-functions-static.patch
make-mm-memoryc-print_bad_pte-static.patch
mm-swapfilec-make-code-static.patch
make-mm-rmapc-anon_vma_cachep-static.patch
drivers-char-rtcc-make-2-functions-static.patch
make-init-do_mountsc-root_device_name-static.patch
reiser4.patch

