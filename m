From: akpm@linux-foundation.org
Subject: + maintainers-add-konrad-as-the-swiotlb-maintainer.patch added to -mm tree
Date: Fri, 05 Oct 2012 13:37:52 -0700
Message-ID: <20121005203752.C21C41E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:58236 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756752Ab2JEUhx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:37:53 -0400
Received: by mail-gg0-f202.google.com with SMTP id i4so237748ggm.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:37:53 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: konrad.wilk@oracle.com, fujita.tomonori@lab.ntt.co.jp, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de, tony.luck@intel.com


The patch titled
     Subject: MAINTAINERS: Add Konrad as the SWIOTLB maintainer
has been added to the -mm tree.  Its filename is
     maintainers-add-konrad-as-the-swiotlb-maintainer.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: MAINTAINERS: Add Konrad as the SWIOTLB maintainer

Now that I've an IA64 box on top of the other boxes (IBM with Calgary-X,
Intel VT-d, AMD Vi, and AMD GART - that can use SWIOTLB as fallback) I can
reliably do regression testing.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Ingo Molnar <mingo@elte.hu>
Acked-by: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN MAINTAINERS~maintainers-add-konrad-as-the-swiotlb-maintainer MAINTAINERS
--- a/MAINTAINERS~maintainers-add-konrad-as-the-swiotlb-maintainer
+++ a/MAINTAINERS
@@ -7049,6 +7049,14 @@ S:	Maintained
 F:	Documentation/svga.txt
 F:	arch/x86/boot/video*
 
+SWIOTLB SUBSYSTEM
+M:	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
+L:	linux-kernel@vger.kernel.org
+S:	Supported
+F:	lib/swiotlb.c
+F:	arch/*/kernel/pci-swiotlb.c
+F:	include/linux/swiotlb.h
+
 SYSV FILESYSTEM
 M:	Christoph Hellwig <hch@infradead.org>
 S:	Maintained
_

Patches currently in -mm which might be from konrad.wilk@oracle.com are

origin.patch
linux-next.patch
maintainers-add-konrad-as-the-swiotlb-maintainer.patch
acpi_memhotplugc-fix-memory-leak-when-memory-device-is-unbound-from-the-module-acpi_memhotplug.patch
acpi_memhotplugc-free-memory-device-if-acpi_memory_enable_device-failed.patch
acpi_memhotplugc-remove-memory-info-from-list-before-freeing-it.patch
acpi_memhotplugc-dont-allow-to-eject-the-memory-device-if-it-is-being-used.patch
acpi_memhotplugc-bind-the-memory-device-when-the-driver-is-being-loaded.patch
acpi_memhotplugc-auto-bind-the-memory-device-which-is-hotplugged-before-the-driver-is-loaded.patch

