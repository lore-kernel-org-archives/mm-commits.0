From: akpm@linux-foundation.org
Subject: + zorro-replace-deprecated-__initcall-with-equivalent-device_initcall.patch added to -mm tree
Date: Mon, 12 May 2008 16:49:39 -0700
Message-ID: <200805122349.m4CNnd4l015302@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56876 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755800AbYELXuW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 May 2008 19:50:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@crashcourse.ca, geert@linux-m68k.org


The patch titled
     zorro: replace deprecated __initcall with equivalent device_initcall
has been added to the -mm tree.  Its filename is
     zorro-replace-deprecated-__initcall-with-equivalent-device_initcall.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

uml-use-__spin_lock_unlocked.patch
uml-fix-config_raw-dependencies.patch
mn10300-replace-deprecated-topdir-with-newer-srctree.patch
linux-next.patch
macintosh-replace-deprecated-__initcall-with-device_initcall.patch
xtensa-warn-about-including-asm-rwsemh-directly.patch
xtensa-use-newer-__spin_lock_unlocked-macro.patch
remove-apparently-unused-fd1772h-header-file.patch
init-delete-hard-coded-setting-and-testing-of-build_cramdisk.patch
lib-allow-memparse-to-accept-a-null-and-ignorable-second-parm.patch
lib-allow-memparse-to-accept-a-null-and-ignorable-second-parm-checkpatch-fixes.patch
lists-remove-a-redundant-conditional-definition-of-list_add.patch
zorro-replace-deprecated-__initcall-with-equivalent-device_initcall.patch

