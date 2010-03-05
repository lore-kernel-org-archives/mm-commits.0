From: akpm@linux-foundation.org
Subject: [folded] elf-coredump-replace-elf_core_extra_-macros-by-functions-fix.patch removed from -mm tree
Date: Fri, 05 Mar 2010 13:24:26 -0800
Message-ID: <201003052124.o25LOQux028452@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48475 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752462Ab0CEVY6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Mar 2010 16:24:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: d.hatayama@jp.fujitsu.com, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     elf-coredump-replace-elf_core_extra_-macros-by-functions-fix
has been removed from the -mm tree.  Its filename was
     elf-coredump-replace-elf_core_extra_-macros-by-functions-fix.patch

This patch was dropped because it was folded into elf-coredump-replace-elf_core_extra_-macros-by-functions.patch

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
@@ -94,6 +94,7 @@ obj-$(CONFIG_TASKSTATS) += taskstats.o t
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
elf-coredump-replace-elf_core_extra_-macros-by-functions-fix-2.patch
elf-coredump-make-offset-calculation-process-and-writing-process-explicit.patch
elf-coredump-add-extended-numbering-support.patch

