From: akpm@linux-foundation.org
Subject: + compat_binfmt_elf-definition-tweak.patch added to -mm tree
Date: Tue, 02 Sep 2008 17:13:53 -0700
Message-ID: <200809030013.m830DrTh020006@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34783 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753579AbYICANz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Sep 2008 20:13:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com


The patch titled
     COMPAT_BINFMT_ELF definition tweak
has been added to the -mm tree.  Its filename is
     compat_binfmt_elf-definition-tweak.patch

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
Subject: COMPAT_BINFMT_ELF definition tweak
From: Alexey Dobriyan <adobriyan@gmail.com>

Don't repeat BINFMT_ELF definition, simply multiply COMPAT and BINFMT_ELF.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/Kconfig.binfmt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/Kconfig.binfmt~compat_binfmt_elf-definition-tweak fs/Kconfig.binfmt
--- a/fs/Kconfig.binfmt~compat_binfmt_elf-definition-tweak
+++ a/fs/Kconfig.binfmt
@@ -25,7 +25,7 @@ config BINFMT_ELF
 
 config COMPAT_BINFMT_ELF
 	bool
-	depends on COMPAT && MMU
+	depends on COMPAT && BINFMT_ELF
 
 config BINFMT_ELF_FDPIC
 	bool "Kernel support for FDPIC ELF binaries"
_

Patches currently in -mm which might be from adobriyan@gmail.com are

linux-next.patch
less-softirq-vectors.patch
mpt-remove-unused-struct-mpt_proc_entry_t.patch
cpuset-use-seq_cpumask-seq_nodemask.patch
compat_binfmt_elf-definition-tweak.patch
proc-move-sysrq-trigger-out-of-fs-proc.patch
proc-fix-return-value-of-proc_reg_open-in-too-late-case.patch
sysctl-simplify-strategy.patch
fs-kconfig-move-ext2-ext3-ext4-jbd-jbd2-out.patch
fs-kconfig-move-autofs-autofs4-out.patch
fs-kconfig-move-cifs-out.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch
likely_prof-changed-to-use-proc_create.patch
proc-remove-proc_root-from-drivers-likelyprof.patch

