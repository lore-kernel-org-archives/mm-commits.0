From: akpm@linux-foundation.org
Subject: [folded-merged]
 kexec-allow-architectures-to-override-boot-mapping-fix.patch removed from
 -mm tree
Date: Tue, 02 Aug 2016 13:45:38 -0700
Message-ID: <57a10672.vbd/0T0xCI95CPtR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59553 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753291AbcHBUpj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Aug 2016 16:45:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, rmk+kernel@arm.linux.org.uk, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec-allow-architectures-to-override-boot-mapping-fix
has been removed from the -mm tree.  Its filename was
     kexec-allow-architectures-to-override-boot-mapping-fix.patch

This patch was dropped because it was folded into kexec-allow-architectures-to-override-boot-mapping.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kexec-allow-architectures-to-override-boot-mapping-fix

kexec.h needs asm/io.h for phys_to_virt()

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kexec.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/linux/kexec.h~kexec-allow-architectures-to-override-boot-mapping-fix include/linux/kexec.h
--- a/include/linux/kexec.h~kexec-allow-architectures-to-override-boot-mapping-fix
+++ a/include/linux/kexec.h
@@ -14,6 +14,8 @@
 
 #if !defined(__ASSEMBLY__)
 
+#include <asm/io.h>
+
 #include <uapi/linux/kexec.h>
 
 #ifdef CONFIG_KEXEC_CORE
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kexec-allow-architectures-to-override-boot-mapping.patch
allow-kdump-with-crash_kexec_post_notifiers-fix.patch
kexec-add-restriction-on-kexec_load-segment-sizes-fix.patch
powerpc-fsl_rio-apply-changes-for-rio-spec-rev-3-fix.patch

