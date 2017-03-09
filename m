From: akpm@linux-foundation.org
Subject: + arm64-use-set_memoryh-header.patch added to -mm tree
Date: Thu, 09 Mar 2017 13:38:38 -0800
Message-ID: <58c1cb5e.keswpQERAlvaoMXK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36930 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751557AbdCIViz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Mar 2017 16:38:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: labbott@redhat.com, catalin.marinas@arm.com, mark.rutland@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: arm64: use set_memory.h header
has been added to the -mm tree.  Its filename is
     arm64-use-set_memoryh-header.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arm64-use-set_memoryh-header.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arm64-use-set_memoryh-header.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Laura Abbott <labbott@redhat.com>
Subject: arm64: use set_memory.h header

The set_memory_* functions have moved to set_memory.h. Use that header
explicitly.

Link: http://lkml.kernel.org/r/1488920133-27229-4-git-send-email-labbott@redhat.com
Signed-off-by: Laura Abbott <labbott@redhat.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/pageattr.c      |    1 +
 arch/arm64/net/bpf_jit_comp.c |    1 +
 2 files changed, 2 insertions(+)

diff -puN arch/arm64/mm/pageattr.c~arm64-use-set_memoryh-header arch/arm64/mm/pageattr.c
--- a/arch/arm64/mm/pageattr.c~arm64-use-set_memoryh-header
+++ a/arch/arm64/mm/pageattr.c
@@ -17,6 +17,7 @@
 #include <linux/vmalloc.h>
 
 #include <asm/pgtable.h>
+#include <asm/set_memory.h>
 #include <asm/tlbflush.h>
 
 struct page_change_data {
diff -puN arch/arm64/net/bpf_jit_comp.c~arm64-use-set_memoryh-header arch/arm64/net/bpf_jit_comp.c
--- a/arch/arm64/net/bpf_jit_comp.c~arm64-use-set_memoryh-header
+++ a/arch/arm64/net/bpf_jit_comp.c
@@ -27,6 +27,7 @@
 #include <asm/byteorder.h>
 #include <asm/cacheflush.h>
 #include <asm/debug-monitors.h>
+#include <asm/set_memory.h>
 
 #include "bpf_jit.h"
 
_

Patches currently in -mm which might be from labbott@redhat.com are

treewide-move-set_memory_-functions-away-from-cacheflushh.patch
arm-use-set_memoryh-header.patch
arm64-use-set_memoryh-header.patch
s390-use-set_memoryh-header.patch
x86-use-set_memoryh-header.patch
agp-use-set_memoryh-header.patch
drm-use-set_memoryh-header.patch
intel_th-use-set_memoryh-header.patch
watchdog-hpwdt-use-set_memoryh-header.patch
bpf-use-set_memoryh-header.patch
module-use-set_memoryh-header.patch
pm-hibernate-use-set_memoryh-header.patch
alsa-use-set_memoryh-header.patch
misc-sram-use-set_memoryh-header.patch
video-vermilion-use-set_memoryh-header.patch
treewide-decouple-cacheflushh-and-set_memoryh.patch

