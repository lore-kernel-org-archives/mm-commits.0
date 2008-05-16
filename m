From: akpm@linux-foundation.org
Subject: - macintosh-replace-deprecated-__initcall-with-device_initcall.patch removed from -mm tree
Date: Fri, 16 May 2008 15:53:51 -0700
Message-ID: <200805162253.m4GMrpAd003179@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39210 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757564AbYEPWyE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 May 2008 18:54:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@crashcourse.ca, benh@kernel.crashing.org, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     macintosh: replace deprecated __initcall with device_initcall
has been removed from the -mm tree.  Its filename was
     macintosh-replace-deprecated-__initcall-with-device_initcall.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: macintosh: replace deprecated __initcall with device_initcall
From: "Robert P. J. Day" <rpjday@crashcourse.ca>

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/macintosh/adb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/macintosh/adb.c~macintosh-replace-deprecated-__initcall-with-device_initcall drivers/macintosh/adb.c
--- a/drivers/macintosh/adb.c~macintosh-replace-deprecated-__initcall-with-device_initcall
+++ a/drivers/macintosh/adb.c
@@ -334,7 +334,7 @@ int __init adb_init(void)
 	return 0;
 }
 
-__initcall(adb_init);
+device_initcall(adb_init);
 
 static int
 do_adb_reset_bus(void)
_

Patches currently in -mm which might be from rpjday@crashcourse.ca are

origin.patch
linux-next.patch
kbuild-remove-final-references-to-deprecated-unreferenced-topdir.patch
xtensa-warn-about-including-asm-rwsemh-directly.patch
xtensa-use-newer-__spin_lock_unlocked-macro.patch
remove-apparently-unused-fd1772h-header-file.patch
init-delete-hard-coded-setting-and-testing-of-build_cramdisk.patch
lib-allow-memparse-to-accept-a-null-and-ignorable-second-parm.patch
lib-allow-memparse-to-accept-a-null-and-ignorable-second-parm-checkpatch-fixes.patch
lists-remove-a-redundant-conditional-definition-of-list_add.patch
zorro-replace-deprecated-__initcall-with-equivalent-device_initcall.patch
spi-kconfig-simplifications.patch

