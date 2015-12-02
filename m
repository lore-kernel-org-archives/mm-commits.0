From: akpm@linux-foundation.org
Subject: + x86-mm-support-arch_mmap_rnd_bits-v5.patch added to -mm tree
Date: Tue, 01 Dec 2015 16:24:59 -0800
Message-ID: <565e3a5b.J7lBEDPIEfLcgilq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59692 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932168AbbLBAZA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Dec 2015 19:25:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dcashman@android.com, keescook@chromium.org, mm-commits@vger.kernel.org


The patch titled
     Subject: x86-mm-support-arch_mmap_rnd_bits-v5
has been added to the -mm tree.  Its filename is
     x86-mm-support-arch_mmap_rnd_bits-v5.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/x86-mm-support-arch_mmap_rnd_bits-v5.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/x86-mm-support-arch_mmap_rnd_bits-v5.patch

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

mm-mmap-add-new-proc-tunable-for-mmap_base-aslr-v4.patch
mm-mmap-add-new-proc-tunable-for-mmap_base-aslr-v5.patch
arm-mm-support-arch_mmap_rnd_bits-v5.patch
arm64-mm-support-arch_mmap_rnd_bits-v4.patch
arm64-mm-support-arch_mmap_rnd_bits-v5.patch
x86-mm-support-arch_mmap_rnd_bits-v5.patch

