From: akpm@linux-foundation.org
Subject: - h8300-generic_bug-support-checkpatch-fixes.patch removed from -mm tree
Date: Wed, 15 Oct 2008 21:43:39 -0700
Message-ID: <200810160443.m9G4heN0026125@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43194 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750882AbYJPEnz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Oct 2008 00:43:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ysato@users.sourceforge.jp, mm-commits@vger.kernel.org


The patch titled
     h8300-generic_bug-support-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     h8300-generic_bug-support-checkpatch-fixes.patch

This patch was dropped because it was folded into h8300-generic_bug-support.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: h8300-generic_bug-support-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: do not initialise statics to 0 or NULL
#73: FILE: arch/h8300/kernel/traps.c:101:
+	static int diecount = 0;

total: 1 errors, 0 warnings, 91 lines checked

./patches/h8300-generic_bug-support.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/h8300/kernel/traps.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/h8300/kernel/traps.c~h8300-generic_bug-support-checkpatch-fixes arch/h8300/kernel/traps.c
--- a/arch/h8300/kernel/traps.c~h8300-generic_bug-support-checkpatch-fixes
+++ a/arch/h8300/kernel/traps.c
@@ -98,7 +98,7 @@ static void dump(struct pt_regs *fp)
 
 void die(char *str, struct pt_regs *fp, unsigned long err)
 {
-	static int diecount = 0;
+	static int diecount;
 
 	oops_enter();
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-page_allocc-free_area_init_nodes-fix-inappropriate-use-of-enum.patch
h8300-generic_bug-support.patch
h8300-generic_bug-support-checkpatch-fixes.patch
pm-rework-disabling-of-user-mode-helpers-during-suspend-hibernation.patch
make-taint-bit-reliable-v3.patch
kernel-sysc-improve-code-generation.patch
compat-generic-compat-get-settimeofday.patch
allow-recursion-in-binfmt_script-and-binfmt_misc.patch
autofs4-track-uid-and-gid-of-last-mount-requester.patch
autofs4-add-miscellaneous-device-for-ioctls.patch
rtc-add-device-driver-for-dallas-ds3234-spi-rtc-chip.patch
viafb-accelc-accelh.patch
viafb-dvic-dvih-globalc-and-globalh.patch
viafb-hwc-hwh.patch
viafb-viafbdevc-viafbdevh.patch
fbdev-kconfig-update.patch
fbdev-allow-more-chip-revisions-in-epson-s1d13-video-driver.patch
ext2-avoid-printk-floods-in-the-face-of-directory-corruption.patch
applicomc-fix-apparently-broken-code-in-do_ac_read.patch
drivers-char-tpm-tpmc-fix-error-patch-memory-leak.patch
w1-be-able-to-manually-add-and-remove-slaves.patch
w1-new-driver-ds2431-chip.patch
gru-driver-minor-updates.patch

