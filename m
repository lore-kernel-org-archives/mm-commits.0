From: akpm@linux-foundation.org
Subject: - pm-rework-disabling-of-user-mode-helpers-during-suspend-hibernation-cleanup.patch removed from -mm tree
Date: Wed, 15 Oct 2008 16:42:00 -0700
Message-ID: <200810152342.m9FNg1oH022572@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52993 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752840AbYJOXm2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Oct 2008 19:42:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, pavel@suse.cz, rjw@sisk.pl, stern@rowland.harvard.edu, mm-commits@vger.kernel.org


The patch titled
     pm-rework-disabling-of-user-mode-helpers-during-suspend-hibernation-cleanup
has been removed from the -mm tree.  Its filename was
     pm-rework-disabling-of-user-mode-helpers-during-suspend-hibernation-cleanup.patch

This patch was dropped because it was folded into pm-rework-disabling-of-user-mode-helpers-during-suspend-hibernation.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pm-rework-disabling-of-user-mode-helpers-during-suspend-hibernation-cleanup
From: Andrew Morton <akpm@linux-foundation.org>

Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Pavel Machek <pavel@suse.cz>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kmod.h |    2 --
 1 file changed, 2 deletions(-)

diff -puN include/linux/kmod.h~pm-rework-disabling-of-user-mode-helpers-during-suspend-hibernation-cleanup include/linux/kmod.h
--- a/include/linux/kmod.h~pm-rework-disabling-of-user-mode-helpers-during-suspend-hibernation-cleanup
+++ a/include/linux/kmod.h
@@ -99,9 +99,7 @@ struct file;
 extern int call_usermodehelper_pipe(char *path, char *argv[], char *envp[],
 				    struct file **filp);
 
-#ifdef CONFIG_PM_SLEEP
 extern int usermodehelper_disable(void);
 extern void usermodehelper_enable(void);
-#endif
 
 #endif /* __LINUX_KMOD_H__ */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-page_allocc-free_area_init_nodes-fix-inappropriate-use-of-enum.patch
h8300-generic_bug-support-checkpatch-fixes.patch
pm-rework-disabling-of-user-mode-helpers-during-suspend-hibernation.patch
pm-rework-disabling-of-user-mode-helpers-during-suspend-hibernation-cleanup.patch
make-taint-bit-reliable-v3-fix.patch
kernel-sysc-improve-code-generation.patch
compat-generic-compat-get-settimeofday-checkpatch-fixes.patch
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

