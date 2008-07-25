From: akpm@linux-foundation.org
Subject: - unexport-proc_clear_tty.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:02:07 -0700
Message-ID: <200807252302.m6PN278s003798@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41892 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755229AbYGYXHD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:07:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, alan@redhat.com, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     unexport proc_clear_tty
has been removed from the -mm tree.  Its filename was
     unexport-proc_clear_tty.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: unexport proc_clear_tty
From: Adrian Bunk <bunk@kernel.org>

With the removal of the Solaris binary emulation the export of
proc_clear_tty became unused.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: David S. Miller <davem@davemloft.net>
Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tty_io.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/char/tty_io.c~unexport-proc_clear_tty drivers/char/tty_io.c
--- a/drivers/char/tty_io.c~unexport-proc_clear_tty
+++ a/drivers/char/tty_io.c
@@ -3580,7 +3580,6 @@ void proc_clear_tty(struct task_struct *
 	p->signal->tty = NULL;
 	spin_unlock_irq(&p->sighand->siglock);
 }
-EXPORT_SYMBOL(proc_clear_tty);
 
 /* Called under the sighand lock */
 
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

