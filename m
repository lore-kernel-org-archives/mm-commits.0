From: akpm@linux-foundation.org
Subject: + mn10300-fix-oprofile.patch added to -mm tree
Date: Thu, 19 Feb 2009 12:21:03 -0800
Message-ID: <200902192021.n1JKL3A8020446@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39738 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751893AbZBSUVv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Feb 2009 15:21:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com


The patch titled
     mn10300: fix oprofile
has been added to the -mm tree.  Its filename is
     mn10300-fix-oprofile.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

origin.patch
mn10300-fix-oprofile.patch
mn10300-fix-typo-in-arch-mn10300-unit-asb2305-pcic.patch
linux-next.patch
kbuild-make-it-possible-for-the-linker-to-discard-local-symbols-from-vmlinux.patch
nommu-fix-a-number-of-issues-with-the-per-mm-vma-patch.patch
frv-duplicate-output_buffer-of-e03.patch
nommu-present-backing-device-capabilities-for-mtd-chardevs.patch
nommu-add-support-for-direct-mapping-through-mtdconcat-if-possible.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices-directly.patch
mtd-fix-a-bad-dependency-in-the-blackfin-code.patch
bin_elf_fdpic-check-the-return-value-of-clear_user.patch
mutex-subsystem-synchro-test-module.patch

