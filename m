From: akpm@linux-foundation.org
Subject: - zorro-replace-deprecated-__initcall-with-equivalent-device_initcall.patch removed from -mm tree
Date: Fri, 30 May 2008 15:39:41 -0700
Message-ID: <200805302239.m4UMdfaU014929@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41032 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752762AbYE3Wk1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 May 2008 18:40:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@crashcourse.ca, geert@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     zorro: replace deprecated __initcall with equivalent device_initcall
has been removed from the -mm tree.  Its filename was
     zorro-replace-deprecated-__initcall-with-equivalent-device_initcall.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: zorro: replace deprecated __initcall with equivalent device_initcall
From: "Robert P. J. Day" <rpjday@crashcourse.ca>

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/zorro/proc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/zorro/proc.c~zorro-replace-deprecated-__initcall-with-equivalent-device_initcall drivers/zorro/proc.c
--- a/drivers/zorro/proc.c~zorro-replace-deprecated-__initcall-with-equivalent-device_initcall
+++ a/drivers/zorro/proc.c
@@ -160,4 +160,4 @@ static int __init zorro_proc_init(void)
 	return 0;
 }
 
-__initcall(zorro_proc_init);
+device_initcall(zorro_proc_init);
_

Patches currently in -mm which might be from rpjday@crashcourse.ca are

linux-next.patch
kbuild-remove-final-references-to-deprecated-unreferenced-topdir.patch
kbuild-move-non-__kernel__-checking-headers-to-header-y.patch
xtensa-warn-about-including-asm-rwsemh-directly.patch
xtensa-use-newer-__spin_lock_unlocked-macro.patch
remove-apparently-unused-fd1772h-header-file.patch
init-delete-hard-coded-setting-and-testing-of-build_cramdisk.patch
lib-allow-memparse-to-accept-a-null-and-ignorable-second-parm.patch
lib-allow-memparse-to-accept-a-null-and-ignorable-second-parm-checkpatch-fixes.patch
lists-remove-a-redundant-conditional-definition-of-list_add.patch
config_sound_wm97xx-remove-stale-makefile-line.patch
spi-kconfig-simplifications.patch

