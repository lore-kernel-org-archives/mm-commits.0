From: akpm@linux-foundation.org
Subject: +
 swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
 added to -mm tree
Date: Tue, 11 Jun 2013 14:24:05 -0700
Message-ID: <51b79575.YfZVR+IwWvvSTy0u%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43112 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754755Ab3FKVYG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jun 2013 17:24:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, shli@kernel.org, hannes@cmpxchg.org, fengguang.wu@intel.com

Subject: + swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch added to -mm tree
To: fengguang.wu@intel.com,hannes@cmpxchg.org,shli@kernel.org
From: akpm@linux-foundation.org
Date: Tue, 11 Jun 2013 14:24:05 -0700


The patch titled
     Subject: swap: swapin_nr_pages() can be static
has been added to the -mm tree.  Its filename is
     swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Fengguang Wu <fengguang.wu@intel.com>
Subject: swap: swapin_nr_pages() can be static

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
Cc: Shaohua Li <shli@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_state.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/swap_state.c~swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix mm/swap_state.c
--- a/mm/swap_state.c~swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix
+++ a/mm/swap_state.c
@@ -394,7 +394,7 @@ struct page *read_swap_cache_async(swp_e
 	return found_page;
 }
 
-unsigned long swapin_nr_pages(unsigned long offset)
+static unsigned long swapin_nr_pages(unsigned long offset)
 {
 	static unsigned long prev_offset;
 	unsigned int pages, max_pages, last_ra;
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

linux-next.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
mm-tune-vm_committed_as-percpu_counter-batching-size-fix.patch
fs-fs-writebackc-make-wb_do_writeback-as-static.patch
smp-give-warning-when-calling-smp_call_function_many-single-in-serving-irq.patch
fat-additions-to-support-fat_fallocate-fix.patch
crypto-add-lz4-cryptographic-api-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
debugging-keep-track-of-page-owner-now-depends-on-stacktrace_support.patch

