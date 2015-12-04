From: akpm@linux-foundation.org
Subject: [folded-merged] arm64-mm-support-arch_mmap_rnd_bits-v5.patch
 removed from -mm tree
Date: Fri, 04 Dec 2015 15:19:41 -0800
Message-ID: <56621f8d.HBGscQCJAGN+a9aN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48172 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756951AbbLDXTm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Dec 2015 18:19:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dcashman@android.com, catalin.marinas@arm.com, linux@arm.linux.org.uk, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: arm64-mm-support-arch_mmap_rnd_bits-v5
has been removed from the -mm tree.  Its filename was
     arm64-mm-support-arch_mmap_rnd_bits-v5.patch

This patch was dropped because it was folded into arm64-mm-support-arch_mmap_rnd_bits.patch

------------------------------------------------------
From: Daniel Cashman <dcashman@android.com>
Subject: arm64-mm-support-arch_mmap_rnd_bits-v5

Signed-off-by: Daniel Cashman <dcashman@android.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/arm64/Kconfig~arm64-mm-support-arch_mmap_rnd_bits-v5 arch/arm64/Kconfig
--- a/arch/arm64/Kconfig~arm64-mm-support-arch_mmap_rnd_bits-v5
+++ a/arch/arm64/Kconfig
@@ -51,8 +51,8 @@ config ARM64
 	select HAVE_ARCH_JUMP_LABEL
 	select HAVE_ARCH_KASAN if SPARSEMEM_VMEMMAP && !(ARM64_16K_PAGES && ARM64_VA_BITS_48)
 	select HAVE_ARCH_KGDB
-	select HAVE_ARCH_MMAP_RND_BITS
-	select HAVE_ARCH_MMAP_RND_COMPAT_BITS if COMPAT
+	select HAVE_ARCH_MMAP_RND_BITS if MMU
+	select HAVE_ARCH_MMAP_RND_COMPAT_BITS if MMU && COMPAT
 	select HAVE_ARCH_SECCOMP_FILTER
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_BPF_JIT
_

Patches currently in -mm which might be from dcashman@android.com are

arm64-mm-support-arch_mmap_rnd_bits.patch
x86-mm-support-arch_mmap_rnd_bits-v5.patch

