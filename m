From: akpm@linux-foundation.org
Subject: [folded-dropped] sections-fix-section-conflicts-in-arch-sh-fix.patch removed from -mm tree
Date: Thu, 04 Oct 2012 16:53:12 -0700
Message-ID: <20121004235312.E84E1100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:47394 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907Ab2JDXxO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Oct 2012 19:53:14 -0400
Received: by mail-yh0-f74.google.com with SMTP id 10so90210yhl.1
        for <mm-commits@vger.kernel.org>; Thu, 04 Oct 2012 16:53:13 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, fengguang.wu@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: sections-fix-section-conflicts-in-arch-sh-fix
has been removed from the -mm tree.  Its filename was
     sections-fix-section-conflicts-in-arch-sh-fix.patch

This patch was dropped because it was folded into sections-fix-section-conflicts-in-arch-sh.patch

------------------------------------------------------
From: Andi Kleen <ak@linux.intel.com>
Subject: sections-fix-section-conflicts-in-arch-sh-fix

Cc: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/include/asm/io.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/sh/include/asm/io.h~sections-fix-section-conflicts-in-arch-sh-fix arch/sh/include/asm/io.h
--- a/arch/sh/include/asm/io.h~sections-fix-section-conflicts-in-arch-sh-fix
+++ a/arch/sh/include/asm/io.h
@@ -134,7 +134,7 @@ __BUILD_MEMORY_STRING(__raw_, q, u64)
  * load/store instructions. sh_io_port_base is the virtual address to
  * which all ports are being mapped.
  */
-extern const unsigned long sh_io_port_base;
+extern unsigned long sh_io_port_base;
 
 static inline void __set_io_port_base(unsigned long pbase)
 {
_

Patches currently in -mm which might be from ak@linux.intel.com are

origin.patch
sections-disable-const-sections-for-pa-risc-v2.patch
sections-fix-section-conflicts-in-arch-arm.patch
sections-fix-section-conflicts-in-arch-frv.patch
sections-fix-section-conflicts-in-arch-h8300.patch
sections-fix-section-conflicts-in-arch-ia64.patch
sections-fix-section-conflicts-in-arch-mips.patch
sections-fix-section-conflicts-in-arch-powerpc.patch
sections-fix-section-conflicts-in-arch-score.patch
sections-fix-section-conflicts-in-arch-sh.patch
sections-fix-section-conflicts-in-arch-x86.patch
sections-fix-section-conflicts-in-drivers-atm.patch
sections-fix-section-conflicts-in-drivers-char.patch
sections-fix-section-conflicts-in-drivers-ide.patch
sections-fix-section-conflicts-in-drivers-macintosh.patch
sections-fix-section-conflicts-in-drivers-macintosh-checkpatch-fixes.patch
sections-fix-section-conflicts-in-drivers-mfd.patch
sections-fix-section-conflicts-in-drivers-mmc.patch
sections-fix-section-conflicts-in-drivers-net.patch
sections-fix-section-conflicts-in-drivers-net-hamradio.patch
sections-fix-section-conflicts-in-drivers-net-wan.patch
sections-fix-section-conflicts-in-drivers-platform-x86.patch
sections-fix-section-conflicts-in-drivers-scsi.patch
sections-fix-section-conflicts-in-drivers-video.patch
sections-fix-section-conflicts-in-mm-percpuc.patch
sections-fix-section-conflicts-in-net-can.patch
sections-fix-section-conflicts-in-net.patch
sections-fix-section-conflicts-in-sound.patch
sectons-fix-const-sections-for-crc32-table.patch
sectons-fix-const-sections-for-crc32-table-checkpatch-fixes.patch

