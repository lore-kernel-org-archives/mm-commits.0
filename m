From: akpm@linux-foundation.org
Subject: [merged] mn10300-fix-oprofile.patch removed from -mm tree
Date: Mon, 23 Feb 2009 12:06:31 -0800
Message-ID: <200902232006.n1NK6VGj013393@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52799 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754514AbZBWUIP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Feb 2009 15:08:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mn10300: fix oprofile
has been removed from the -mm tree.  Its filename was
     mn10300-fix-oprofile.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mn10300: fix oprofile
From: David Howells <dhowells@redhat.com>

oprofile for MN10300 seems to have been broken by the advent of the new
tracing framework.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mn10300/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/mn10300/Kconfig~mn10300-fix-oprofile arch/mn10300/Kconfig
--- a/arch/mn10300/Kconfig~mn10300-fix-oprofile
+++ a/arch/mn10300/Kconfig
@@ -7,6 +7,7 @@ mainmenu "Linux Kernel Configuration"
 
 config MN10300
 	def_bool y
+	select HAVE_OPROFILE
 
 config AM33
 	def_bool y
_

Patches currently in -mm which might be from dhowells@redhat.com are

linux-next.patch
kbuild-make-it-possible-for-the-linker-to-discard-local-symbols-from-vmlinux.patch
nommu-fix-a-number-of-issues-with-the-per-mm-vma-patch.patch
frv-duplicate-output_buffer-of-e03.patch
nommu-present-backing-device-capabilities-for-mtd-chardevs.patch
nommu-add-support-for-direct-mapping-through-mtdconcat-if-possible.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices-directly.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices-directly-fix.patch
mtd-fix-a-bad-dependency-in-the-blackfin-code.patch
bin_elf_fdpic-check-the-return-value-of-clear_user.patch
mutex-subsystem-synchro-test-module.patch

