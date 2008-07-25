From: akpm@linux-foundation.org
Subject: - remove-some-more-tipar-bits.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:54:39 -0700
Message-ID: <200807252254.m6PMsdBg002840@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35335 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752539AbYGYWzR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 18:55:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, mm-commits@vger.kernel.org


The patch titled
     remove some more tipar bits
has been removed from the -mm tree.  Its filename was
     remove-some-more-tipar-bits.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: remove some more tipar bits
From: Adrian Bunk <bunk@kernel.org>

Some bits were missed when the tipar driver was removed.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/00-INDEX              |    2 --
 Documentation/kernel-parameters.txt |    7 -------
 drivers/char/Makefile               |    1 -
 3 files changed, 10 deletions(-)

diff -puN Documentation/00-INDEX~remove-some-more-tipar-bits Documentation/00-INDEX
--- a/Documentation/00-INDEX~remove-some-more-tipar-bits
+++ a/Documentation/00-INDEX
@@ -361,8 +361,6 @@ telephony/
 	- directory with info on telephony (e.g. voice over IP) support.
 time_interpolators.txt
 	- info on time interpolators.
-tipar.txt
-	- information about Parallel link cable for Texas Instruments handhelds.
 tty.txt
 	- guide to the locking policies of the tty layer.
 uml/
diff -puN Documentation/kernel-parameters.txt~remove-some-more-tipar-bits Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~remove-some-more-tipar-bits
+++ a/Documentation/kernel-parameters.txt
@@ -2159,13 +2159,6 @@ and is between 256 and 4096 characters. 
 			<deci-seconds>: poll all this frequency
 			0: no polling (default)
 
-	tipar.timeout=	[HW,PPT]
-			Set communications timeout in tenths of a second
-			(default 15).
-
-	tipar.delay=	[HW,PPT]
-			Set inter-bit delay in microseconds (default 10).
-
 	tmscsim=	[HW,SCSI]
 			See comment before function dc390_setup() in
 			drivers/scsi/tmscsim.c.
diff -puN drivers/char/Makefile~remove-some-more-tipar-bits drivers/char/Makefile
--- a/drivers/char/Makefile~remove-some-more-tipar-bits
+++ a/drivers/char/Makefile
@@ -63,7 +63,6 @@ obj-$(CONFIG_BRIQ_PANEL)	+= briq_panel.o
 obj-$(CONFIG_BFIN_OTP)		+= bfin-otp.o
 
 obj-$(CONFIG_PRINTER)		+= lp.o
-obj-$(CONFIG_TIPAR)		+= tipar.o
 
 obj-$(CONFIG_APM_EMULATION)	+= apm-emulation.o
 
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

