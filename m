From: akpm@linux-foundation.org
Subject: - autofs4-track-uid-and-gid-of-last-mount-requester-fix.patch removed from -mm tree
Date: Wed, 15 Oct 2008 16:46:12 -0700
Message-ID: <200810152346.m9FNkCBS023135@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48077 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753666AbYJOXqR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Oct 2008 19:46:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, raven@themaw.net, mm-commits@vger.kernel.org


The patch titled
     autofs4-track-uid-and-gid-of-last-mount-requester-fix
has been removed from the -mm tree.  Its filename was
     autofs4-track-uid-and-gid-of-last-mount-requester-fix.patch

This patch was dropped because it was folded into autofs4-track-uid-and-gid-of-last-mount-requester.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: autofs4-track-uid-and-gid-of-last-mount-requester-fix
From: Andrew Morton <akpm@linux-foundation.org>

fix tpyo in comment

Cc: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/waitq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/autofs4/waitq.c~autofs4-track-uid-and-gid-of-last-mount-requester-fix fs/autofs4/waitq.c
--- a/fs/autofs4/waitq.c~autofs4-track-uid-and-gid-of-last-mount-requester-fix
+++ a/fs/autofs4/waitq.c
@@ -458,7 +458,7 @@ int autofs4_wait(struct autofs_sb_info *
 	status = wq->status;
 
 	/*
-	 * For direct and offset mounts we need to track the requestrer
+	 * For direct and offset mounts we need to track the requester's
 	 * uid and gid in the dentry info struct. This is so it can be
 	 * supplied, on request, by the misc device ioctl interface.
 	 * This is needed during daemon resatart when reconnecting
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

