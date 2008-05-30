From: akpm@linux-foundation.org
Subject: - xen-drivers-xen-balloonc-make-a-function-static.patch removed from -mm tree
Date: Fri, 30 May 2008 15:39:44 -0700
Message-ID: <200805302239.m4UMdiAl014934@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44134 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752885AbYE3Wky (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 May 2008 18:40:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, chrisw@sous-sol.org, mm-commits@vger.kernel.org


The patch titled
     xen: drivers/xen/balloon.c: make a function static
has been removed from the -mm tree.  Its filename was
     xen-drivers-xen-balloonc-make-a-function-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: xen: drivers/xen/balloon.c: make a function static
From: Adrian Bunk <bunk@kernel.org>

Make the needlessly global balloon_set_new_target() static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/xen/balloon.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/xen/balloon.c~xen-drivers-xen-balloonc-make-a-function-static drivers/xen/balloon.c
--- a/drivers/xen/balloon.c~xen-drivers-xen-balloonc-make-a-function-static
+++ a/drivers/xen/balloon.c
@@ -368,7 +368,7 @@ static void balloon_process(struct work_
 }
 
 /* Resets the Xen limit, sets new target, and kicks off processing. */
-void balloon_set_new_target(unsigned long target)
+static void balloon_set_new_target(unsigned long target)
 {
 	/* No need for lock. Not read-modify-write updates. */
 	balloon_stats.hard_limit   = ~0UL;
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
frv-dont-offer-binfmt_flat.patch
linux-next.patch
proper-prototype-for-acpi_processor_tstate_has_changed.patch
remove-drivers-acorn-char-defkeymap-l7200c.patch
drm-make-drm_minors_cleanup-static.patch
if-0-ses_match_host.patch
git-xtensa.patch
mm-migratec-should-include-linux-syscallsh.patch
mm-vmstatc-proper-externs.patch
mm-hugetlbc-fix-duplicate-variable.patch
remove-include-asm-h8300-keyboardh.patch
remove-the-v850-port.patch
init-do_mountsc-should-include-linux-initrdh.patch
proper-spawn_ksoftirqd-prototype.patch
build-kernel-profileo-only-when-requested.patch
build-kernel-profileo-only-when-requested-cleanups.patch
asm-generic-int-ll64h-always-provide-__su64.patch
remove-some-more-tipar-bits.patch
remove-the-oss-trident-driver.patch
config_sound_wm97xx-remove-stale-makefile-line.patch
serial-8250_gscc-add-module_license.patch
mfd-sm501c-if-0-unused-functions.patch
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

