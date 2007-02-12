From: akpm@linux-foundation.org
Subject: - dynamic-kernel-command-line-mips.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:47:59 -0800
Message-ID: <200702122247.l1CMlxrP013961@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45879 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030428AbXBLWvR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:51:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alon.barlev@gmail.com, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     Dynamic kernel command-line: mips
has been removed from the -mm tree.  Its filename was
     dynamic-kernel-command-line-mips.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Dynamic kernel command-line: mips
From: Alon Bar-Lev <alon.barlev@gmail.com>

Rename saved_command_line into boot_command_line.

Signed-off-by: Alon Bar-Lev <alon.barlev@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/kernel/setup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/mips/kernel/setup.c~dynamic-kernel-command-line-mips arch/mips/kernel/setup.c
--- a/arch/mips/kernel/setup.c~dynamic-kernel-command-line-mips
+++ a/arch/mips/kernel/setup.c
@@ -452,7 +452,7 @@ static void __init arch_mem_init(char **
 	print_memory_map();
 
 	strlcpy(command_line, arcs_cmdline, sizeof(command_line));
-	strlcpy(saved_command_line, command_line, COMMAND_LINE_SIZE);
+	strlcpy(boot_command_line, command_line, COMMAND_LINE_SIZE);
 
 	*cmdline_p = command_line;
 
_

Patches currently in -mm which might be from alon.barlev@gmail.com are

origin.patch
