From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-files-related-to-kdump.patch added to
 -mm tree
Date: Wed, 20 May 2020 17:47:54 -0700
Message-ID: <20200521004754.LjpBNWmrT%akpm@linux-foundation.org>
References: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726754AbgEUAr4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 20 May 2020 20:47:56 -0400
In-Reply-To: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bhe@redhat.com, dyoung@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: add files related to kdump
has been added to the -mm tree.  Its filename is
     maintainers-add-files-related-to-kdump.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-add-files-related-to-kdump.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-add-files-related-to-kdump.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: MAINTAINERS: add files related to kdump

Kdump is implemented based on kexec, however some files are only related
to crash dumping and missing, add them to KDUMP entry.

Link: http://lkml.kernel.org/r/20200520103633.GW5029@MiWiFi-R3L-srv
Signed-off-by: Baoquan He <bhe@redhat.com>
Acked-by: Dave Young <dyoung@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    5 +++++
 1 file changed, 5 insertions(+)

--- a/MAINTAINERS~maintainers-add-files-related-to-kdump
+++ a/MAINTAINERS
@@ -9185,6 +9185,11 @@ L:	kexec@lists.infradead.org
 S:	Maintained
 W:	http://lse.sourceforge.net/kdump/
 F:	Documentation/admin-guide/kdump/
+F:	fs/proc/vmcore.c
+F:	include/linux/crash_core.h
+F:	include/linux/crash_dump.h
+F:	include/uapi/linux/vmcore.h
+F:	kernel/crash_*.c
 
 KEENE FM RADIO TRANSMITTER DRIVER
 M:	Hans Verkuil <hverkuil@xs4all.nl>
_

Patches currently in -mm which might be from bhe@redhat.com are

maintainers-add-files-related-to-kdump.patch
mm-memmap_init-iterate-over-memblock-regions-rather-that-check-each-pfn.patch
mm-remove-unused-free_bootmem_with_active_regions.patch
mm-page_allocc-only-tune-sysctl_lowmem_reserve_ratio-value-once-when-changing-it.patch
mm-page_allocc-clear-out-zone-lowmem_reserve-if-the-zone-is-empty.patch
mm-vmstatc-do-not-show-lowmem-reserve-protection-information-of-empty-zone.patch
