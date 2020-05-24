From: akpm@linux-foundation.org
Subject: [merged] maintainers-add-files-related-to-kdump.patch
 removed from -mm tree
Date: Sun, 24 May 2020 16:18:45 -0700
Message-ID: <20200524231845.XgX9wT5Qm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388556AbgEXXSp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 24 May 2020 19:18:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bhe@redhat.com, dyoung@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: add files related to kdump
has been removed from the -mm tree.  Its filename was
     maintainers-add-files-related-to-kdump.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

mm-memmap_init-iterate-over-memblock-regions-rather-that-check-each-pfn.patch
mm-memmap_init-iterate-over-memblock-regions-rather-that-check-each-pfn-fix-2.patch
mm-remove-unused-free_bootmem_with_active_regions.patch
mm-page_allocc-only-tune-sysctl_lowmem_reserve_ratio-value-once-when-changing-it.patch
mm-page_allocc-clear-out-zone-lowmem_reserve-if-the-zone-is-empty.patch
mm-vmstatc-do-not-show-lowmem-reserve-protection-information-of-empty-zone.patch
