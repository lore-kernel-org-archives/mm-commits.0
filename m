From: akpm@linux-foundation.org
Subject: + memcg-fix-used-bit-handling-at-uncharge-in-thp-fix.patch added to -mm tree
Date: Wed, 19 Jan 2011 17:05:11 -0800
Message-ID: <201101200138.p0K1cxrS015393@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53538 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751537Ab1ATBji (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Jan 2011 20:39:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, balbir@linux.vnet.ibm.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg-fix-used-bit-handling-at-uncharge-in-thp-fix
has been added to the -mm tree.  Its filename is
     memcg-fix-used-bit-handling-at-uncharge-in-thp-fix.patch

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
Subject: memcg-fix-used-bit-handling-at-uncharge-in-thp-fix
From: Andrew Morton <akpm@linux-foundation.org>

include/linux/memcontrol.h:343: warning: return type defaults to 'int'

Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN include/linux/memcontrol.h~memcg-fix-used-bit-handling-at-uncharge-in-thp-fix include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-fix-used-bit-handling-at-uncharge-in-thp-fix
+++ a/include/linux/memcontrol.h
@@ -339,7 +339,8 @@ u64 mem_cgroup_get_limit(struct mem_cgro
 	return 0;
 }
 
-static inline mem_cgroup_split_huge_fixup(struct page *head, struct page *tail)
+static inline void mem_cgroup_split_huge_fixup(struct page *head,
+						struct page *tail)
 {
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm-compaction-prevent-division-by-zero-during-user-requested-compaction-fix.patch
fs-direct-ioc-dont-try-to-allocate-more-than-bio_max_pages-in-a-bio-fix.patch
memcg-fix-used-bit-handling-at-uncharge-in-thp-fix.patch
arch-alpha-include-asm-ioh-s-extern-inline-static-inline.patch
mm-vmap-area-cache.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
drivers-message-fusion-mptsasc-fix-warning.patch
mm.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
sigma-firmware-loader-for-analog-devices-sigmastudio-fix.patch
epoll-fix-compiler-warning-and-optimize-the-non-blocking-path.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
exec_domain-establish-a-linux32-domain-on-config_compat-systems.patch
scatterlist-new-helper-functions.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

