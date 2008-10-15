From: akpm@linux-foundation.org
Subject: - ext2-avoid-printk-floods-in-the-face-of-directory-corruption-checkpatch-fixes.patch removed from -mm tree
Date: Wed, 15 Oct 2008 16:56:04 -0700
Message-ID: <200810152356.m9FNu4E0024365@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37939 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753807AbYJOX4T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Oct 2008 19:56:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, sandeen@redhat.com, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     ext2-avoid-printk-floods-in-the-face-of-directory-corruption-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     ext2-avoid-printk-floods-in-the-face-of-directory-corruption-checkpatch-fixes.patch

This patch was dropped because it was folded into ext2-avoid-printk-floods-in-the-face-of-directory-corruption.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext2-avoid-printk-floods-in-the-face-of-directory-corruption-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: space prohibited between function name and open parenthesis '('
#75: FILE: fs/ext2/dir.c:179:
+		ext2_error (sb, "ext2_check_page",

ERROR: "foo * bar" should be "foo *bar"
#87: FILE: fs/ext2/dir.c:190:
+static struct page * ext2_get_page(struct inode *dir, unsigned long n,

total: 1 errors, 1 warnings, 139 lines checked

./patches/ext2-avoid-printk-floods-in-the-face-of-directory-corruption.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/dir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ext2/dir.c~ext2-avoid-printk-floods-in-the-face-of-directory-corruption-checkpatch-fixes fs/ext2/dir.c
--- a/fs/ext2/dir.c~ext2-avoid-printk-floods-in-the-face-of-directory-corruption-checkpatch-fixes
+++ a/fs/ext2/dir.c
@@ -176,7 +176,7 @@ bad_entry:
 Eend:
 	if (!quiet) {
 		p = (ext2_dirent *)(kaddr + offs);
-		ext2_error (sb, "ext2_check_page",
+		ext2_error(sb, "ext2_check_page",
 			"entry in directory #%lu spans the page boundary"
 			"offset=%lu, inode=%lu",
 			dir->i_ino, (page->index<<PAGE_CACHE_SHIFT)+offs,
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
ext2-avoid-printk-floods-in-the-face-of-directory-corruption-checkpatch-fixes.patch
applicomc-fix-apparently-broken-code-in-do_ac_read.patch
drivers-char-tpm-tpmc-fix-error-patch-memory-leak.patch
w1-be-able-to-manually-add-and-remove-slaves-fix.patch
w1-new-driver-ds2431-chip-fix.patch
gru-driver-minor-updates-fix.patch

