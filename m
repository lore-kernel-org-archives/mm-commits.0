From: akpm@linux-foundation.org
Subject: [folded-merged] scripts-gdb-add-infrastructure-v13.patch removed
 from -mm tree
Date: Tue, 17 Feb 2015 13:39:31 -0800
Message-ID: <54e3b513.m3hYbjMoZiWVsLxq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36311 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846AbbBQVjc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Feb 2015 16:39:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jan.kiszka@siemens.com, mmarek@suse.cz, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: Add infrastructure
has been removed from the -mm tree.  Its filename was
     scripts-gdb-add-infrastructure-v13.patch

This patch was dropped because it was folded into scripts-gdb-add-infrastructure.patch

------------------------------------------------------
From: Jan Kiszka <jan.kiszka@siemens.com>
Subject: scripts/gdb: Add infrastructure

Changes in v13:
 - Let CONFIG_GDB_SCRIPT depend on CONFIG_DEBUG_INFO, instead of
   selecting it. This addresses

   warning: (GDB_SCRIPTS) selects DEBUG_INFO which has unmet direct
   dependencies (DEBUG_KERNEL && !COMPILE_TEST)

   as found by the test robot.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/Kconfig.debug~scripts-gdb-add-infrastructure-v13 lib/Kconfig.debug
--- a/lib/Kconfig.debug~scripts-gdb-add-infrastructure-v13
+++ a/lib/Kconfig.debug
@@ -169,7 +169,7 @@ config DEBUG_INFO_DWARF4
 
 config GDB_SCRIPTS
 	bool "Provide GDB scripts for kernel debugging"
-	select DEBUG_INFO
+	depends on DEBUG_INFO
 	help
 	  This creates the required links to GDB helper scripts in the
 	  build directory. If you load vmlinux into gdb, the helper
_

Patches currently in -mm which might be from jan.kiszka@siemens.com are

scripts-gdb-add-infrastructure.patch
scripts-gdb-add-cache-for-type-objects.patch
scripts-gdb-add-container_of-helper-and-convenience-function.patch
scripts-gdb-add-module-iteration-class.patch
scripts-gdb-add-lx-symbols-command.patch
module-do-not-inline-do_init_module.patch
scripts-gdb-add-automatic-symbol-reloading-on-module-insertion.patch
scripts-gdb-add-internal-helper-and-convenience-function-to-look-up-a-module.patch
scripts-gdb-add-get_target_endianness-helper.patch
scripts-gdb-add-read_u16-32-64-helpers.patch
scripts-gdb-add-lx-dmesg-command.patch
scripts-gdb-add-task-iteration-class.patch
scripts-gdb-add-helper-and-convenience-function-to-look-up-tasks.patch
scripts-gdb-add-is_target_arch-helper.patch
scripts-gdb-add-internal-helper-and-convenience-function-to-retrieve-thread_info.patch
scripts-gdb-add-get_gdbserver_type-helper.patch
scripts-gdb-add-internal-helper-and-convenience-function-for-per-cpu-lookup.patch
scripts-gdb-add-lx_current-convenience-function.patch
scripts-gdb-add-class-to-iterate-over-cpu-masks.patch
scripts-gdb-add-lx-lsmod-command.patch
scripts-gdb-add-basic-documentation.patch
scripts-gdb-port-to-python3-gdb77.patch
scripts-gdb-ignore-byte-compiled-python-files.patch
scripts-gdb-use-a-generator-instead-of-iterator-for-task-list.patch
scripts-gdb-convert-modulelist-to-generator-function.patch
scripts-gdb-convert-cpulist-to-generator-function.patch
scripts-gdb-define-maintainer.patch
scripts-gdb-disable-pagination-while-printing-from-breakpoint-handler.patch

