From: akpm@linux-foundation.org
Subject: - proper-extern-for-mwave_s_mdd.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:01:10 -0700
Message-ID: <200807252301.m6PN1Aq5003687@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37995 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752286AbYGYXBq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:01:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, mm-commits@vger.kernel.org


The patch titled
     proper extern for mwave_s_mdd
has been removed from the -mm tree.  Its filename was
     proper-extern-for-mwave_s_mdd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proper extern for mwave_s_mdd
From: Adrian Bunk <bunk@kernel.org>

This patch adds a proper extern for mwave_s_mdd in
drivers/char/mwave/mwavedd.h

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mwave/mwavedd.h |    2 ++
 drivers/char/mwave/tp3780i.c |    2 --
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/char/mwave/mwavedd.h~proper-extern-for-mwave_s_mdd drivers/char/mwave/mwavedd.h
--- a/drivers/char/mwave/mwavedd.h~proper-extern-for-mwave_s_mdd
+++ a/drivers/char/mwave/mwavedd.h
@@ -147,4 +147,6 @@ typedef struct _MWAVE_DEVICE_DATA {
 
 } MWAVE_DEVICE_DATA, *pMWAVE_DEVICE_DATA;
 
+extern MWAVE_DEVICE_DATA mwave_s_mdd;
+
 #endif
diff -puN drivers/char/mwave/tp3780i.c~proper-extern-for-mwave_s_mdd drivers/char/mwave/tp3780i.c
--- a/drivers/char/mwave/tp3780i.c~proper-extern-for-mwave_s_mdd
+++ a/drivers/char/mwave/tp3780i.c
@@ -57,8 +57,6 @@
 #include "3780i.h"
 #include "mwavepub.h"
 
-extern MWAVE_DEVICE_DATA mwave_s_mdd;
-
 static unsigned short s_ausThinkpadIrqToField[16] =
 	{ 0xFFFF, 0xFFFF, 0xFFFF, 0x0001, 0x0002, 0x0003, 0xFFFF, 0x0004,
 	0xFFFF, 0xFFFF, 0x0005, 0x0006, 0xFFFF, 0xFFFF, 0xFFFF, 0x0007 };
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

