From: akpm@linux-foundation.org
Subject: [merged] gcov-add-arm64-to-gcov_profile_all.patch removed from
 -mm tree
Date: Thu, 30 Oct 2014 13:27:17 -0700
Message-ID: <54529f25.f3RJFKWM8t73sIgR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40470 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161109AbaJ3U1Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 30 Oct 2014 16:27:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: riku.voipio@linaro.org, oberpar@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: gcov: add ARM64 to GCOV_PROFILE_ALL
has been removed from the -mm tree.  Its filename was
     gcov-add-arm64-to-gcov_profile_all.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Riku Voipio <riku.voipio@linaro.org>
Subject: gcov: add ARM64 to GCOV_PROFILE_ALL

Following up the arm testing of gcov, turns out gcov on ARM64 works fine
as well.  Only change needed is adding ARM64 to Kconfig depends.

Tested with qemu and mach-virt

Signed-off-by: Riku Voipio <riku.voipio@linaro.org>
Acked-by: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/gcov/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/gcov/Kconfig~gcov-add-arm64-to-gcov_profile_all kernel/gcov/Kconfig
--- a/kernel/gcov/Kconfig~gcov-add-arm64-to-gcov_profile_all
+++ a/kernel/gcov/Kconfig
@@ -35,7 +35,7 @@ config GCOV_KERNEL
 config GCOV_PROFILE_ALL
 	bool "Profile entire Kernel"
 	depends on GCOV_KERNEL
-	depends on SUPERH || S390 || X86 || PPC || MICROBLAZE || ARM
+	depends on SUPERH || S390 || X86 || PPC || MICROBLAZE || ARM || ARM64
 	default n
 	---help---
 	This options activates profiling for the entire kernel.
_

Patches currently in -mm which might be from riku.voipio@linaro.org are

origin.patch
gcov-enable-gcov_profile_all-from-arch-kconfigs.patch
linux-next.patch

