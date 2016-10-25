From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-rejects.patch removed from -mm tree
Date: Tue, 25 Oct 2016 11:49:49 -0700
Message-ID: <580fa94d.5eeYM2P9DR1xRugd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35425 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752973AbcJYSu0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 25 Oct 2016 14:50:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/Makefile    |    5 +++--
 arch/powerpc/purgatory/Makefile |    4 ++--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff -puN arch/powerpc/kernel/Makefile~linux-next-rejects arch/powerpc/kernel/Makefile
--- a/arch/powerpc/kernel/Makefile~linux-next-rejects
+++ a/arch/powerpc/kernel/Makefile
@@ -36,8 +36,9 @@ obj-y				:= cputable.o ptrace.o syscalls
 				   process.o systbl.o idle.o \
 				   signal.o sysfs.o cacheinfo.o time.o \
 				   prom.o traps.o setup-common.o \
-				   udbg.o misc.o io.o dma.o misc_$(BITS).o \
-				   of_platform.o prom_parse.o
+				   udbg.o misc.o io.o dma.o \
+				   misc_$(BITS).o of_platform.o \
+				   prom_parse.o
 obj-$(CONFIG_PPC64)		+= setup_64.o sys_ppc32.o \
 				   signal_64.o ptrace32.o \
 				   paca.o nvram_64.o firmware.o
diff -puN arch/powerpc/purgatory/Makefile~linux-next-rejects arch/powerpc/purgatory/Makefile
--- a/arch/powerpc/purgatory/Makefile~linux-next-rejects
+++ a/arch/powerpc/purgatory/Makefile
@@ -18,8 +18,8 @@ targets += purgatory.ro
 KBUILD_CFLAGS := -Wall -Wstrict-prototypes -fno-strict-aliasing \
 		-fno-zero-initialized-in-bss -fno-builtin -ffreestanding \
 		-fno-PIC -fno-PIE -fno-stack-protector  -fno-exceptions \
-		-msoft-float -MD -Os -m$(CONFIG_WORD_SIZE)
-KBUILD_AFLAGS := -fno-exceptions -msoft-float -m$(CONFIG_WORD_SIZE) \
+		-msoft-float -MD -Os -m$(BITS)
+KBUILD_AFLAGS := -fno-exceptions -msoft-float -m$(BITS) \
 		-D__ASSEMBLY__
 
 ifeq ($(CONFIG_CPU_LITTLE_ENDIAN),y)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
mm-page_alloc-use-kern_cont-where-appropriate-checkpatch-fixes.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-compaction-allow-compaction-for-gfp_nofs-requests-fix.patch
mm-mempolicy-clean-up-__gfp_thisnode-confusion-in-policy_zonelist-checkpatch-fixes.patch
scripts-checkpatchpl-fix-spelling.patch
debug-more-properly-delay-for-secondary-cpus-fix.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

