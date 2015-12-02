From: akpm@linux-foundation.org
Subject: + arm64-mm-support-arch_mmap_rnd_bits-v5.patch added to -mm tree
Date: Tue, 01 Dec 2015 16:24:57 -0800
Message-ID: <565e3a59.VC+OM6flAL/GRiOp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59691 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932128AbbLBAY6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Dec 2015 19:24:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dcashman@android.com, catalin.marinas@arm.com, linux@arm.linux.org.uk, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: arm64-mm-support-arch_mmap_rnd_bits-v5
has been added to the -mm tree.  Its filename is
     arm64-mm-support-arch_mmap_rnd_bits-v5.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arm64-mm-support-arch_mmap_rnd_bits-v5.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arm64-mm-support-arch_mmap_rnd_bits-v5.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-mmap-add-new-proc-tunable-for-mmap_base-aslr-v4.patch
mm-mmap-add-new-proc-tunable-for-mmap_base-aslr-v5.patch
arm-mm-support-arch_mmap_rnd_bits-v5.patch
arm64-mm-support-arch_mmap_rnd_bits-v4.patch
arm64-mm-support-arch_mmap_rnd_bits-v5.patch
x86-mm-support-arch_mmap_rnd_bits-v5.patch

