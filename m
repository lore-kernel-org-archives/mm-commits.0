From: akpm@linux-foundation.org
Subject: [merged] maintainers-mm-add-additional-include-files-to-listing.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:40:05 -0800
Message-ID: <20130222204005.993DC31C1C1@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:56601 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757637Ab3BVUkG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:40:06 -0500
Received: by mail-gh0-f201.google.com with SMTP id z19so103937ghb.0
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:40:06 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cody@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: mm: add additional include files to listing
has been removed from the -mm tree.  Its filename was
     maintainers-mm-add-additional-include-files-to-listing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: MAINTAINERS: mm: add additional include files to listing

Add gfp.h, mmzone.h, memory_hotplug.h & vmalloc.h to the "MEMORY
MANAGMENT" section so scripts/get_maintainer.pl can do a better job of
making recommendations.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN MAINTAINERS~maintainers-mm-add-additional-include-files-to-listing MAINTAINERS
--- a/MAINTAINERS~maintainers-mm-add-additional-include-files-to-listing
+++ a/MAINTAINERS
@@ -5021,6 +5021,10 @@ L:	linux-mm@kvack.org
 W:	http://www.linux-mm.org
 S:	Maintained
 F:	include/linux/mm.h
+F:	include/linux/gfp.h
+F:	include/linux/mmzone.h
+F:	include/linux/memory_hotplug.h
+F:	include/linux/vmalloc.h
 F:	mm/
 
 MEMORY RESOURCE CONTROLLER
_

Patches currently in -mm which might be from cody@linux.vnet.ibm.com are

origin.patch
linux-next.patch
mm-add-section_in_page_flags.patch
mm-add-use-zone_end_pfn-and-zone_spans_pfn.patch
mm-add-zone_is_empty-and-zone_is_initialized.patch
mm-page_alloc-add-a-vm_bug-in-__free_one_page-if-the-zone-is-uninitialized.patch
mmzone-add-pgdat_end_pfnis_empty-helpers-consolidate.patch
mm-page_alloc-add-informative-debugging-message-in-page_outside_zone_boundaries.patch
mm-page_alloc-add-informative-debugging-message-in-page_outside_zone_boundaries-fix.patch
mm-add-helper-ensure_zone_is_initialized.patch
mm-memory_hotplug-use-ensure_zone_is_initialized.patch
mm-memory_hotplug-use-pgdat_end_pfn-instead-of-open-coding-the-same.patch

