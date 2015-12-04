From: akpm@linux-foundation.org
Subject: [folded-merged] arm-mm-support-arch_mmap_rnd_bits-v5.patch
 removed from -mm tree
Date: Fri, 04 Dec 2015 15:15:14 -0800
Message-ID: <56621e82.P3Ci0MvJGOX3UfN6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47537 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755445AbbLDXPP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Dec 2015 18:15:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dcashman@android.com, catalin.marinas@arm.com, linux@arm.linux.org.uk, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: arm-mm-support-arch_mmap_rnd_bits-v5
has been removed from the -mm tree.  Its filename was
     arm-mm-support-arch_mmap_rnd_bits-v5.patch

This patch was dropped because it was folded into arm-mm-support-arch_mmap_rnd_bits.patch

------------------------------------------------------
From: Daniel Cashman <dcashman@android.com>
Subject: arm-mm-support-arch_mmap_rnd_bits-v5

Signed-off-by: Daniel Cashman <dcashman@android.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/Kconfig |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN arch/arm/Kconfig~arm-mm-support-arch_mmap_rnd_bits-v5 arch/arm/Kconfig
--- a/arch/arm/Kconfig~arm-mm-support-arch_mmap_rnd_bits-v5
+++ a/arch/arm/Kconfig
@@ -313,10 +313,9 @@ config ARCH_MMAP_RND_BITS_MIN
 	default 8
 
 config ARCH_MMAP_RND_BITS_MAX
-	default 14 if MMU && PAGE_OFFSET=0x40000000
-	default 15 if MMU && PAGE_OFFSET=0x80000000
-	default 16 if MMU
-	default 8
+	default 14 if PAGE_OFFSET=0x40000000
+	default 15 if PAGE_OFFSET=0x80000000
+	default 16
 
 #
 # The "ARM system type" choice list is ordered alphabetically by option
_

Patches currently in -mm which might be from dcashman@android.com are

arm-mm-support-arch_mmap_rnd_bits.patch
arm64-mm-support-arch_mmap_rnd_bits-v4.patch
arm64-mm-support-arch_mmap_rnd_bits-v5.patch
x86-mm-support-arch_mmap_rnd_bits-v5.patch

