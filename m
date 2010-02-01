From: akpm@linux-foundation.org
Subject: + elf-coredump-replace-elf_core_extra_-macros-by-functions-fix.patch added to -mm tree
Date: Mon, 01 Feb 2010 12:04:59 -0800
Message-ID: <201002012004.o11K4xVb009333@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50071 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754881Ab0BAUFJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Feb 2010 15:05:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: d.hatayama@jp.fujitsu.com, randy.dunlap@oracle.com


The patch titled
     elf-coredump-replace-elf_core_extra_-macros-by-functions-fix
has been added to the -mm tree.  Its filename is
     elf-coredump-replace-elf_core_extra_-macros-by-functions-fix.patch

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
Subject: elf-coredump-replace-elf_core_extra_-macros-by-functions-fix
From: Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>

Signed-off-by: Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/Makefile |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/Makefile~elf-coredump-replace-elf_core_extra_-macros-by-functions-fix kernel/Makefile
--- a/kernel/Makefile~elf-coredump-replace-elf_core_extra_-macros-by-functions-fix
+++ a/kernel/Makefile
@@ -92,6 +92,7 @@ obj-$(CONFIG_TASKSTATS) += taskstats.o t
 obj-$(CONFIG_TRACEPOINTS) += tracepoint.o
 obj-$(CONFIG_LATENCYTOP) += latencytop.o
 obj-$(CONFIG_BINFMT_ELF) += elfcore.o
+obj-$(CONFIG_COMPAT_BINFMT_ELF) += elfcore.o
 obj-$(CONFIG_BINFMT_ELF_FDPIC) += elfcore.o
 obj-$(CONFIG_FUNCTION_TRACER) += trace/
 obj-$(CONFIG_TRACING) += trace/
_

Patches currently in -mm which might be from d.hatayama@jp.fujitsu.com are

coredump-unify-dump_seek-implementations-for-each-binfmt_c.patch
coredump-move-dump_write-and-dump_seek-into-a-header-file.patch
elf-coredump-replace-elf_core_extra_-macros-by-functions.patch
elf-coredump-replace-elf_core_extra_-macros-by-functions-fix.patch
elf-coredump-make-offset-calculation-process-and-writing-process-explicit.patch
elf-coredump-add-extended-numbering-support.patch

