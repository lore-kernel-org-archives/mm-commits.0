From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-page_owner-clean-up-init_pages_in_zone-v3-fix.patch removed from -mm
 tree
Date: Wed, 31 Jan 2018 16:00:12 -0800
Message-ID: <5a72588c.JVFxRi//s7wJnXuL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57824 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753425AbeBAAAN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 Jan 2018 19:00:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, osalvador@techadventures.net, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-page_owner-clean-up-init_pages_in_zone-v3-fix
has been removed from the -mm tree.  Its filename was
     mm-page_owner-clean-up-init_pages_in_zone-v3-fix.patch

This patch was dropped because it was folded into mm-page_owner-clean-up-init_pages_in_zone.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-page_owner-clean-up-init_pages_in_zone-v3-fix

coding style tweaks

Cc: Oscar Salvador <osalvador@techadventures.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/page_owner.c~mm-page_owner-clean-up-init_pages_in_zone-v3-fix mm/page_owner.c
--- a/mm/page_owner.c~mm-page_owner-clean-up-init_pages_in_zone-v3-fix
+++ a/mm/page_owner.c
@@ -539,6 +539,7 @@ static void init_pages_in_zone(pg_data_t
 	 */
 	for (; pfn < end_pfn; ) {
 		unsigned long block_end_pfn;
+
 		if (!pfn_valid(pfn)) {
 			pfn = ALIGN(pfn + 1, MAX_ORDER_NR_PAGES);
 			continue;
@@ -550,6 +551,7 @@ static void init_pages_in_zone(pg_data_t
 		for (; pfn < block_end_pfn; pfn++) {
 			struct page *page;
 			struct page_ext *page_ext;
+
 			if (!pfn_valid_within(pfn))
 				continue;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
mm-page_owner-clean-up-init_pages_in_zone.patch
tools-vm-new-option-to-specify-kpageflags-file-fix.patch

