From: akpm@linux-foundation.org
Subject: + thp-fix-unsuitable-behavior-for-hwpoisoned-tail-page-fix.patch added to -mm tree
Date: Fri, 28 Jan 2011 15:29:50 -0800
Message-ID: <201101282329.p0SNToah001037@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35241 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751964Ab1A1Xac (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 28 Jan 2011 18:30:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, aarcange@redhat.com, andi@firstfloor.org, jin.dongming@np.css.fujitsu.com, seto.hidetoshi@jp.fujitsu.com


The patch titled
     thp-fix-unsuitable-behavior-for-hwpoisoned-tail-page-fix
has been added to the -mm tree.  Its filename is
     thp-fix-unsuitable-behavior-for-hwpoisoned-tail-page-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: thp-fix-unsuitable-behavior-for-hwpoisoned-tail-page-fix
From: Andrew Morton <akpm@linux-foundation.org>

fix unrelated typo in shake_page() comment

Cc: Andi Kleen <andi@firstfloor.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Jin Dongming <jin.dongming@np.css.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/memory-failure.c~thp-fix-unsuitable-behavior-for-hwpoisoned-tail-page-fix mm/memory-failure.c
--- a/mm/memory-failure.c~thp-fix-unsuitable-behavior-for-hwpoisoned-tail-page-fix
+++ a/mm/memory-failure.c
@@ -233,8 +233,8 @@ void shake_page(struct page *p, int acce
 	}
 
 	/*
-	 * Only all shrink_slab here (which would also
-	 * shrink other caches) if access is not potentially fatal.
+	 * Only call shrink_slab here (which would also shrink other caches) if
+	 * access is not potentially fatal.
 	 */
 	if (access) {
 		int nr;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
epoll-epoll_wait-should-not-use-timespec_add_ns-fix.patch
maintainers-fixup-simtec-support-email-entries-fix.patch
thp-fix-the-wrong-reported-address-of-hwpoisoned-hugepages-fix.patch
thp-fix-unsuitable-behavior-for-hwpoisoned-tail-page-fix.patch
mm-vmap-area-cache.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
leds-convert-bd2802-driver-to-dev_pm_ops-fix.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
backlight-add-backlight-type-fix.patch
backlight-add-backlight-type-fix-fix.patch
fs-ocfs2-dlm-dlmdomainc-avoid-a-gfp_atomic-allocation.patch
drivers-message-fusion-mptsasc-fix-warning.patch
drbd-fix-warning.patch
mm.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
arch-alpha-include-asm-ioh-s-extern-inline-static-inline.patch
epoll-fix-compiler-warning-and-optimize-the-non-blocking-path.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
exec_domain-establish-a-linux32-domain-on-config_compat-systems.patch
scatterlist-new-helper-functions.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix-fix.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

