From: akpm@linux-foundation.org
Subject: - if-0-hpet_unregister.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:01:13 -0700
Message-ID: <200807252301.m6PN1Dn1003690@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60980 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750943AbYGYXB7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:01:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, clemens@ladisch.de, mm-commits@vger.kernel.org


The patch titled
     #if 0 hpet_unregister()
has been removed from the -mm tree.  Its filename was
     if-0-hpet_unregister.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: #if 0 hpet_unregister()
From: Adrian Bunk <bunk@kernel.org>

This patch #if 0's the unused hpet_unregister().

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/hpet.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/char/hpet.c~if-0-hpet_unregister drivers/char/hpet.c
--- a/drivers/char/hpet.c~if-0-hpet_unregister
+++ a/drivers/char/hpet.c
@@ -623,6 +623,7 @@ static inline int hpet_tpcheck(struct hp
 	return -ENXIO;
 }
 
+#if 0
 int hpet_unregister(struct hpet_task *tp)
 {
 	struct hpet_dev *devp;
@@ -652,6 +653,7 @@ int hpet_unregister(struct hpet_task *tp
 
 	return 0;
 }
+#endif  /*  0  */
 
 static ctl_table hpet_table[] = {
 	{
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
uninline-arch_pick_mmap_layout.patch
include-video-atmel_lcdch-must-include-linux-workqueueh.patch
linux-next.patch
m32r-remove-the-unused-nohighmem-option.patch
if-0-ses_match_host.patch
git-xtensa.patch
include-linux-kernelh-userspace-header-cleanup.patch
parport-sharec-proper-externs.patch
tpm_biosc-make-2-structs-static.patch
drm-make-drm_minors_cleanup-static.patch
make-cgroup_seqfile_release-static.patch
make-pnp_add_card_id-static.patch
make-parport_cs_release-static.patch
make-mm-sparsec-make-a-function-static.patch
mm-allocpercpuc-make-4-functions-static.patch
make-mm-memoryc-print_bad_pte-static.patch
mm-swapfilec-make-code-static.patch
make-mm-rmapc-anon_vma_cachep-static.patch
drivers-char-rtcc-make-2-functions-static.patch
make-init-do_mountsc-root_device_name-static.patch
make-macfb_setup-static.patch
video-console-sticonrec-make-code-static.patch
video-console-sticonrec-make-code-static-checkpatch-fixes.patch
video-stifbc-make-2-functions-static.patch
reiser4.patch

