From: akpm@linux-foundation.org
Subject: [folded-merged] x86-mm-support-arch_mmap_rnd_bits-v5.patch
 removed from -mm tree
Date: Fri, 04 Dec 2015 15:21:54 -0800
Message-ID: <56622012.8UiEJKny4s8dkb1I%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48208 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755282AbbLDXVz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Dec 2015 18:21:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dcashman@android.com, keescook@chromium.org, mm-commits@vger.kernel.org


The patch titled
     Subject: x86-mm-support-arch_mmap_rnd_bits-v5
has been removed from the -mm tree.  Its filename was
     x86-mm-support-arch_mmap_rnd_bits-v5.patch

This patch was dropped because it was folded into x86-mm-support-arch_mmap_rnd_bits.patch

------------------------------------------------------
From: Daniel Cashman <dcashman@android.com>
Subject: x86-mm-support-arch_mmap_rnd_bits-v5

Signed-off-by: Daniel Cashman <dcashman@android.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/x86/Kconfig~x86-mm-support-arch_mmap_rnd_bits-v5 arch/x86/Kconfig
--- a/arch/x86/Kconfig~x86-mm-support-arch_mmap_rnd_bits-v5
+++ a/arch/x86/Kconfig
@@ -82,8 +82,8 @@ config X86
 	select HAVE_ARCH_KASAN			if X86_64 && SPARSEMEM_VMEMMAP
 	select HAVE_ARCH_KGDB
 	select HAVE_ARCH_KMEMCHECK
-	select HAVE_ARCH_MMAP_RND_BITS
-	select HAVE_ARCH_MMAP_RND_COMPAT_BITS if COMPAT
+	select HAVE_ARCH_MMAP_RND_BITS		if MMU
+	select HAVE_ARCH_MMAP_RND_COMPAT_BITS	if MMU && COMPAT
 	select HAVE_ARCH_SECCOMP_FILTER
 	select HAVE_ARCH_SOFT_DIRTY		if X86_64
 	select HAVE_ARCH_TRACEHOOK
_

Patches currently in -mm which might be from dcashman@android.com are

x86-mm-support-arch_mmap_rnd_bits.patch

