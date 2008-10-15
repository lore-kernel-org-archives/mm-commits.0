From: akpm@linux-foundation.org
Subject: - allow-recursion-in-binfmt_script-and-binfmt_misc-fix.patch removed from -mm tree
Date: Wed, 15 Oct 2008 16:44:53 -0700
Message-ID: <200810152344.m9FNis3t022925@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36001 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753157AbYJOXo6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Oct 2008 19:44:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, kirill@shutemov.name, viro@zeniv.linux.org.uk, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     allow-recursion-in-binfmt_script-and-binfmt_misc-fix
has been removed from the -mm tree.  Its filename was
     allow-recursion-in-binfmt_script-and-binfmt_misc-fix.patch

This patch was dropped because it was folded into allow-recursion-in-binfmt_script-and-binfmt_misc.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: allow-recursion-in-binfmt_script-and-binfmt_misc-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/binfmts.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/binfmts.h~allow-recursion-in-binfmt_script-and-binfmt_misc-fix include/linux/binfmts.h
--- a/include/linux/binfmts.h~allow-recursion-in-binfmt_script-and-binfmt_misc-fix
+++ a/include/linux/binfmts.h
@@ -39,7 +39,7 @@ struct linux_binprm{
 #ifdef __alpha__
 	unsigned int taso:1;
 #endif
-	unsigned char recursion_depth;
+	unsigned int recursion_depth;
 	struct file * file;
 	int e_uid, e_gid;
 	kernel_cap_t cap_post_exec_permitted;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-page_allocc-free_area_init_nodes-fix-inappropriate-use-of-enum.patch
h8300-generic_bug-support-checkpatch-fixes.patch
pm-rework-disabling-of-user-mode-helpers-during-suspend-hibernation.patch
make-taint-bit-reliable-v3.patch
kernel-sysc-improve-code-generation.patch
compat-generic-compat-get-settimeofday.patch
allow-recursion-in-binfmt_script-and-binfmt_misc.patch
allow-recursion-in-binfmt_script-and-binfmt_misc-fix.patch
autofs4-track-uid-and-gid-of-last-mount-requester-fix.patch
autofs4-add-miscellaneous-device-for-ioctls-fix.patch
autofs4-add-miscellaneous-device-for-ioctls-fix-2.patch
rtc-add-device-driver-for-dallas-ds3234-spi-rtc-chip-fix.patch
viafb-viafbmodes-viafbtxt-fix-fix.patch
viafb-accelc-accelh-checkpatch-fixes.patch
viafb-dvic-dvih-globalc-and-globalh-checkpatch-fixes.patch
viafb-hwc-hwh-checkpatch-fixes.patch
viafb-viafbdevc-viafbdevh-checkpatch-fixes.patch
fbdev-kconfig-update-fix.patch
fbdev-allow-more-chip-revisions-in-epson-s1d13-video-driver-cleanups.patch
ext2-avoid-printk-floods-in-the-face-of-directory-corruption-checkpatch-fixes.patch
applicomc-fix-apparently-broken-code-in-do_ac_read.patch
drivers-char-tpm-tpmc-fix-error-patch-memory-leak.patch
w1-be-able-to-manually-add-and-remove-slaves-fix.patch
w1-new-driver-ds2431-chip-fix.patch
gru-driver-minor-updates-fix.patch

