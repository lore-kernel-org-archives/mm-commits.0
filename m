From: akpm@linux-foundation.org
Subject: [alternative-merged] m32r-kernel-smpbootc-must-include-linux-cpuh.patch removed from -mm tree
Date: Tue, 13 Jan 2009 18:40:12 -0800
Message-ID: <200901140240.n0E2eCNK020885@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49202 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751531AbZANCkb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Jan 2009 21:40:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, takata@linux-m32r.org, mm-commits@vger.kernel.org


The patch titled
     m32r/kernel/smpboot.c must #include <linux/cpu.h>
has been removed from the -mm tree.  Its filename was
     m32r-kernel-smpbootc-must-include-linux-cpuh.patch

This patch was dropped because an alternative patch was merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: m32r/kernel/smpboot.c must #include <linux/cpu.h>
From: Adrian Bunk <bunk@kernel.org>

arch/m32r/kernel/smpboot.c: In function 'smp_online':
arch/m32r/kernel/smpboot.c:501: error: implicit declaration of function 'notify_cpu_starting'

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m32r/kernel/smpboot.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/m32r/kernel/smpboot.c~m32r-kernel-smpbootc-must-include-linux-cpuh arch/m32r/kernel/smpboot.c
--- a/arch/m32r/kernel/smpboot.c~m32r-kernel-smpbootc-must-include-linux-cpuh
+++ a/arch/m32r/kernel/smpboot.c
@@ -49,6 +49,7 @@
 #include <linux/irq.h>
 #include <linux/bootmem.h>
 #include <linux/delay.h>
+#include <linux/cpu.h>
 
 #include <asm/io.h>
 #include <asm/pgalloc.h>
_

Patches currently in -mm which might be from bunk@kernel.org are

linux-next.patch
m32r-kernel-smpbootc-must-include-linux-cpuh.patch
if-0-ses_match_host.patch
drivers-scsi-a2091c-make-2-functions-static.patch
drivers-scsi-a3000c-make-2-functions-static.patch
reiser4.patch

